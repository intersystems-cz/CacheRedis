Class REDIS.Commands.INCR Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

Parameter maxParameters = 1;

/// Function provides incremetation for specific variable, if not exist, is created
/// and setted to zero +1 == +1
ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set status =""
	if ($DATA(^data($LIST(cmdPipeline,2)))){
		set ^data($LIST(cmdPipeline,2)) = $increment(^data($LIST(cmdPipeline,2)))
		set status ="(integer) "_^data($LIST(cmdPipeline,2))
	}else{
		set list = $LB("SET",$LIST(cmdPipeline,2),"1")
		// needed to set variable if not exist
		set status = ##class(REDIS.Commands.SET).RunCommand(list)
		if (status = "OK"){
			set status = "(integer) 1" 
		} else{
			set status = "Unexpected error in DECR command implementation"
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

