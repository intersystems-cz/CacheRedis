Class REDIS.Commands.INCRBY Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

Parameter maxParameters = 2;

/// constant min parameters
Parameter minParameters = 2;

/// Function provides incremetation for specific variable by value, if not exist, is created
/// and setted to zero + secondArgumentValue
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set status =""

	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))

	if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){ 
			// test on number and integer, 
		if (##class(REDIS.CommandsHandling.Functions).IsRedisNumber($LIST(cmdPipeline,2),1) && 
		##class(REDIS.CommandsHandling.Functions).IsRedisNumber($LIST(cmdPipeline,3),0)){
	        do ##class(REDIS.CommandsHandling.Functions).IncreaseBy($LIST(cmdPipeline,2),$LIST(cmdPipeline,3))
      		set status ="(integer) "_##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
  		}else{
  			set status = ##class(REDIS.Terminal.ErrorHandler).NotNumberNotInteger() 
 		}					
	}else{
		if (##class(REDIS.CommandsHandling.Functions).IsRedisNumber($LIST(cmdPipeline,3),0)){
			// needed to set variable if not exist
			set status = ##class(REDIS.CommandsHandling.Functions).SetVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3))
			if (status = "OK"){
				set status = "(integer) "_##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
			}
		}else{
  			set status = ##class(REDIS.Terminal.ErrorHandler).NotNumberNotInteger()
		}
	}
	
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	return status
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  INCRBY key value"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Increment or decrement the number stored at key by one. If the key does not exist or contains a value of "_$char(10,13)_
	$char(9)_$char(9)_"a wrong type, set the key to the value of ""0"" before to perform the increment or decrement operation. "_$char(10,13)_
	$char(9)_$char(9)_"INCRBY and DECRBY work just like INCR and DECR but instead to increment/decrement by 1 the increment/decrement is integer."_$char(10,13)_
    $char(9)_$char(9)_"INCR commands are limited to 64 bit signed integers."_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Integer reply, this commands will reply with the new value of key after the increment or decrement."_$char(10,13)
}

}

