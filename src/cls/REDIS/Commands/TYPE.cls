Class REDIS.Commands.TYPE Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 1;

/// The different types that can be returned are: string, list, set, zset and hash.
/// TODO LIST,SET,ZSET,HASH
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	// to determine a type of variable I need to have prepared working commands as LPUSH, SADD, ZADD, HSET
	// but these commands are not part of specification, well I will try at least suggest architecture in caché
	// for those commands as follows: - list in list, with first member record data that will determine the type
	// I need to study more redis structures as: list, set, zset and hash
	
	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))
	
	if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){
		if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),3)){
			s result = ##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),3)
		} else{
			set result = """string"""
		}
	}else{
		set result = """none"""
	}
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  TYPE key"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Return the type of the value stored at key in form of a string. "_$char(10,13)_
	$char(9)_$char(9)_"The type can be one of ""none"", ""string"", ""list"", ""set"". ""none"" is returned "_$char(10,13)_
	$char(9)_$char(9)_"if the key does not exist. "_$char(10,13)_

    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_$char(10,13)_$char(10,13)_
    $char(9)_$char(9)_"Status code reply, specifically:"_$char(10,13)_$char(10,13)_

	$Char(27)_"!<HTML><ul><ul><ul><ul><ul><li>""none"" if the key does not exist</li>"_
	"<li>""string"" if the key contains a String value</li><li>""list"" if the key contains a List value</li>"_
	"<li>""set"" if the key contains a Set value</li></ul></ul></ul></ul></ul></HTML>"
}

}

