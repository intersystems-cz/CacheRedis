Include REDIS.settings

/// All commands use functions from this scope. This is class containing main logic for all commands.
/// Having all functions in disposition for all commands in one place means not looping lock == no deadlock.
/// (there is now no need to run commands itself between them for their functionallity, but just running functionallity)
Class REDIS.CommandsHandling.Functions
{

/// Shortucts for future developers:
/// 
/// ^data(globalName) 				<==> 	@("^"_$$$DATA_"("""_globalName_""")")
/// ^data(globalName,"expires") 	<==> 	@("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")")
/// ^data(globalName,"type")		<==>	@("^"_$$$DATA_"("""_globalName_""","""_$$$TYPE_""")")
/// ^cleaner(timeToExp)				<==>	@("^"_$$$CLEANER_"("""_timeToExp_""")")
/// ^cleanerPid						<==>	@("^"_$$$CLEANERPID)
/// Sets the key-value pair variable with timing
ClassMethod SetTimedVariable(globalName As %String, globalValue As %String, numSeconds As %String)
{
	/// test if variable exist as expire variable
	if ($D(@("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")")) '= 0 ){
		s oldExpiration = @("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")")
	} else
	{
		s oldExpiration = ""
	}
	
	s actualTime = $NOW()
	s dateval = $P(actualTime,",",1)
	s timeval = $P(actualTime,",",2)
	// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
	s actualTimeInSec = dateval*24*3600 + timeval
	s whenToKillVariable = actualTimeInSec + numSeconds
	
	s @("^"_$$$DATA_"("""_globalName_""")") = globalValue
	s @("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")") = whenToKillVariable
							
		// test if in oldExpiration global is saved in list just one record
	if (oldExpiration '= ""){
		if ($LL(@("^"_$$$CLEANER_"("""_oldExpiration_""")")) = 1){
			// kill whole list
			k @("^"_$$$CLEANER_"("""_oldExpiration_""")")
		} else{
			// kill only specific member of list
			s $LI(@("^"_$$$CLEANER_"("""_oldExpiration_""")"),$LF(@("^"_$$$CLEANER_"("""_oldExpiration_""")"),globalName)) = ""
		}
	}
	
	s test = $G(@("^"_$$$CLEANER_"("""_whenToKillVariable_""")"))
	if (test '= "") {
	  s $LI(@("^"_$$$CLEANER_"("""_whenToKillVariable_""")"), *+1) = globalName
	} else {
	  s @("^"_$$$CLEANER_"("""_whenToKillVariable_""")") = $LB(globalName)
	}
	
	// interrupt cleaner process to recalculate hang time
	do $System.Util.SendInterrupt(@("^"_$$$CLEANERPID))
	//w "interrupted process "_^cleanerPid,!
}

/// Sets the key-value pair variable without timing
ClassMethod SetVariable(globalName As %String, valueToSet As %String) As %String
{
	s result = $XECUTE("(value) SET ^"_$$$DATA_"("""_globalName_""")=value QUIT ""OK""",valueToSet)	
	ret result
}

/// Will return string length of data under globalName
ClassMethod GetStrlen(globalName As %String) As %Integer
{
	ret $L(@("^"_$$$DATA_"("""_globalName_""")"))
}

/// Will increase global by given number
ClassMethod IncreaseBy(globalName As %String, number As %Integer)
{
	s @("^"_$$$DATA_"("""_globalName_""")") = @("^"_$$$DATA_"("""_globalName_""")") + number
}

/// Will decrease global by given number
ClassMethod DecreaseBy(globalName As %String, number As %Integer)
{
	s @("^"_$$$DATA_"("""_globalName_""")") = @("^"_$$$DATA_"("""_globalName_""")") - number
}

/// Will return data stored under global
ClassMethod GetData(globalName As %String) As %String
{
	if (@("^"_$$$DATA_"("""_globalName_""")") = ""){
		ret """"""
	}else{
		ret @("^"_$$$DATA_"("""_globalName_""")")
	}
}

/// Will remove globalname from ^data global
ClassMethod RemoveGlobal(globalName As %String)
{
	// test if variable is not timed and should be killed in cleaner
	if ($D(@("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")"))){
	
		s timeToExp = @("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")")
		
		if ($LL(@("^"_$$$CLEANER_"("""_timeToExp_""")"))>1){
			s index = $LF(@("^"_$$$CLEANER_"("""_timeToExp_""")"),globalName)
			s $LI(@("^"_$$$CLEANER_"("""_timeToExp_""")"),index,index) = ""
		}else{
			k @("^"_$$$CLEANER_"("""_timeToExp_""")")
		}
	}
	k @("^"_$$$DATA_"("""_globalName_""")")
}

/// Will lock specific global due to consistency
ClassMethod LockGlobal(globalName As %String)
{
	L +(@("^"_$$$DATA_"("""_globalName_""")")):0
}

/// Will unlock specific global due to consistency
ClassMethod UnlockGlobal(globalName As %String)
{
	L -(@("^"_$$$DATA_"("""_globalName_""")")):0
}

/// Retrieve left time to live of timed variable
ClassMethod GetLeftTimeToLive(globalName As %String) As %String
{

		s actualTime = $NOW()
		s dateval = $P(actualTime,",",1)
		s timeval = $P(actualTime,",",2)
		
		// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
		s actualTimeInSec = dateval*24*3600 + timeval
				
		s timeLeftToLive = @("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")") - actualTimeInSec
		
		ret timeLeftToLive
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
		s result = $D(@("^"_$$$DATA_"("""_globalName_""")"))
	}
	else{
		if (option = 2){
			s result = $D(@("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")"))
		}else{
			// option == 3
			if ($D(@("^"_$$$DATA_"("""_globalName_""","""_$$$TYPE_""")"))){
				s result = @("^"_$$$DATA_"("""_globalName_""","""_$$$TYPE_""")")
			}else{
				s result = 0
			}
		}
	}
	ret result
}

/// Will lock specific global due to consistency
/// option values:
///   0 == test value of given number stored under string
///   1 == test value stored in global under variable name
ClassMethod IsRedisNumber(variable As %String, option As %Integer) As %Integer
{
	s result = -1
	if (option = 0){
		s result = $isvalidnum(variable)&&(+variable\1=+variable) 
	}elseif(option = 1){
		s result = $isvalidnum(@("^"_$$$DATA_"("""_variable_""")"))&&
		(+(@("^"_$$$DATA_"("""_variable_""")"))\1=+(@("^"_$$$DATA_"("""_variable_""")")))
	}
	
	ret result
}

/// Test if cleaner JOB PID exist
ClassMethod IsCleanerRunning() As %Boolean
{
	s isRunning = 0
	s pid=""
	 FOR i=1:1 { 
	 	s pid=$ORDER(^$JOB(pid)) 
	 	s JOB(i)=pid 
	 	if (pid = @("^"_$$$CLEANERPID)){
	 		s isRunning = 1
	 	} 
	 	QUIT:pid=""
	 }
	
	ret isRunning
}

/// Kill cleaner JOB running under cleanerPID
ClassMethod KillCleaner()
{
	do ##class(%SYSTEM.Process).Terminate(@("^"_$$$CLEANERPID))
}

}

