Class REDIS.Shell Extends %Persistent
{

ClassMethod Execute(textualCommand As %String) As %String
{
	return ##class(REDIS.Terminal.InputHandler).Run(textualCommand)
}

ClassMethod RunShell()
{
}

Storage Default
{
<Data name="ShellDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.ShellD</DataLocation>
<DefaultData>ShellDefaultData</DefaultData>
<IdLocation>^REDIS.ShellD</IdLocation>
<IndexLocation>^REDIS.ShellI</IndexLocation>
<StreamLocation>^REDIS.ShellS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

