Class REDIS.Commands.PING Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 1;

/// constant min parameters
Parameter minParameters = 0;

/// The different types that can be returned are: string, list, set, zset and hash.
/// TODO LIST,SET,ZSET,HASH
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	
	set test = $LL(cmdPipeline)
	
	if (test > 1){
		set result = $LIST(cmdPipeline,2) 
	}else{
		set result = "PONG"
	}
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  PING [message]"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Returns PONG if no argument is provided, otherwise return a copy "_$char(10,13)_
	$char(9)_$char(9)_"of the argument as a bulk. This command is often used to test if a connection is "_$char(10,13)_
	$char(9)_$char(9)_"still alive, or to measure latency. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Simple string reply"_$char(10,13)
}

}

