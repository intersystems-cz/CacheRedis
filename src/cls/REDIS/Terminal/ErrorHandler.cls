/// Class for handling all errors that can uprise during using REDIS-CACHE
Class REDIS.Terminal.ErrorHandler [ Abstract ]
{

/// If max parameters were exceeded while calling function
ClassMethod ParamExceeded(cmdPipeline As %List, maxParameters As %Integer) As %String
{
	set result = $Char(27)_"[31m"_" <Error>: Wrong number of arguments"_
		" (given "_($LISTLENGTH(cmdPipeline)-1)_", expected "_maxParameters_")"_$Char(27)_"[0m"
		
	return result
}

/// If min parameters were under the limit
ClassMethod ParamUnderLimit(cmdPipeline As %List, minParameters As %Integer) As %String
{
	set result = $Char(27)_"[31m"_" <Error>: Wrong number of arguments"_
		" (given "_($LISTLENGTH(cmdPipeline)-1)_", expected "_minParameters_")"_$Char(27)_"[0m"
		
	return result
}

/// If any syntax error occurs at anytime
ClassMethod SyntaxError(errMessage As %String) As %String
{
	set result = $Char(27)_"[31m"_" <Syntax Error>: "_errMessage_$Char(27)_"[0m"
		
	return result
}

/// Used wrong type error
ClassMethod WrongTypeError() As %String
{
	set result = $Char(27)_"[31m"_" <Error>: WRONGTYPE Operation against a key holding the wrong kind of value"_$Char(27)_"[0m"
		
	return result
}

/// If some funcitons is not implemented or not supported (for example help for "help")
ClassMethod UndefinedFunction(cmdPipeline As %List, paramIndex As %Integer) As %String
{
	set result = $Char(27)_"[31m"_" <Error>: Cannot run command """_$LIST(cmdPipeline,1)_""""_
	", function """_$LIST(cmdPipeline,paramIndex)_""" is undefined"_$Char(27)_"[0m"
	
	return result
}

/// If given value is not number or not integer, is used by commands: INCRBY, DECRBY
ClassMethod NotNumberNotInteger() As %String
{
	set result = $Char(27)_"[31m"_" (error) ERR value is not an integer or out of range"_$Char(27)_"[0m"
	return result
}

}

