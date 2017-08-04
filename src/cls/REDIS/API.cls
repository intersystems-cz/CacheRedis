/// This class contain ClassMethods for every command to Run command as a textual command
Class REDIS.API Extends %Persistent
{

ClassMethod Append(varName As %String, value As %String)
{
	if ($DATA(varName)>0){
		if ($DATA(value)>0){
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
		 	w ##class(REDIS.Commands.APPEND).RunCommand(textualListCommand)
	 	}
 	}
}

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

ClassMethod Incrby(varName As %String, value As %String)
{
	if ($DATA(varName)>0){
		if ($DATA(value)>0){
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
		 	w ##class(REDIS.Commands.INCRBY).RunCommand(textualListCommand)
		}
 	}
}

ClassMethod Decrby(varName As %String, value As %String)
{
	if ($DATA(varName)>0){
		if ($DATA(value)>0){
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
		 	w ##class(REDIS.Commands.DECRBY).RunCommand(textualListCommand)
		}
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

ClassMethod Exists(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.EXISTS).RunCommand(textualListCommand)
 	}
}

ClassMethod Expire(varName As %String, seconds As %String)
{
	if ($DATA(varName) > 0){
		if ($DATA(seconds) > 0){
		 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName,seconds)
		 	w ##class(REDIS.Commands.EXPIRE).RunCommand(textualListCommand)
	 	}
 	}
}

ClassMethod Pexpire(varName As %String, miliseconds As %String)
{
	if ($DATA(varName) > 0){
		if ($DATA(miliseconds) > 0){
		 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName,miliseconds)
		 	w ##class(REDIS.Commands.PEXPIRE).RunCommand(textualListCommand)
	 	}
 	}
}

ClassMethod Ttl(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.TTL).RunCommand(textualListCommand)
 	}
}

ClassMethod Pttl(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.PTTL).RunCommand(textualListCommand)
 	}
}

ClassMethod Strlen(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.STRLEN).RunCommand(textualListCommand)
 	}
}

ClassMethod Type(varName As %String)
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.TYPE).RunCommand(textualListCommand)
 	}
}

ClassMethod Ping(varName As %String)
{
	if ($DATA(varName)=0){
		set varName = "ping"
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	w ##class(REDIS.Commands.PING).RunCommand(textualListCommand)
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

