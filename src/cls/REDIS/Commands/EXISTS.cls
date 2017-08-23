Class REDIS.Commands.EXISTS Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
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
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	return result
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

