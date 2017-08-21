Class REDIS.Commands.APPEND Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 2;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	// 	L +(^data($LIST(cmdPipeline,2))):0
	
	if ($DATA(^data($LIST(cmdPipeline,2)))){
	
		// test condition if type of variable is string, if no "type" subscript exist, then it is string
		if ($DATA(^data($LIST(cmdPipeline,2),"type")) = 0){
			set ^data($LIST(cmdPipeline,2)) = ^data($LIST(cmdPipeline,2))_$LIST(cmdPipeline,3)
			set result =  $classmethod("REDIS.Commands.STRLEN","RunCommand",cmdPipeline)
		}else{
			// TODO set result = error Message of wrong type
		}
		
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
	return $char(10,13)_$Char(27)_"[33m"_"  APPEND key value"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  If key already exists and is a string, this command appends the value at the end "_$char(10,13)_
	$char(9)_$char(9)_"of the string. If key does not exist it is created and set as an empty string, so "_$char(10,13)_
	$char(9)_$char(9)_"APPEND will be similar to SET in this special case. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Integer reply: the length of the string after the append operation."_$char(10,13)
}

}

