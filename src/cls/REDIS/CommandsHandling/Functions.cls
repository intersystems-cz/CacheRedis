/// All commands use functions from this scope. This is class containing main logic for all commands.
/// Having all functions in disposition for all commands in one place means not looping lock == no deadlock.
/// (there is now no need to run commands itself between them for their functionallity, but just running functionallity)
Class REDIS.CommandsHandling.Functions
{

/// Sets the key-value pair variable with timing
ClassMethod SetTimedVariable(globalName As %String, globalValue As %String, numSeconds As %String)
{
	 
	/// test if variable exist as expire variable
	if ($data(^data(globalName,"expires")) '= 0 ){
		set oldExpiration = ^data(globalName,"expires")
	} else
	{
		s oldExpiration = ""
	}
	
	set actualTime = $NOW()
	set dateval = $PIECE(actualTime,",",1)
	set timeval = $PIECE(actualTime,",",2)
	// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
	set actualTimeInSec = dateval*24*3600 + timeval
	set whenToKillVariable = actualTimeInSec + numSeconds
	
	set ^data(globalName) = globalValue
	set ^data(globalName, "expires") = whenToKillVariable
							
		// test if in oldExpiration global is saved in list just one record
	if (oldExpiration '= ""){
		if ($LL(^cleaner(oldExpiration)) = 1){
			// kill whole list
			kill ^cleaner(oldExpiration)
		} else{
			// kill only specific member of list
			set $LIST(^cleaner(oldExpiration),$LISTFIND(^cleaner(oldExpiration),value)) = ""
		}
	}
	
	set test = $get(^cleaner(whenToKillVariable))
	if (test '= "") {
	  set $LIST(^cleaner(whenToKillVariable), *+1) = globalName
	} else {
	  set ^cleaner(whenToKillVariable) = $LB(globalName)
	}
	
	// interrupt cleaner process to recalculate hang time
	do $System.Util.SendInterrupt(^cleanerPid)
	//w "interrupted process "_^cleanerPid,!
}

/// Sets the key-value pair variable without timing
ClassMethod SetVariable(globalName As %String, valueToSet As %String) As %String
{
	set result = $XECUTE("(value) SET ^data("""_globalName_""")=value QUIT ""OK""",valueToSet)	
	return result
}

/// Will return string length of data under globalName
ClassMethod GetStrlen(globalName As %String) As %Integer
{
	return $length(^data(globalName))
}

/// Will increase global by given number
ClassMethod IncreaseBy(globalName As %String, number As %Integer)
{
	set ^data(globalName) = ^data(globalName) + number
}

/// Will decrease global by given number
ClassMethod DecreaseBy(globalName As %String, number As %Integer)
{
	set ^data(globalName) = ^data(globalName) - number
}

/// Will return data stored under global
ClassMethod GetData(globalName As %String) As %String
{
	return ^data(globalName)
}

/// Will remove globalname from ^data global
ClassMethod RemoveGlobal(globalName As %String)
{
	// test if variable is not timed and should be killed in cleaner
	if ($DATA(^data(globalName,"expires"))){
	
		set timeToExp = ^data(globalName,"expires")
		
		if ($LL(^cleaner(timeToExp))>1){
			set index = $LF(^cleaner(timeToExp),globalName)
			set $list(^cleaner(timeToExp),index,index) = ""
		}else{
			kill ^cleaner(timeToExp)
		}
	}
	kill ^data(globalName)
}

/// Will lock specific global due to consistency
ClassMethod LockGlobal(globalName As %String)
{
	L +(^data(globalName)):0
}

/// Will unlock specific global due to consistency
ClassMethod UnlockGlobal(globalName As %String)
{
	L -(^data(globalName)):0
}

/// Retrieve left time to live of timed variable
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

/// Will check if global exist
/// option values:
/// 	1 == just global existency check
/// 	2 == check if global is key with expiration
/// 	3 == check type of global - will return 0 if it is string, else name of type
ClassMethod IsGlobal(globalName As %String, option As %Integer) As %String
{
	s result = ""
	
	if (option = 1){
		s result = $DATA(^data(globalName))
	}
	else{
		if (option = 2){
			s result = $DATA(^data(globalName,"expires"))
		}else{
			// option == 3
			if ($DATA(^data(globalName,"type"))){
				s result = ^data(globalName,"type")
			}else{
				s result = 0
			}
		}
	}
	return result
}

}

