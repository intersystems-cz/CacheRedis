Class REDIS.Terminal.InputHandler Extends %Persistent
{

Property CommandsHandler As REDIS.CommandsHandling.CommandsHandler;

Property StringParser As REDIS.Terminal.StringParser;

Property decodedPipeline As %List;

ClassMethod Run(cmdPipeline As %String) As %Status
{

	/// decode cmdPipeline to make clear command and parameters	
	set decodedPipeline = ##class(REDIS.Terminal.StringParser).decodeCommand(cmdPipeline)
	
	write ##class(REDIS.CommandsHandling.CommandsHandler).SolveExpression(decodedPipeline)

	return $$$OK
}

///  TODO - method for realease unimportant resources
Method End() As %Status
{
	// end redis work
	kill ^redisWork
	
	// dispose of this object TODO:
	
	return $$$OK
}

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
/// If instead of returning a %Status code this returns an oref and this oref is a subclass of the current
/// class then this oref will be the one returned to the caller of %New method.
Method %OnNew(webCall As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	set ..CommandsHandler = ##class(REDIS.CommandsHandling.CommandsHandler).%New()
	set ..StringParser = ##class(REDIS.Terminal.StringParser).%New()
	
	/* TODO - for better expiration variables handling
	/// creation of important globals
	//set ^redisWork = 1
	
	/// creation of JOB control routines
	//JOB ##class(REDIS.FunctionsHandling.FunctionsHandler).WatchExpiration()
	*/
	if (webCall '= 0){
		write $Char(27), "!<HTML><style>.thumb1 { background: url(https://redis-cache-layer-project.000webhostapp.com/redisLogo.png)"_
		" 50% 50% no-repeat;width: 300px;height: 90px;</style><div class=""thumb1""></div></HTML>"
	
		write !,$Char(27)_"[33m"_"  Caché-Redis Version 1.0"_$Char(27)_"[0m",!,
		"  Author: Marek Bernád",!,!,"  Welcome to Redis No-SQL database",!
		,"  type "_$char(27)_"[4m"_"""do 'variable'.Run(""HELP"")"""_$char(27)_"[0m"_" for show functions",!
	}
		
	Quit $$$OK
}

Storage Default
{
<Data name="InputHandlerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommandsHandler</Value>
</Value>
<Value name="3">
<Value>StringParser</Value>
</Value>
<Value name="4">
<Value>decodedPipeline</Value>
</Value>
</Data>
<DataLocation>^REDIS.Terminal.InputHandlerD</DataLocation>
<DefaultData>InputHandlerDefaultData</DefaultData>
<IdLocation>^REDIS.Terminal.InputHandlerD</IdLocation>
<IndexLocation>^REDIS.Terminal.InputHandlerI</IndexLocation>
<StreamLocation>^REDIS.Terminal.InputHandlerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

