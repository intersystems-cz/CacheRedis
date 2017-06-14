Class REDIS.RestAPI.Communication Extends %CSP.REST
{

XData UrlMap
{
<Routes>
   <Route Url="/set" Method="PUT" Call="Set"/>
   <Route Url="/get" Method="PUT" Call="Get"/>
   <Route Url="/del" Method="PUT" Call="Del"/>
   <Route Url="/incr" Method="PUT" Call="Incr"/>
   <Route Url="/decr" Method="PUT" Call="Decr"/>
   <Route Url="/help" Method="PUT" Call="Help"/>
   
     <Route Url="/setTimed" Method="PUT" Call="SetTimed"/>
   
   <!-- Your goal is to implement /message URL route, and just like with /ping
   	you need to output the data in JSON format. My program will expect "message" 
   	property in JSON object you output. -->
</Routes>
}

/// call set function with key and value pair parameters
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

ClassMethod Del() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("DEL "_key)
	
	set obj = {
		"Communication OK ": (result)
    }
    write obj.%ToJSON()

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

ClassMethod Help() As %Status
{
	set setObject = {}.%FromJSON(%request.Content)
	set key = setObject.key
	
	set redis = ##class(REDIS.Terminal.InputHandler).%New(0)
	set result = redis.Run("HELP "_key)
	
	set obj = {
		"Communication OK ": (result)
    }
    write obj.%ToJSON()

	return $$$OK
}

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

/// Apply some settings for all requests
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	set %response.CharSet = "utf-8"
	set %response.ContentType = "application/json"
	do %response.SetHeader("Access-Control-Allow-Origin", "*")
	return $$$OK
}

}

