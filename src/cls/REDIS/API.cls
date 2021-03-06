/// This class contain ClassMethods for every command to Run command as a textual command
Class REDIS.API Extends %Persistent
{

ClassMethod Append(varName As %String, value As %String) As %String
{
	if ($DATA(varName)>0){
		if ($DATA(value)>0){
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
		 	ret ##class(REDIS.Commands.APPEND).RunCommand(textualListCommand)
	 	}
 	}
}

ClassMethod Decr(varName As %String) As %String
{
	if ($DATA(varName)>0){
		set textualListCommand = ##class(REDIS.API).ConvertToList(varName) 	
	 	ret ##class(REDIS.Commands.DECR).RunCommand(textualListCommand)
 	}
}

ClassMethod Incr(varName As %String) As %String
{
	if ($DATA(varName)>0){
		set textualListCommand = ##class(REDIS.API).ConvertToList(varName) 	
	 	ret ##class(REDIS.Commands.INCR).RunCommand(textualListCommand)
 	}
}

ClassMethod Incrby(varName As %String, value As %String) As %String
{
	if ($DATA(varName)>0){
		if ($DATA(value)>0){
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
		 	ret ##class(REDIS.Commands.INCRBY).RunCommand(textualListCommand)
		}
 	}
}

ClassMethod Decrby(varName As %String, value As %String) As %String
{
	if ($DATA(varName)>0){
		if ($DATA(value)>0){
			set textualListCommand = ##class(REDIS.API).ConvertToList(varName,value) 	
		 	ret ##class(REDIS.Commands.DECRBY).RunCommand(textualListCommand)
		}
 	}
}

ClassMethod Del(args... As %String) As %String
{
	
	if ($DATA(args)>0){
		set textualCommand = ""
		/// Needful for REST call. If it is list, we talk about rest call 
		/// and get string of variables to kill specifically.
		if ($LISTVALID($GET(args(1), "<NULL>"))){
			 For i = 1 : 1 : $LL($GET(args(1), "<NULL>"))
			 {
			    set textualCommand = textualCommand_" "_$LI($GET(args(1), "<NULL>"),i)			 
			 } 
		}else{
			 For i = 1 : 1 : $GET(args, 0)
			 {
			     if ($DATA(args(i))>0){
			     	set textualCommand = textualCommand_" "_$GET(args(i), "<NULL>")
			     }
			 }
		}
		ret ##class(REDIS.Commands.DEL).RunCommand($LISTFROMSTRING(textualCommand," "))
	}
}

ClassMethod Set(args... As %String) As %String
{
		if ($DATA(args)>0){
		set textualCommand = ""
		/// Needful for REST call. If it is list, we talk about rest call 
		if ($LISTVALID($GET(args(1), "<NULL>"))){
			 For i = 1 : 1 : $LL($GET(args(1), "<NULL>"))
			 {
			    set textualCommand = textualCommand_" "_$LI($GET(args(1), "<NULL>"),i)			 
			 } 
		}else{
			 For i = 1 : 1 : $GET(args, 0)
			 {
			     if ($DATA(args(i))>0){
			     	set textualCommand = textualCommand_" "_$GET(args(i), "<NULL>")
			     }
			 }
		}
		ret ##class(REDIS.Commands.SET).RunCommand($LISTFROMSTRING(textualCommand," "))
	}
}

ClassMethod Get(varName As %String) As %String
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.GET).RunCommand(textualListCommand)
 	}
}

ClassMethod Exists(varName As %String) As %String
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.EXISTS).RunCommand(textualListCommand)
 	}
}

ClassMethod Expire(varName As %String, seconds As %String) As %String
{
	if ($DATA(varName) > 0){
		if ($DATA(seconds) > 0){
		 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName,seconds)
		 	ret ##class(REDIS.Commands.EXPIRE).RunCommand(textualListCommand)
	 	}
 	}
}

ClassMethod Pexpire(varName As %String, miliseconds As %String) As %String
{
	if ($DATA(varName) > 0){
		if ($DATA(miliseconds) > 0){
		 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName,miliseconds)
		 	ret ##class(REDIS.Commands.PEXPIRE).RunCommand(textualListCommand)
	 	}
 	}
}

ClassMethod Ttl(varName As %String) As %String
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.TTL).RunCommand(textualListCommand)
 	}
}

ClassMethod Pttl(varName As %String) As %String
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.PTTL).RunCommand(textualListCommand)
 	}
}

ClassMethod Strlen(varName As %String) As %String
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.STRLEN).RunCommand(textualListCommand)
 	}
}

ClassMethod Type(varName As %String) As %String
{
	if ($DATA(varName)>0){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.TYPE).RunCommand(textualListCommand)
 	}
}

ClassMethod Ping(varName As %String) As %String
{
	if ($DATA(varName)=0){
	 	set textualListCommand = $LB()
	 	ret ##class(REDIS.Commands.PING).RunCommand(textualListCommand)
 	}
 	else {
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.PING).RunCommand(textualListCommand)
 	}
}

ClassMethod Time(varName As %String) As %String
{
	if ($DATA(varName)=0){
		set varName = "time"
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(varName)
	 	ret ##class(REDIS.Commands.TIME).RunCommand(textualListCommand)
 	}
}

ClassMethod Help(commandName As %String) As %String
{
	if (($DATA(commandName)>0) && (commandName '= "")){
	 	set textualListCommand = ##class(REDIS.API).ConvertToList(commandName)
 	}else{
 		set textualListCommand = $LISTBUILD("HELP")
 	}
 	ret ##class(REDIS.Commands.HELP).RunCommand(textualListCommand)
}

/// This ClassMethod should be called in every command above to
/// transfer from redis function arguments to textual list command.
ClassMethod ConvertToList(args... As %String) As %List
{
	
	set textualCommand = ""
	
	 For i = 1 : 1 : $GET(args, 0)
	 {
	     if ($DATA(args(i))>0){
	     	set textualCommand = textualCommand_" "_$GET(args(i), "<NULL>")
	     }

	 }
	 
	ret $LISTFROMSTRING(textualCommand," ")
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

