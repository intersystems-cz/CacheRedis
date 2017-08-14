Class REDIS.Commands.TIME Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 1;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{

	S zts=$ZTS
	S seconds = (+zts-47117*86400) + $J($P(zts,",",2),0,0)
	
	// The $ZTIMESTAMP time value is a decimal numeric value that counts the time in seconds and fractions thereof.
	// The number of digits in the fractional seconds may vary from zero to nine, depending on the precision of computer?s
	// time-of-day clock. On Windows systems the fractional precision is three decimal digits; on UNIX® systems 
	// it is six decimal digits.
	s microseconds = $PIECE($J($P(zts,",",2),0,6),".",2)

	set result = " 1)  "_seconds_$char(10,13)_
				 " 2)  "_microseconds
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  TIME"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  The TIME command returns the current server time as a two items lists: a  "_$char(10,13)_
	$char(9)_$char(9)_"Unix timestamp and the amount of microseconds already elapsed in the  "_$char(10,13)_
	$char(9)_$char(9)_"current second. Basically the interface is very similar to the one of the gettimeofday system call. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" Array reply, specifically:"_$char(10,13)_
    $char(9)_$char(9)_"A multi bulk reply containing two elements:"_$char(10,13)_
    $char(9)_$char(9)_$char(9)_"- unix time in seconds. "_$char(10,13)_
    $char(9)_$char(9)_$char(9)_"- microseconds."_$char(10,13)
}

}

