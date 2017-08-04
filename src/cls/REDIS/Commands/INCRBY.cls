Class REDIS.Commands.INCRBY Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

Parameter maxParameters = 2;

/// Function provides incremetation for specific variable by value, if not exist, is created
/// and setted to zero + secondArgumentValue
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set status =""
	if ($DATA(^data($LIST(cmdPipeline,2)))){
		
		try{
		     set res = $INUMBER($LIST(cmdPipeline,3),"")
		     if ('$FIND($LIST(cmdPipeline,3),".")){
	          		set ^data($LIST(cmdPipeline,2)) = ^data($LIST(cmdPipeline,2)) + $LIST(cmdPipeline,3)
	          		set status ="(integer) "_^data($LIST(cmdPipeline,2))
		     }else{
		          //"variable is number but no integer"
		          set status = ##class(REDIS.Terminal.ErrorHandler).NotNumberNotInteger()
		     }
		}catch(e){
		     //"variable is not number"
		     set status = ##class(REDIS.Terminal.ErrorHandler).NotNumberNotInteger() 
		}
		
	}else{
		set list = $LB("SET",$LIST(cmdPipeline,2),$LIST(cmdPipeline,3))
		// needed to set variable if not exist
		set status = ##class(REDIS.Commands.SET).RunCommand(list)
		if (status = "OK"){
			set status = "(integer) "_^data($LIST(cmdPipeline,2))
		}
	}
	return status
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  INCR key"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Increment or decrement the number stored at key by one. If the key does not exist or contains a value of "_$char(10,13)_
	$char(9)_$char(9)_"a wrong type, set the key to the value of ""0"" before to perform the increment or decrement operation. "_$char(10,13)_
	$char(9)_$char(9)_"INCRBY and DECRBY work just like INCR and DECR but instead to increment/decrement by 1 the increment/decrement is integer."_$char(10,13)_
    $char(9)_$char(9)_"INCR commands are limited to 64 bit signed integers."_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Integer reply, this commands will reply with the new value of key after the increment or decrement."_$char(10,13)
}

}

