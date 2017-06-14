Class REDIS.FunctionsHandling.FunctionsHandler Extends %Persistent
{

/// Method for calling command that is part of cmdPipeline list, where first is needed
///  to resolve if expression is correct as far as command with parameters count
Method SolveExpression(cmdPipeline As %List) As %String
{
	set result = ""
	set classFunction = "REDIS.FunctionsScope."_$LIST(cmdPipeline,1)
	
	
	/// GET ALL COMPILED CLASSES FROM PACKAGE: FunctionsScope 	
	&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
	id LIKE 'REDIS.FunctionsScope.%' AND id = :classFunction)
	
	set classesList = $LISTFROMSTRING(classesList)
	
	if ($LISTLENGTH(classesList) '= 0){
		set maxParameters = $PARAMETER(classFunction,"maxParameters")
		///test number of parameters
		if (($LISTLENGTH(cmdPipeline)-1) > maxParameters){
		
			set result = ##class(REDIS.Terminal.ErrorHandler).ParamExceeded(cmdPipeline, maxParameters)
		
		}else{
			/// function exist and call it
			set result = $CLASSMETHOD(classFunction,"RunCommand",cmdPipeline)
		}
	}
	else{
		// function undefined
		set result = ##class(REDIS.Terminal.ErrorHandler).UndefinedFunction(cmdPipeline, 1)
	}
              
	return result
}

/// Class Method for one job to watch on data expiration
ClassMethod WatchExpiration()
{
	while($Data(^redisWork)){
		HANG 1
		if ($DATA(^data)){
			// TODO - start cycle until there is variable that should not still expire
			// TODO 
		}
		// TODO 
	}
}

Storage Default
{
<Data name="FunctionsHandlerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.Func2A71.FunctionsHaAC41D</DataLocation>
<DefaultData>FunctionsHandlerDefaultData</DefaultData>
<IdLocation>^REDIS.Func2A71.FunctionsHaAC41D</IdLocation>
<IndexLocation>^REDIS.Func2A71.FunctionsHaAC41I</IndexLocation>
<StreamLocation>^REDIS.Func2A71.FunctionsHaAC41S</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

