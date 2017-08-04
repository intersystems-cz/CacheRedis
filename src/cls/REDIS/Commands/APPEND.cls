Class REDIS.Commands.APPEND Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 2;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	if ($DATA(^data($LIST(cmdPipeline,2)))){
	
		// TODO test condition if type of variable is string
		set ^data($LIST(cmdPipeline,2)) = ^data($LIST(cmdPipeline,2))_$LIST(cmdPipeline,3)
		set result =  $classmethod("REDIS.Commands.STRLEN","RunCommand",cmdPipeline)
		
	}else{
		set result = $classmethod("REDIS.Commands.SET","RunCommand",cmdPipeline)
		if (result = "OK"){
			set result = $classmethod("REDIS.Commands.STRLEN","RunCommand",cmdPipeline)
		}else{
			// TODO
			w "special situation - append command else TODO",!
		}
	}
	
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  SET key value"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  Set key to hold the string value. If key already "_$char(10,13)_
	$char(9)_$char(9)_"holds a value, it is overwritten, regardless of its type. Any previous time to live "_$char(10,13)_
	$char(9)_$char(9)_"associated with the key is discarded on successful SET operation. "_$char(10,13)_
	$char(27)_"[35m"_"  OPTIONS:"_$char(27)_"[0m"_$char(10,13)_
	$Char(27)_"!<HTML><ul><ul><ul><ul><li>EX seconds -- Set the specified expire time, in seconds.</li>"_
	"<li>PX milliseconds -- Set the specified expire time, in milliseconds.</li><li>NX -- Only set the key if it does not already exist.</li>"_
	"<li>XX -- Only set the key if it already exist.</li></ul></ul></ul></ul></HTML>"_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Status code reply: OK if SET was executed correctly. Null multi-bulk reply: a Null Bulk Reply"_$char(10,13)_
    $char(9)_$char(9)_"is returned if the SET operation was not performed becase the user specified the NX or XX "_$char(10,13)_
    $char(9)_$char(9)_"option but the condition was not met."_$char(10,13)
}

}

