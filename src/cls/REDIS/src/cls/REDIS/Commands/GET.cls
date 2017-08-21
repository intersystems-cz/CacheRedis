Class REDIS.Commands.GET Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

Parameter maxParameters = 1;

/// Method for returning value setted under specific key
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	if ( $DATA(^data($LIST(cmdPipeline,2))) '= 0 ){
		if ( $DATA(^data($LIST(cmdPipeline,2),"expires")) '= 0 ){
			   if ( ..GetLeftTimeToLive($LIST(cmdPipeline,2)) > 0 ){		
				return ^data($LIST(cmdPipeline,2))
			   } else{
				set result = "(NIL)"
			   }
		} else{
			return ^data($LIST(cmdPipeline,2))
		}
	} else{
	   set result = "(NIL)"
	}
	
	return result	

	/* //OLD IMPLMENTATION

	if ($DATA(^data($LIST(cmdPipeline,2)),"expires")){
		set status =  @("^"_$LIST(cmdPipeline,2))
	}else{
		set status = "(nil)"
	}
	*/
	return status
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
	return $char(10,13)_$Char(27)_"[33m"_"  GET key"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Get the value of the specified key. If the key does not exist the special"_$char(10,13)_
	" 		value 'nil' is returned. If the value stored at key is not a string an "_$char(10,13)_
	"		error is returned because GET can only handle string values. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Bulk reply"_$char(10,13)
}

}

