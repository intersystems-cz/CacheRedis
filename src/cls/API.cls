Class REDIS.API Extends %Persistent
{

ClassMethod Decr(varName As %String)
{
	if ($DATA(varName)>0){
		set textualListCommand = ##class(REDIS.API).ConvertToList(varName) 	
	 	w ##class(REDIS.Commands.DECR).RunCommand(textualListCommand)
 	}
}

ClassMethod Incr(varName As %String)
{
	if ($DATA(varName)>0){
		set textualListCommand = ##class(REDIS.API).ConvertToList(varName) 	
	 	w ##class(REDIS.Commands.INCR).RunCommand(textualListCommand)
 	}
}

ClassMethod Del(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.DEL).RunCommand(textualListCommand)
 	}
}

ClassMethod Set(varName As %String, value As %String, option As %String, time As %String)
{
	if ($DATA(varName)>0){
		if ($DATA(option)>0){
				if ($DATA(time)>0){
					set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value,option,time)
				}else{
					set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value,option)
				}
	 	}else{
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
	 	}
	 	w ##class(REDIS.Commands.SET).RunCommand(textualListCommand)
 	}
}

ClassMethod Get(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.GET).RunCommand(textualListCommand)
 	}
}

ClassMethod Help(commandName As %String)
{
	if ($DATA(commandName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(commandName)
 	}else{
 		set textualListCommand = $LISTBUILD("HELP")
 	}
 	w ##class(REDIS.Commands.HELP).RunCommand(textualListCommand)
}

/// this ClassMethod should be called in every command above to
/// transfer from redis function arguments to textual list command
ClassMethod ConvertToList(args... As %String) As %List
{
	
	set textualCommand = ""
	
	 For i = 1 : 1 : $GET(args, 0)
	 {
	     if ($DATA(args(i))>0){
	     	set textualCommand = textualCommand_" "_$GET(args(i), "<NULL>")
	     }

	 }
	 
	return $LISTFROMSTRING(textualCommand," ")
}

Storage Default
{
<Data name="APIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.APID</DataLocation>
<DefaultData>APIDefaultData</DefaultData>
<IdLocation>^REDIS.APID</IdLocation>
<IndexLocation>^REDIS.APII</IndexLocation>
<StreamLocation>^REDIS.APIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

