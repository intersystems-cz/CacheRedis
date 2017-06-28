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
				JOB ##class(REDIS.Commands.SET).SetTimedVariable(cmdPipeline,$LIST(cmdPipeline,5))
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
				JOB ##class(REDIS.Commands.SET).SetTimedVariable(cmdPipeline,$LIST(cmdPipeline,5))
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
	
	 /*// better implementation of timing with variables:
	
	set actualTime = $now()
	set timeExpire = "notDefined"
	set days = $PIECE((($piece(actualTime,",",*)+numSeconds)/86399),".")
	
	if (days = "")
	{
		// the variable will expire today, no day ++ is needed
		set timeExpire = ($piece(actualTime,","))_","_($piece(actualTime,",",*) + numSeconds)
		
	}else{
		// the variable will expire another day, it is needed
		// to write "days"++ to actualTime to compute expiration time
		// , other seconds left must be added to seconds of actualTime
		set overlappingSeconds = ($piece(actualTime,",",*)+numSeconds
		set timeExpire = ($piece(actualTime,","))+days)_","_(overlappingSeconds - ((overlappingSeconds\86399)*86399))
	}
	// expiration time is prepared and can be saved into globals
	// , dont forget to set global ^expires for garbadge collctor job
	set ^expires(timeExpire) = ("^"_$LIST(cmdPipeline,2))
	set ^data(("^"_$LIST(cmdPipeline,2))) = $LB(timeExpire,$LIST(cmdPipeline,3))
	
	*/
	
	
	
	// set value to global / create global as key/value pair
	set @("^"_$LIST(cmdPipeline,2)) = $LIST(cmdPipeline,3)
	
	HANG numSeconds
	
	kill @("^"_$LIST(cmdPipeline,2))
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

