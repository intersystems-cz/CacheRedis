/// Class for handling all errors that can uprise during using REDIS-CACHE
Class REDIS.Terminal.ErrorHandler [ Abstract ]
{

/// If max parameters were exceeded while calling function
ClassMethod ParamExceeded(cmdPipeline As %List, maxParameters As %Integer) As %String
{
	set result = $Char(27)_"[31m"_" <Error>: Cannot run command """_$LIST(cmdPipeline,1)_""""_
		" You exceeded maximum of parameters(max "_maxParameters_"), you entered: "_($LISTLENGTH(cmdPipeline)-1)_$Char(27)_"[0m"
		
	return result
}

/// If any syntax error occurs at anytime
ClassMethod SyntaxError(errMessage As %String) As %String
{
	set result = $Char(27)_"[31m"_" <Syntax Error>: "_errMessage_$Char(27)_"[0m"
		
	return result
}

/// If some funcitons is not implemented or not supported (for example help for "help")
ClassMethod UndefinedFunction(cmdPipeline As %List, paramIndex As %Integer) As %String
{
	set result = $Char(27)_"[31m"_" <Error>: Cannot run command """_$LIST(cmdPipeline,1)_""""_
	", function """_$LIST(cmdPipeline,paramIndex)_""" is undefined"_$Char(27)_"[0m"
	
	return result
}

/// If given value from user/programmer is not clear number
ClassMethod NotNumber(cmdPipeline As %List) As %String
{
	set result = $Char(27)_"[31m"_" <Num-Error>: Setted value """_$LIST(cmdPipeline,5)_""" is "_
	"not an integer or out of range"_$Char(27)_"[0m"
	
	return result
}

}

