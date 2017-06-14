Class REDIS.FunctionsScope.HELP Extends REDIS.FunctionsHandling.FunctionPrescribtion
{

/// constant max parameters
Parameter maxParameters = 1;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	
	set result = ""

	/// user typed only "HELP"
	if ($LISTLENGTH(cmdPipeline) = 1){
		set result = ..GetHelp()		
	}
	/// user typed "HELP" with one parameter
	else{
		set className = "REDIS.FunctionsScope."_$LIST(cmdPipeline,2)
				
				
		/// GET ALL COMPILED CLASSES FROM PACKAGE: FunctionsScope 	
		&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
		id LIKE 'REDIS.FunctionsScope.%' AND id NOT LIKE 'REDIS.FunctionsScope.HELP' AND id = :className)
		
				
		set classesList = $LISTFROMSTRING(classesList)
						
		if ($LISTLENGTH(classesList) '= 0){
			/// call a help for concrete existing function
			set result = $CLASSMETHOD(className, "GetHelp")	
		}else{
			/// function undefined function
			set result = ##class(REDIS.Terminal.ErrorHandler).UndefinedFunction(cmdPipeline,2)
		}
	}
	
	return result
}

ClassMethod GetHelp() As %String
{
	set helpUsage = $CHAR(10,13)_$Char(27)_"[33m"_"  Welcome to HELP for CACHÉ-REDIS"_$Char(27)_"[0m"_$CHAR(10,13)_
					"  If you need help for any function, type "_$char(27)_
					"[4m""do 'var'.Run(""HELP command"")"""_$char(27)_"[0m"_$CHAR(10,13)_"  By typing "_$char(27)_
					"[4m""do 'var'.Run(""COMMAND param1 param2 ..."")"""_$char(27)_"[0m"_" you can run any"
					_" command / function"_$CHAR(10,13)_$CHAR(10,13)_
					"  These functions are available:"_$CHAR(10,13)_$CHAR(10,13)_"    "_$char(27)_"[36m"
					
					
	/// GET ALL COMPILED CLASSES FROM PACKAGE: FunctionsScope	
	&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
	id LIKE 'REDIS.FunctionsScope.%' ORDER BY id ASC)
			
	set classesList = $LISTFROMSTRING(classesList)

	try{
		for i=1:1:$LISTLENGTH(classesList){
			set helpUsage = helpUsage_$PIECE($LIST(classesList,i),".",3)_" , "
		}
	} catch e{
		w $System.Status.GetErrorText(e)
	}
	
	set helpUsage = helpUsage_$char(27)_"[0m"_$CHAR(10,13)
					
	return helpUsage
}

}

