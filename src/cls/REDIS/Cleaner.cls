/// This class contain ClassMethods for JOB Cleaner 
/// that cleans all outdated Redis variables.
Class REDIS.Cleaner Extends %Persistent
{

ClassMethod CleanUp()
{
	set time = $order(^cleaner(""))
	while (time '= "") {
	  if (..GetHangTime() <= 0) {
	  	for i=1:1:$listlength(^cleaner(time)){
	  		do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(^cleaner(time),i))
	  		set varName = $LIST(^cleaner(time),i)
	  		kill ^data(varName)
	  		do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal(varName)
	  	}
	  	
	  	kill ^cleaner(time)
	  }
	  else{
	  	break
	  }
	  set time = $order(^cleaner(""))
	}
}

// Function only for cleaner to get time when next key should expire

ClassMethod GetHangTime() As %String
{
	
	if ( $order(^cleaner("")) '= "") {
		set actualTime = $NOW()
		set dateval = $PIECE(actualTime,",",1)
		set timeval = $PIECE(actualTime,",",2)
		// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
		set actualTimeInSec = dateval*24*3600 + timeval		
		set timeLeftToLive = $order(^cleaner("")) - actualTimeInSec
		
		return timeLeftToLive
		
	} else{
		return 999999999999999999
	}
}

ClassMethod Run()
{

 // save PID of this job to good known global
 set ^cleanerPid = $JOB
 set var = 0

	while 1 { // loop forever
	do $System.Util.SetInterruptEnable($$$YES)
	  try {
	    set sleepTime = ..GetHangTime()
	    while (sleepTime <= 0) {
	      do ..CleanUp()
	      set sleepTime = ..GetHangTime()
	    }
	    hang sleepTime
	      
	  } catch (e) {
	  	set ^debug = e	  	
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

