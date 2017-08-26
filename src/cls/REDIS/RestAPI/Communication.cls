/// Class Methods for communication between shell/API and client = REST
Class REDIS.RestAPI.Communication Extends %CSP.REST
{

XData UrlMap
{
<Routes>

   <Route Url="/append" Method="PUT" Call="Append"/>
   <Route Url="/del" Method="PUT" Call="Del"/>
   <Route Url="/help" Method="PUT" Call="Help"/>
   
   <Route Url="/set" Method="PUT" Call="Set"/>
   <Route Url="/get" Method="PUT" Call="Get"/>
   <Route Url="/incr" Method="PUT" Call="Incr"/>
   <Route Url="/decr" Method="PUT" Call="Decr"/>
   
     <Route Url="/setTimed" Method="PUT" Call="SetTimed"/>
   
</Routes>
}

/* pattern to copy for new method/command

/// USAGE - APPEND expected input: 
/// 	1. {"key":"varName"}
///		2. {"value":"val-string"}
///
ClassMethod Append() As %Status
{
	set jsonObject = {}.%FromJSON(%request.Content)
	set result = ..TestNumArguments(jsonObject,"append")
	
	if ( result = "OK")
	{

	}
	
	set resultObj = {
		"Result": (result)
    }
    write resultObj.%ToJSON()

	return $$$OK
}

*/
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
///  {"key1":"timedVar","val1":"344","option":"EX","time":"10"}
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

/// call set method with key and value pair parameters
ClassMethod Set() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	set value = setObject.value
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("SET "_key_" "_value)
	
	set obj = {
		"Communication OK ": (result)
    }
    write obj.%ToJSON()

	return $$$OK
}

ClassMethod Get() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("GET "_key)
	
	set obj = {
		"Communication OK ": (result)
    }
    write obj.%ToJSON()

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

ClassMethod Incr() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("INCR "_key)
	
	set obj = {
		"Communication OK ": (result)
    }
    write obj.%ToJSON()

	return $$$OK
}

ClassMethod Decr() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("DECR "_key)
	
	set obj = {
		"Communication OK ": (result)
    }
    write obj.%ToJSON()

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

/*

	//if ('$D(key)){
	//	s key = ""
	//}
	//set result = ##class(REDIS.Shell).Execute("HELP "_key)
*/
ClassMethod SetTimed() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	set value = setObject.value
	set option = setObject.option
	set time = setObject.time
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("SET "_key_" "_value_" "_option_" "_time)
	
	set obj = {
		"Communication OK ": (result)
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

