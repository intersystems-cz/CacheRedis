Class REDIS.CommandsHandling.CommandsHandler Extends %Persistent
{

/// Method for calling command that is part of cmdPipeline list, where first is needed
///  to resolve if expression is correct as far as command with parameters count
ClassMethod SolveExpression(cmdPipeline As %List) As %String
{
	set result = ""
	set classFunction = "REDIS.Commands."_$LIST(cmdPipeline,1)
	
	
	/// GET ALL COMPILED CLASSES FROM PACKAGE: Commands 	
	&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
	id LIKE 'REDIS.Commands.%' AND id = :classFunction)
	
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

Storage Default
{
<Data name="CommandsHandlerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.CommDACC.CommandsHan418BD</DataLocation>
<DefaultData>CommandsHandlerDefaultData</DefaultData>
<IdLocation>^REDIS.CommDACC.CommandsHan418BD</IdLocation>
<IndexLocation>^REDIS.CommDACC.CommandsHan418BI</IndexLocation>
<StreamLocation>^REDIS.CommDACC.CommandsHan418BS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

