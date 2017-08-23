Class REDIS.Commands.SET Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 4;

/// constant min parameters
Parameter minParameters = -1;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	if (($LISTLENGTH(cmdPipeline)-1) = 0){
		return "OK"
	}
	
	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))
	
	// test number of parameters between 2 or 4
	set paramNum = ($LISTLENGTH(cmdPipeline)-1)
	
	if (paramNum = 1){
		// if is only one argument given, will assign empty string
		set result = ##class(REDIS.CommandsHandling.Functions).SetVariable($LIST(cmdPipeline,2),"")
	}elseif (paramNum = 2){
		set result = ##class(REDIS.CommandsHandling.Functions).SetVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3)) 
	}
	elseif (paramNum = 3){
		
		set option = $ZCONVERT($LIST(cmdPipeline,4),"U")		
		/// if variable not exist, set it
		if (option = "NX"){
			if ('##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){
				set result = ##class(REDIS.CommandsHandling.Functions).SetVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3))
			}else{
				set result = "(nil)"
			}
		}
		/// if variable exist, implement it
		elseif(option = "XX"){
			if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){
				set result = ##class(REDIS.CommandsHandling.Functions).SetVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3))
			}else{
				set result = "(nil)"
			}
		}
		else{
			set result = ##class(REDIS.Terminal.ErrorHandler).SyntaxError(" Option """_option_""" not exist, see ""help set""")
		}
	}
	elseif (paramNum = 4){
		set option = $ZCONVERT($LIST(cmdPipeline,4),"U")
		if (option = "EX"){
			if (##class(REDIS.CommandsHandling.Functions).IsRedisNumber($LIST(cmdPipeline,5),0)){
				do ##class(REDIS.CommandsHandling.Functions).SetTimedVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3),$LIST(cmdPipeline,5))
				set result = "OK"
			}else{
				set result = ##class(REDIS.Terminal.ErrorHandler).NotNumberNotInteger()
			}			
		}
		elseif(option = "PX"){
			if (##class(REDIS.CommandsHandling.Functions).IsRedisNumber($LIST(cmdPipeline,5),0)){
				// conversion to miliseconds:
				set $LIST(cmdPipeline,5) = $LIST(cmdPipeline,5)/1000
				do ##class(REDIS.CommandsHandling.Functions).SetTimedVariable($LIST(cmdPipeline,2),$LIST(cmdPipeline,3),$LIST(cmdPipeline,5))
				set result = "OK"
			}else{
				set result = ##class(REDIS.Terminal.ErrorHandler).NotNumberNotInteger()
			}
			
		}
		else{
			set result = ##class(REDIS.Terminal.ErrorHandler).SyntaxError(" Option """_option_""" not exist, see ""help set""")
		}
	}
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
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

