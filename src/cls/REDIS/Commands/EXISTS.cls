Class REDIS.Commands.EXISTS Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

Parameter maxParameters = 1;

/// Method for returning value setted under specific key
ClassMethod RunCommand(cmdPipeline As %List) As %String
{

	set result = ""
	
	if ( $DATA(^data($LIST(cmdPipeline,2))) '= 0 ){
		if ( $DATA(^data($LIST(cmdPipeline,2),"expires")) '= 0 ){
			   if ( ..GetLeftTimeToLive($LIST(cmdPipeline,2)) > 0 ){		
				set result = "(integer) 1"
			   } else{
				set result = "(integer) 0"
			   }
		} else{
			set result = "(integer) 1"
		}
	} else{
	   set result = "(integer) 0"
	}
	
	return result
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

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  EXISTS key"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Test if the specified key exists. The command returns ""1"" if the key exists, otherwise ""0"" is returned."_$char(10,13)_
	" 		Note that even keys set with an empty string as value will return ""1"". "_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_$char(10,13)
    _$Char(27)_"!<HTML><ul><ul><ul><ul><li>0 if the key exists.</li>"_
	"<li>1 if the key does not exist.</li></ul></ul></ul></ul></HTML>"_$char(10,13)
}

}

