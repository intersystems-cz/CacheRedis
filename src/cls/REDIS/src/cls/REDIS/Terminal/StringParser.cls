Class REDIS.Terminal.StringParser Extends %Persistent
{

/// Method used for creating List from given data as String, where every not important
/// white characters are removed from future list and only clear list with commnad and
/// parameters will remain. The data contains common data input inputed from user for
/// work with REDIS-CACHÉ interface.
ClassMethod decodeCommand(data As %String) As %List
{
	set List = $ListFromString(data," ")
	
	/// just preparing our new list with elements without spaces
	set newList = $ListBuild()
	
	set index = 1
	set newListIndex = 1
	
	/// copy only input with data to new list and upper case only funcitons
	while ((index-1) '= $LISTLENGTH(List)){
		if ($LIST(List,index) '= ""){
			if (newListIndex = 1){
				set $LIST(newList,newListIndex) = $ZCONVERT($LIST(List,index),"U")
			}
			elseif ((newListIndex = 2) && ($LIST(newList,1) = "HELP")){
				set $LIST(newList,newListIndex) = $ZCONVERT($LIST(List,index),"U")
			}else{
				set $LIST(newList,newListIndex) = $LIST(List,index)
			}
			set newListIndex = $increment(newListIndex)
		}
		set index = $increment(index)
	}
	
	return newList
}

Storage Default
{
<Data name="StringParserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.Terminal.StringParserD</DataLocation>
<DefaultData>StringParserDefaultData</DefaultData>
<IdLocation>^REDIS.Terminal.StringParserD</IdLocation>
<IndexLocation>^REDIS.Terminal.StringParserI</IndexLocation>
<StreamLocation>^REDIS.Terminal.StringParserS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

