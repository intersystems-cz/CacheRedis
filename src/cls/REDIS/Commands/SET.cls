Class REDIS.Commands.SET Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 4;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	// test number of parameters between 2 or 4
	set paramNum = ($LISTLENGTH(cmdPipeline)-1)
	
	/// means that classic function manner "SET VARIABLE" is used
	if (paramNum = 2){
		set result = ..SetVariable(cmdPipeline)
	}
	elseif (paramNum = 3){
		
		set option = $ZCONVERT($LIST(cmdPipeline,4),"U")		
		/// if variable not exist, set it
		if (option = "NX"){
			if ('$DATA(@("^"_$LIST(cmdPipeline,2)))){
				set result = ..SetVariable(cmdPipeline)
			}else{
				set result = "(nil)"
			}
		}
		/// if variable exist, implement it
		elseif(option = "XX"){
			if ($DATA(@("^"_$LIST(cmdPipeline,2)))){
				set result = ..SetVariable(cmdPipeline)
			}else{
				set result = "(nil)"
			}
		}
		else{
			set result = ##class(REDIS.Terminal.ErrorHandler).SyntaxError(" Option """_option_""" not exist, see ""help set""")
		}
	}
	elseif (paramNum = 4){
		set option = $ZCONVERT($LIST(cmdPipeline,4),"U")
		if (option = "EX"){
			// toDo test if number
			if ($NUMBER($LIST(cmdPipeline,5)) '= ""){
				do ##class(REDIS.Commands.SET).SetTimedVariable(cmdPipeline,$LIST(cmdPipeline,5))
				set result = "OK"
			}
			else
			{
				set result = ##class(REDIS.Terminal.ErrorHandler).NotNumber(cmdPipeline)
			}			
		}
		elseif(option = "PX"){
			
			if ($NUMBER($LIST(cmdPipeline,5)) '= ""){
				// conversion to miliseconds:
				set $LIST(cmdPipeline,5) = $LIST(cmdPipeline,5)/1000
				do ##class(REDIS.Commands.SET).SetTimedVariable(cmdPipeline,$LIST(cmdPipeline,5))
				set result = "OK"
			}
			else
			{
				set result = ##class(REDIS.Terminal.ErrorHandler).NotNumber(cmdPipeline)
			}
			
		}
		else{
			set result = ##class(REDIS.Terminal.ErrorHandler).SyntaxError(" Option """_option_""" not exist, see ""help set""")
		}
	}
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  SET key value"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Set key to hold the string value. If key already "_$char(10,13)_
	$char(9)_$char(9)_"holds a value, it is overwritten, regardless of its type. Any previous time to live "_$char(10,13)_
	$char(9)_$char(9)_"associated with the key is discarded on successful SET operation. "_$char(10,13)_
	$char(27)_"[35m"_"  OPTIONS:"_$char(27)_"[0m"_$char(10,13)_
	$Char(27)_"!<HTML><ul><ul><ul><ul><li>EX seconds -- Set the specified expire time, in seconds.</li>"_
	"<li>PX milliseconds -- Set the specified expire time, in milliseconds.</li><li>NX -- Only set the key if it does not already exist.</li>"_
	"<li>XX -- Only set the key if it already exist.</li></ul></ul></ul></ul></HTML>"_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Status code reply: OK if SET was executed correctly. Null multi-bulk reply: a Null Bulk Reply"_$char(10,13)_
    $char(9)_$char(9)_"is returned if the SET operation was not performed becase the user specified the NX or XX "_$char(10,13)_
    $char(9)_$char(9)_"option but the condition was not met."_$char(10,13)
}

/// Sets the key-value pair variable with timing
ClassMethod SetTimedVariable(cmdPipeline As %List, numSeconds As %String)
{
	 
	/// test if variable exist as expire variable
	if ($data(^data($LIST(cmdPipeline,2),"expires")) '= 0 ){
		kill ^cleaner(^data($LIST(cmdPipeline,2),"expires"))
		kill ^data($LIST(cmdPipeline,2))
	}
	
	set actualTime = $NOW()
	set dateval = $PIECE(actualTime,",",1)
	set timeval = $PIECE(actualTime,",",2)
	// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
	set actualTimeInSec = dateval*24*3600 + timeval
	set whenToKillVariable = actualTimeInSec + numSeconds
	
	set ^data($LIST(cmdPipeline,2)) = $LIST(cmdPipeline,3)
	set ^data($LIST(cmdPipeline,2), "expires") = whenToKillVariable
	
	set test = $get(^cleaner(whenToKillVariable))
	if (test '= "") {
	  set $LIST(^cleaner(whenToKillVariable), *+1) = $LIST(cmdPipeline,2)
	} else {
	  set ^cleaner(whenToKillVariable) = $LB($LIST(cmdPipeline,2))
	}
	
	// interrupt cleaner process to recalculate hang time
	do $System.Util.SendInterrupt(^cleanerPid)
	//w "interrupted process "_^cleanerPid,!
}

/// Sets the key-value pair variable without timing
ClassMethod SetVariable(cmdPipeline As %List) As %String
{
	set globalName = $LIST(cmdPipeline,2)
	set valueToSet = $LIST(cmdPipeline,3)
	set result = $XECUTE("(value) SET ^"_globalName_"=value QUIT ""OK""",valueToSet)	
	return result
}

}

