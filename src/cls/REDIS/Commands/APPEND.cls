Class REDIS.Commands.APPEND Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 2;

/// constant min parameters
Parameter minParameters = 2;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))
	
	if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){
	
		// test condition if type of variable is string, if no "type" subscript exist, then it is string
		if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),3) = 0){
			set ^data($LIST(cmdPipeline,2)) = ^data($LIST(cmdPipeline,2))_$LIST(cmdPipeline,3)
			set result = ##class(REDIS.CommandsHandling.Functions).GetStrlen($LIST(cmdPipeline,2))
		}else{
			set result = ##class(REDIS.Terminal.ErrorHandler).WrongTypeError()
		}
		
	}else{
		set result = ##class(REDIS.CommandsHandling.Functions).SetVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3))
		if (result = "OK"){
			set result = ##class(REDIS.CommandsHandling.Functions).GetStrlen($LIST(cmdPipeline,2))
		}else{
			// nothing more, just result consist of error message that will be returned
		}
	}
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  APPEND key value"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  If key already exists and is a string, this command appends the value at the end "_$char(10,13)_
	$char(9)_$char(9)_"of the string. If key does not exist it is created and set as an empty string, so "_$char(10,13)_
	$char(9)_$char(9)_"APPEND will be similar to SET in this special case. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Integer reply: the length of the string after the append operation."_$char(10,13)
}

}

