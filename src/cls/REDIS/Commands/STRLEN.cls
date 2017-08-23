Class REDIS.Commands.STRLEN Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 1;

/// constant min parameters
Parameter minParameters = 1;

/// The different types that can be returned are: string, list, set, zset and hash.
/// TODO LIST,SET,ZSET,HASH
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))
	if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){
	  s result = "(integer) "_##class(REDIS.CommandsHandling.Functions).GetStrlen($LIST(cmdPipeline,2))
	}else{
	  s result = "(integer) 0"
	}
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	QUIT result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  STRLEN key"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Returns the length of the string value stored at key. "_$char(10,13)_
	$char(9)_$char(9)_"An error is returned when key holds a non-string value. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Integer reply: the length of the string at key, or 0 when key does not exist. "_$char(10,13)
}

}

