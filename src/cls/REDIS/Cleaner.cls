Include REDIS.settings

/// This class contain ClassMethods for JOB Cleaner 
/// that cleans all outdated Redis variables.
Class REDIS.Cleaner Extends %Persistent
{

ClassMethod CleanUp()
{
		
	s time = $O(@("^"_$$$CLEANER_"("""")"))
	while (time '= "") {
	  if (..GetHangTime() <= 0) {
	  	for i=1:1:$LL(@("^"_$$$CLEANER_"("""_time_""")")){
	  		do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LI(@("^"_$$$CLEANER_"("""_time_""")"),i))
	  		s globalName = $LI(@("^"_$$$CLEANER_"("""_time_""")"),i)
	  		k @("^"_$$$DATA_"("""_globalName_""")")
	  		do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal(globalName)
	  	}
	  	
	  	k @("^"_$$$CLEANER_"("""_time_""")")
	  }
	  else{
	  	b
	  }
	  s time = $O(@("^"_$$$CLEANER_"("""")"))
	}
}

// Function only for cleaner to get time when next key should expire

ClassMethod GetHangTime() As %String
{
	
	if ( $O(@("^"_$$$CLEANER_"("""")")) '= "") {
		s actualTime = $NOW()
		s dateval = $P(actualTime,",",1)
		s timeval = $P(actualTime,",",2)
		// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
		s actualTimeInSec = dateval*24*3600 + timeval		
		s timeLeftToLive = $O(@("^"_$$$CLEANER_"("""")")) - actualTimeInSec
		
		ret timeLeftToLive
		
	} else{
		ret 999999999999999999
	}
}

ClassMethod Run()
{

 // save PID of this job to good known global
 s @("^"_$$$CLEANERPID) = $J

	while 1 { // loop forever
	do $System.Util.SetInterruptEnable($$$YES)
	  try {
	    s sleepTime = ..GetHangTime()
	    while (sleepTime <= 0) {
	      do ..CleanUp()
	      s sleepTime = ..GetHangTime()
	    }
	    h sleepTime
	      
	  } catch (e) {
	  	s ^debug = e	  	
	    // todo: e = <INTERRUPT> error?
	  }
	}
}

Storage Default
{
<Data name="CleanerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.CleanerD</DataLocation>
<DefaultData>CleanerDefaultData</DefaultData>
<IdLocation>^REDIS.CleanerD</IdLocation>
<IndexLocation>^REDIS.CleanerI</IndexLocation>
<StreamLocation>^REDIS.CleanerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

