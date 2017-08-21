Class REDIS.Commands.EXPIRE Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 2;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	
	if ($DATA(^data($LIST(cmdPipeline,2)))){
			/// test if variable exist as expire variable
		if ($DATA(^data($LIST(cmdPipeline,2),"expires")) '= 0 ){
			//kill ^cleaner(^data($LIST(cmdPipeline,2),"expires"))
			//kill ^data($LIST(cmdPipeline,2))
			   set value = ^data($LIST(cmdPipeline,2))

			   if ( ..GetLeftTimeToLive($LIST(cmdPipeline,2)) > 0 && $DATA(value)){
			   
			   		set num = $LIST(cmdPipeline,3)		
						
					// TODO TEST IF seconds($LIST(cmdPipeline,3)) is NUMBER, 
					// redis allows even 00023 format interpreted as 23s
					if ($isvalidnum(num)&&(+num\1=+num)) {
					 	
						set actualTime = $NOW()
						set dateval = $PIECE(actualTime,",",1)
						set timeval = $PIECE(actualTime,",",2)
						// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
						set actualTimeInSec = dateval*24*3600 + timeval
						set whenToKillVariable = actualTimeInSec + $LIST(cmdPipeline,3)
						
						// this line is just to approve consistency - but not 100% == TODO = locks needed
						set ^data($LIST(cmdPipeline,2)) = value
						// get oldExpiration time
						set oldExpiration = ^data($LIST(cmdPipeline,2),"expires")
						// set new expiration time
						set ^data($LIST(cmdPipeline,2), "expires") = whenToKillVariable
						
						
						// test if in oldExpiration global is saved in list just one record
						if ($LL(^cleaner(oldExpiration)) = 1){
							// kill whole list
							kill ^cleaner(oldExpiration)
						} else{
							// kill only specific member of list
							set $LIST(^cleaner(oldExpiration),$LISTFIND(^cleaner(oldExpiration),value)) = ""
						}
						
						set test = $get(^cleaner(whenToKillVariable))
						if (test '= "") {
						  set $LIST(^cleaner(whenToKillVariable), *+1) = $LIST(cmdPipeline,2)
						} else {
						  set ^cleaner(whenToKillVariable) = $LB($LIST(cmdPipeline,2))
						}
						
						// interrupt cleaner process to recalculate hang time
						do $System.Util.SendInterrupt(^cleanerPid)
						
						set result = "(integer) 1"
					  
					} else {
					 set result = ##class(REDIS.Terminal.ErrorHandler).NotNumber(cmdPipeline)
					}

					
			   } else{
				set result = "(integer) 0"
			   }
		}else {
		
			set value = ^data($LIST(cmdPipeline,2))
			set num = $LIST(cmdPipeline,3)	
			
			if ($isvalidnum(num)&&(+num\1=+num)) {
					 
						set actualTime = $NOW()
						set dateval = $PIECE(actualTime,",",1)
						set timeval = $PIECE(actualTime,",",2)
						// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
						set actualTimeInSec = dateval*24*3600 + timeval
						set whenToKillVariable = actualTimeInSec + $LIST(cmdPipeline,3)
						
						set ^data($LIST(cmdPipeline,2)) = value
						set ^data($LIST(cmdPipeline,2), "expires") = whenToKillVariable
						
						set test = $get(^cleaner(whenToKillVariable))
						if (test '= "") {
						  set $LIST(^cleaner(whenToKillVariable), *+1) = $LIST(cmdPipeline,2)
						} else {
						  set ^cleaner(whenToKillVariable) = $LB($LIST(cmdPipeline,2))
						}
						
						// interrupt cleaner process to recalculate hang time
						do $System.Util.SendInterrupt(^cleanerPid)
						
						set result = "(integer) 1"
					  
					} else {
					 set result = ##class(REDIS.Terminal.ErrorHandler).NotNumber(cmdPipeline)
					}
		
			
		}
	}else{
		set result = "(integer) 0"
	}
	
	// OLD IMPLEMENTATION:
	/*
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
			if ('$DATA(^data($LIST(cmdPipeline,2)))){
				set result = ..SetVariable(cmdPipeline)
			}else{
				set result = "(nil)"
			}
		}
		/// if variable exist, implement it
		elseif(option = "XX"){
			if ($DATA(^data($LIST(cmdPipeline,2)))){
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
	*/
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  EXPIRE key seconds"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Set a timeout on key. After the timeout has expired, the "_$char(10,13)_
	$char(9)_$char(9)_"key will automatically be deleted. A key with an associated timeout is often said "_$char(10,13)_
	$char(9)_$char(9)_"to be volatile in Redis terminology. For more read the official documentation. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" integer reply, specifically:"_$char(10,13)_
    $Char(27)_"!<HTML><ul><ul><ul><ul><li>1 if the timeout was set.</li>"_
	"<li>0 if key does not exist or the timeout could not be set.</li></ul></ul></ul></ul></HTML>"_$char(10,13)
}

ClassMethod GetLeftTimeToLive(varName As %String) As %String
{

		set actualTime = $NOW()
		set dateval = $PIECE(actualTime,",",1)
		set timeval = $PIECE(actualTime,",",2)
		
		// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
		set actualTimeInSec = dateval*24*3600 + timeval
				
		set timeLeftToLive = ^data(varName,"expires") - actualTimeInSec
		
		return timeLeftToLive
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

}

