Class REDIS.RESP.CommunicationTest Extends %Persistent
{

Parameter device = "|TCP|7005";

Parameter clientDevice = "|TCP|7523";

Parameter host = "192.168.1.10";

Parameter serverPort = 7005;

// do ##class(REDIS.RESP.CommunicationTest).StartServer()

ClassMethod RunShell(cmdPipeline As %String) As %String
{
	s result = ##class(REDIS.Shell).Execute(cmdPipeline)
	ret result
}

ClassMethod ParseClientDemand(pipeline As %String) As %String
{
	s pipeline = ^clientTestInput
	//s pipeline = $zstrip(pipeline,"*",$c(13,10))

	s it = 3

	s mode = "readCommand"
	s status = "OK"
	s pipeToExec = ""
	s allPipes = $LB("")
	s paramCounter = 0
	
	do
	{
		s word = $p(pipeline,$c(13,10),it)
		if (word = "")
		{
			s allPipes = $Listupdate(allPipes,$LL(allPipes)+1,pipeToExec)
			w "First: "_$LIST(allPipes,1)_" | Second: "_$LIST(allPipes,2)_" | Third: "_$LIST(allPipes,3)
			QUIT
		}
		
		if (mode = "readCommand")
		{
			s command = word
			if (##class(REDIS.CommandsHandling.Functions).IsCommand(command))
			{
				if (##class(REDIS.CommandsHandling.Functions).GetMaxParams(command) > 0)
				{
					s mode = "readParam"
					s pipeToExec = command 	
				}
			}else
			{
				s status = "-"_"<Error> Command """_command_""" is undefined, aborting whole pipeline"
				w status
				QUIT
			}
		}else
		{
			s paramCounter = paramCounter + 1
			if (##class(REDIS.CommandsHandling.Functions).GetMaxParams(command) >= paramCounter)
			{
				s param = word
				
				// special case for variable num of parameters
				if ($ZCONVERT(command,"U") = "SET")
				{
					///  0   1   2  3  4  5
					/// SET var 34  EX 34 XX
					/// SET var 34  XX
					/// SET var 34  NX EX 34
					/// SET var 34  EX 43
					/// SET var 35
					if (paramCounter > 2){
					
						if ('##class(REDIS.CommandsHandling.Functions).IsCommand(param))
						{
							s pipeToExec = pipeToExec_" "_param
							s it = it + 2
							continue
						}
					}
					else{
						s pipeToExec = pipeToExec_" "_param
						s it = it + 2
						continue
					}
				}else{
					s pipeToExec = pipeToExec_" "_param
					s it = it + 2
					continue
				}
			}

			 
			
			s mode = "readCommand"
			s paramCounter = 0
			//w pipeToExec
			s allPipes = $Listupdate(allPipes,$LL(allPipes)+1,pipeToExec)
			s pipeToExec = ""
			s it = it - 2
		}
 
		s it = it + 2
		
	}
	while (word '= "")
	
	
	
	return status
	//s pipeline = $zstrip(pipeline,"*",$c(13,10))
}

ClassMethod StartServer()
{
		s result = "RESULT"
		w !,"Server starts... OPEN socket for listen at """_..#device_""":",!,!
		OPEN ..#device::2		
		if ($TEST){
			w "Server choose device... USE opened device """_..#device_""" and waits for messages:",!,!
			while(1){
				try {
					USE 0 WRITE !,"Start loop to read",!
					USE ..#device  READ message
					USE 0 WRITE !,"Processing input demand from client: "_""""_message_"""",!
					;s result = "+"_##class(REDIS.RESP.CommunicationTest).RunShell(message)
					s result = "+OK"
					s ^clientTestInput = message
					USE ..#device  WRITE result_$char(13,10),!
					USE 0 WRITE !,"End of try block",!
				} catch(e){
					USE 0 WRITE !,"Catched exception "_e,!
					//USE ..#device WRITE "Redis result is: "_result,!
				}
				
				if ($DATA(message)){
					if (message = "close"){
						QUIT
					}else {
					 ;USE ..#device  WRITE "Redis result is: "_message,!
					}
				}

			}
			do ..StopServer()
		} else{
			w "Sorry, but it is not able to open device: "_..#device_" .",!,!
		}
}

/// Will pack data into communication form in order of RESP rules.
ClassMethod PackData(data As %String, retType As %String) As %String
{
	/// Simple string
	if (retType = "sstr"){
		s data = "+"_data
	}
	/// Error
	elseif (retType = "err"){
		s data = "-"_data
	}
	/// Integer
	elseif (retType = "int"){
		s data = ":"_data
	}
	/// Bulk string
	elseif (retType = "bstr"){
		s data = "$"_data
	}
	/// Array
	elseif (retType = "array"){
		s data = "*"_data
	}
	
	return data
}

ClassMethod StartClient()
{
		/// 1 == should send messages, 0 == should exit loop as soon as possible
		s ^clientController = 1
		s int = 0
		w !,"Server starts... OPEN socket for listen at """_..#clientDevice_""":",!,!
		OPEN ..#clientDevice:(..#host:..#serverPort:"M"):2		
		if ($TEST){
			w "CLient established connection to server with device """_..#clientDevice_""" and will send messages",!,!
			while(1){
				try {
					USE 0 WRITE !,"Start loop to send messages",!
					s int = int+1
					USE ..#clientDevice  WRITE "message"_int,!
					USE 0 WRITE "message sent to server",!
					USE ..#clientDevice READ serverRespond
					USE 0 WRITE "Server respond: """_serverRespond_"""",!
				
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

ClassMethod StopClient()
{
		CLOSE ..#clientDevice
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

