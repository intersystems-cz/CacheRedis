/// Class Methods for communication between shell/API and client = REST
Class REDIS.RestAPI.Communication Extends %CSP.REST
{

XData UrlMap
{
<Routes>

   <Route Url="/append" Method="PUT" Call="Append"/>
   <Route Url="/decr" Method="PUT" Call="Decr"/>
   <Route Url="/decrby" Method="PUT" Call="Decrby"/>  
   <Route Url="/del" Method="DELETE" Call="Del"/>
   <Route Url="/exists" Method="PUT" Call="Exists"/>
   <Route Url="/expire" Method="POST" Call="Expire"/>
   <Route Url="/get" Method="PUT" Call="Get"/>
   <Route Url="/help" Method="PUT" Call="Help"/> <!-- test if cant have multiple methods PUT and GET -->
   <Route Url="/incr" Method="PUT" Call="Incr"/>
   <Route Url="/incrby" Method="PUT" Call="Incrby"/>
   <Route Url="/pexpire" Method="POST" Call="Pexpire"/>
   <Route Url="/ping" Method="PUT" Call="Ping"/>
   <Route Url="/pttl" Method="PUT" Call="Pttl"/>
   <Route Url="/set" Method="POST" Call="Set"/>
   <Route Url="/strlen" Method="PUT" Call="Strlen"/>
   <Route Url="/time" Method="GET" Call="Time"/> 
   <Route Url="/ttl" Method="PUT" Call="Ttl"/>
   <Route Url="/type" Method="PUT" Call="Type"/>
     
</Routes>
}

/// This REST API works by reading JSON object input and after that calling logic with JSON respond.
/// REST API can read this shape of JSON object content:
/// 
/// - name of command is covered by URL
/// {"key1":"key-string"}  == represent name of key1 (from key1 to keyN)
/// {"val1":"val-string"}  == represent value of specific key under val1 (from val1 to valN)
/// {"option1":"option-string"}  == represent string-name under option1 (from option1 to optionN)
/// {"time":"time-string"}  == represent time number under time
/// 
/// 
/// Example of full call of JSON object, for example for URL /set:
///  {"key1":"timedVar","val1":"344","opt1":"EX","time":"10"}
/// USAGE - APPEND expected input: 
/// 	1. {"key1":"varName"}
/// 		2. {"val1":"val-string"}
/// 
ClassMethod Append() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"append")
	
	if ( result = "OK")
	{
		set result = ##class(REDIS.API).Append(jsonObject.key1,jsonObject.val1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - SET expected input: 
/// 	1. {"key1":"varName"}
/// 		2. {"val1":"val-string"}
/// 		3. {"opt1":"val-option"}
/// 		4. {"opt2":"val-option"}
/// 		5. {"val2":"val-option"}
/// 
/// Examples of full call of JSON object, for example for URL /set:
///  {"key1":"timedVar","val1":"344","opt1":"EX","time":"10"}
///  {"key1":"timedVar","val1":"344","opt1":"NX","opt2":"EX","time":"10"}
///  {"key1":"timedVar","val1":"344","opt1":"EX","time":"10","opt2":"XX"}
///  {"key1":"timedVar","val1":"344","}
/// 
ClassMethod Set() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"set")
	
	if ( result = "OK")
	{
		set iter = jsonObject.%GetIterator()
		
		s keyNumber = 0
		while iter.%GetNext(.key, .value) {
			s keyNumber = $Increment(keyNumber,1)
			if (keyNumber = 1){
				s list = $LB(value)
			}else{
				s list = list_$LB(value)
			} 
		}
	
	    s result = ##class(REDIS.API).Set(list)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - GET expected input: 
/// 	1. {"key1":"varName"}
/// 
ClassMethod Get() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"get")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Get(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - DELETE expected input: 
/// 	1. {"key1":"var1"}
/// 		2. {"key2":"var2"}
/// 		3. - N. {"keyN":"varN"}
/// 
ClassMethod Del() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"del")
	
	if ( result = "OK")
	{
		set iter = jsonObject.%GetIterator()
		
		s keyNumber = 0
		while iter.%GetNext(.key, .value) {
			s keyNumber = $Increment(keyNumber,1)
			if (keyNumber = 1){
				s list = $LB(value)
			}else{
				s list = list_$LB(value)
			} 
		}
	
	    s result = ##class(REDIS.API).Del(list)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - INCR expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Incr() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"incr")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Incr(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - DECR expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Decr() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"decr")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Decr(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - DECRBY expected input: 
/// 	1. {"key1":"var1"}
/// 	2. {"val1":"integer"}
/// 
ClassMethod Decrby() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"decrby")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Decrby(jsonObject.key1,jsonObject.val1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - INCRBY expected input: 
/// 	1. {"key1":"var1"}
/// 	2. {"val1":"integer"}
/// 
ClassMethod Incrby() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"incrby")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Incrby(jsonObject.key1,jsonObject.val1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - EXISTS expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Exists() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"exists")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Exists(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - EXPIRE expected input: 
/// 	1. {"key1":"var1"}
/// 		2. {"time":"seconds"}
/// 
ClassMethod Expire() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"expire")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Expire(jsonObject.key1,jsonObject.time)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - PEXPIRE expected input: 
/// 	1. {"key1":"var1"}
/// 		2. {"time":"miliseconds"}
/// 
ClassMethod Pexpire() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"pexpire")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Pexpire(jsonObject.key1,jsonObject.time)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - PING expected input: 
/// 	1. {"val1":"value-to-return"} - optional
/// 
ClassMethod Ping() As %Status
{

	try {
		set jsonObject = {}.%FromJSON(%request.Content)
		set result = ..TestNumArguments(jsonObject,"ping")
		s val = jsonObject.val1
	} catch(e){
		/// if called help without keys
		s val = ""
	}
	
	if ( result = "OK")
	{
		if (val =""){
			s result = ##class(REDIS.API).Ping()
		}else{
			s result = ##class(REDIS.API).Ping(val)
		}
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - PTTL expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Pttl() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"pttl")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Pttl(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - TTL expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Ttl() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"ttl")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Ttl(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - STRLEN expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Strlen() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"strlen")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Strlen(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - TIME expected input: 
/// 	1. {} - or no object
/// 
ClassMethod Time() As %Status
{
	try{
		set jsonObject = {}.%FromJSON(%request.Content)
		set result = ..TestNumArguments(jsonObject,"time")
	}
	catch(e){
		set result = "OK"
	}
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Time()
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - TYPE expected input: 
/// 	1. {"key1":"var1"}
/// 
ClassMethod Type() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"type")
	
	if ( result = "OK")
	{
	    s result = ##class(REDIS.API).Type(jsonObject.key1)
	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

/// USAGE - HELP expected input: 
/// 	1. {"key1":"get"}
/// 		2. {"key1":""}
/// 		3. empty JSON object
/// 
ClassMethod Help() As %Status
{
	try {
		set jsonObject = {}.%FromJSON(%request.Content)
		set key1 = jsonObject.key1
	} catch(e){
		/// if called help without keys
		s key1 = ""
	}
	
	set result = ..TestNumArguments(jsonObject,"help")
	
	if ( result = "OK")
	{
		set result = ##class(REDIS.API).Help(key1)
	}
	
	set obj = {
		"Result": (result)
    }
    write obj.%ToJSON()

	return $$$OK
}

/// Test number of possible arguments for specific command.
/// Method will return string "OK", or error in string.
ClassMethod TestNumArguments(jsonObject, commandName As %String) As %String
{
	s result = "OK"
	s commandName = $ZCONVERT(commandName,"U")

	set iter = jsonObject.%GetIterator()

	s keyNumber = 0
	s temp = $LB("")
	while iter.%GetNext(.key, .value) {
	    s keyNumber = $Increment(keyNumber,1)
	    s temp = temp_$LB("")
	}
	set classFunction = "REDIS.Commands."_commandName
	set maxParameters = $PARAMETER(classFunction,"maxParameters")
	set minParameters = $PARAMETER(classFunction,"minParameters")
	
	if (keyNumber > maxParameters){
			set result = ##class(REDIS.Terminal.ErrorHandler).ParamExceeded(temp, maxParameters)
	}else{
		if (keyNumber < minParameters){
			set result = ##class(REDIS.Terminal.ErrorHandler).ParamExceeded(temp, minParameters)				
		}
	}

	ret result
}

/// Apply some settings for all requests
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	set %response.CharSet = "utf-8"
	set %response.ContentType = "application/json"
	do %response.SetHeader("Access-Control-Allow-Origin", "*")
	return $$$OK
}

}

