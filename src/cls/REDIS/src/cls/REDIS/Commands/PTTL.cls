Class REDIS.Commands.PTTL Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 1;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	
	if ($DATA(^data($LIST(cmdPipeline,2)))){
			/// test if variable exist as expire variable
		if ($DATA(^data($LIST(cmdPipeline,2),"expires")) '= 0 ){

			   set value = ^data($LIST(cmdPipeline,2))
			   set lttl = ..GetLeftTimeToLive($LIST(cmdPipeline,2))

			   if ( lttl > 0 && $DATA(value)){
			   
			   		set result = "(integer) "_$FNUMBER((lttl*1000),"",0)
					
			   } else{
				set result = "(integer) -2"
			   }
		}else {
		
			set result = "(integer) -1"
			
		}
	}else{
		set result = "(integer) -2"
	}
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  PTTL key "_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Like TTL this command returns the remaining time to live "_$char(10,13)_
	$char(9)_$char(9)_"of a key that has an expire set, with the sole difference that TTL returns the amount of remaining"_$char(10,13)_
	$char(9)_$char(9)_"time in seconds while PTTL returns it in milliseconds. In Redis 2.6 or older the command"_$char(10,13)_
	$char(9)_$char(9)_"returns -1 if the key does not exist or if the key exist but has no associated expire. "_$char(10,13)_$char(10,13)_
	$char(9)_$char(9)_"Starting with Redis 2.8 the return value in case of error changed: "_$char(10,13)_
	
	$Char(27)_"!<HTML><ul><ul><ul><ul><li>The command returns -2 if the key does not exist.</li>"_
	"<li>The command returns -1 if the key exists but has no associated expire.</li></ul></ul></ul></ul></HTML>"_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Integer reply: TTL in milliseconds, or a negative value in order to signal an error (see the description above)."_$char(10,13)
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

}

