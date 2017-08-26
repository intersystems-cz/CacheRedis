Class REDIS.RESP.CommunicationTest Extends %Persistent
{

Parameter device = "|TCP|7005";

ClassMethod Test(cmdPipeline As %String) As %String
{
	s result = cmdPipeline_" 345255 data "
	ret result
}

ClassMethod StartServer()
{
		w !,"Server starts... OPEN socket for listen at """_..#device_""":",!,!
		OPEN ..#device::2		
		if ($TEST){
			w "Server choose device... USE opened device """_..#device_""" and waits for messages:",!,!
			while(1){
				try {
					USE 0 WRITE !,"Start loop to read",!
					USE ..#device  READ message
					USE 0
					s result = "+"_##class(Simple.RESP).Test(message)
					USE ..#device  WRITE "Redis result is: "_result,!
				} catch(e){
					USE 0 WRITE !,"Catched exception",!
				}
				if (message = "close"){
					QUIT
				}

			}
			do ..StopServer()
		} else{
			w "Sorry, but it is not able to open device: "_..#device_" .",!,!
		}
}

ClassMethod StopServer()
{
		CLOSE ..#device
		w !,"Device closed!",!,!
}

Storage Default
{
<Data name="CommunicationTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.RESP.CommunicationTestD</DataLocation>
<DefaultData>CommunicationTestDefaultData</DefaultData>
<IdLocation>^REDIS.RESP.CommunicationTestD</IdLocation>
<IndexLocation>^REDIS.RESP.CommunicationTestI</IndexLocation>
<StreamLocation>^REDIS.RESP.CommunicationTestS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

