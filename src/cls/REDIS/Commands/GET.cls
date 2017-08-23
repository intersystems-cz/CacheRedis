Class REDIS.Commands.GET Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

Parameter maxParameters = 1;

/// constant min parameters
Parameter minParameters = 1;

/// Method for returning value setted under specific key
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))
	
	if ( ##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1) '= 0 ){
		if ( ##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),2) '= 0 ){
		   if ( ##class(REDIS.CommandsHandling.Functions).GetLeftTimeToLive($LIST(cmdPipeline,2)) > 0 ){		
		   		set result = ##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
		   } else{
		   		set result = "(NIL)"
		   }
		} else{		
		   set result = ##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
		}
	} else{
	   set result = "(NIL)"
	}
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	return result
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

