Class REDIS.Commands.DEL Extends REDIS.CommandsHandling.CommandPrescribtion
{

/// constant max parameters - infinity parameters
Parameter maxParameters = 99999999;

/// Delete specific amount of variables
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set numDeleted = 0
	for i=2:1:($LL(cmdPipeline))
	{
		if ($DATA(@("^"_$LIST(cmdPipeline,i)))){
			kill @("^"_$LIST(cmdPipeline,i))
			set numDeleted = $increment(numDeleted)
		}
	}
	
	return numDeleted
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_" DEL key1 key2 ... keyN"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Remove the specified keys. If a given key does not exist no operation is performed for this key. "_$char(10,13)_
	$char(9)_$char(9)_" The commnad returns the number of keys removed."_$char(10,13)_$char(10,13)_
	
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_$char(10,13)_
    $Char(27)_"!<HTML><ul><ul><ul><ul><li>An integer greater than 0 if one or more keys were removed.</li>"_
	"<li>0 if none of the specified key existed.</li></ul></ul></ul></ul></HTML>"_$char(10,13)
}

}

