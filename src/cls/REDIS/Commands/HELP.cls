Class REDIS.Commands.HELP Extends REDIS.CommandsHandling.CommandPrescribtion
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
		set className = "REDIS.Commands."_$ZCONVERT($LIST(cmdPipeline,2),"U")
				
		/// GET ALL COMPILED CLASSES FROM PACKAGE: Commands 	
		/*
		&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
		id LIKE 'REDIS.Commands.%' AND id NOT LIKE 'REDIS.Commands.HELP' AND id = :className)
		*/
		
		&sql(select LIST(id) into :classesList from (
			select id as id from %Dictionary.CompiledClass where
			id LIKE 'REDIS.Commands.%' AND id NOT LIKE 'REDIS.Commands.HELP'
			AND id = :className
		) As result)
				
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
					"[4m""do ##class(REDIS.Shell).Execute(""HELP command"")"""_$char(27)_"[0m"_$CHAR(10,13)_"  By typing "_$char(27)_
					"[4m""do ##class(REDIS.Shell).Execute(""COMMAND param1 param2 ..."")"""_$char(27)_"[0m"_" you can run any"
					_" command / function"_$CHAR(10,13)_$CHAR(10,13)_
					"  These functions are available:"_$CHAR(10,13)_$CHAR(10,13)_"    "_$char(27)_"[36m"
					
					
	/// GET ALL COMPILED CLASSES FROM PACKAGE: Commands	
	&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
	id LIKE 'REDIS.Commands.%' ORDER BY id ASC)
			
	set classesList = $LISTFROMSTRING(classesList)

	try{
		for i=1:1:$LISTLENGTH(classesList){
			if (i'=$LISTLENGTH(classesList)) {
				set helpUsage = helpUsage_$PIECE($LIST(classesList,i),".",3)_" , "
			}
			else{
				set helpUsage = helpUsage_$PIECE($LIST(classesList,i),".",3)_" "
			}
		}
	} catch e{
		w $System.Status.GetErrorText(e)
	}
	
	set helpUsage = helpUsage_$char(27)_"[0m"_$CHAR(10,13)
				
	return helpUsage
}

}

