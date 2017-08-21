Class REDIS.Utest Extends %UnitTest.TestCase
{

/// to test unit testing with this class, use: do ##class(%UnitTest.Manager).RunTest("mytests")
Method TestStrlen()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 
	 s ^data("test") = ""
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("STRLEN test"),"(integer) 0", "Test STRLEN on empty string variable")
	 
	/// if someone used "test2" global, backup data
	 if ($DATA(^data("test2"))) {
	 	s temp2 = ^data("test2")
	 }
	 
	 s ^data("test2") = ""
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("STRLEN test2"),"(integer) 0", "Test STRLEN on non existing variable")

	/// if someone used "test3" global, backup data
	 if ($DATA(^data("test3"))) {
	 	s temp3 = ^data("test3")
	 	/// sorry, but subscripts will die .. maybe TODO
	 	kill ^data("test3")
	 }
	
	 s ^data("test3") ="4fs2332df5"
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("STRLEN test3"),"(integer) 7", "Test STRLEN on wrong value 7, 10 is correct")
	 
	 
	 if ($DATA(temp)){
	 	s ^data("test") = temp
	 }
	 else{
	 	kill ^data("test")
	 }
	 
	 if ($DATA(temp2)){
	 	s ^data("test2") = temp2
	 }
	 else{
	 	kill ^data("test2")
	 }
	 
	 if ($DATA(temp3)){
	 	s ^data("test3") = temp3
	 }
	 else{
	 	kill ^data("test3")
	 }
}

Method TestAppend()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }

	 do $$$AssertEquals(##class(REDIS.Shell).Execute("APPEND test supervalue45data"),"(integer) 16", "Test on non existing variable")
	 
	 kill ^data("test")
	 s ^data("test") = "supervalue45data"
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("APPEND test anotherData"),"(integer) 15", "Test on existing variable on wrong value")

	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }
	 else{
	 	kill ^data("test")
	 }
}

Method TestDecr()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 s ^data("test") = 73
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECR test"),"(integer) 72", "Test DECR on existing positive number variable")
	 
	 s ^data("test") = 0
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("DECR test"),"(integer) 1", "Test DECR on underzero result on wrong number")
	 
	 kill ^data("test")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECR test"),"(integer) -1", "Test DECR on non existing variable")
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestDecrby()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 s ^data("test") = 532
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECRBY test 43"),"(integer) 489", "Test DECRBY on existing positive number variable")
	 
	 s ^data("test") = 0
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("DECRBY test 50"),"(integer) 50", "Test DECRBY on underzero result on wrong number")
	 
	 kill ^data("test")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECRBY test 37"),"(integer) -37", "Test DECRBY on non existing variable")
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestDel()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 
	 /// if someone used "test2" global, backup data
	 if ($DATA(^data("test2"))) {
	 	s temp2 = ^data("test2")
	 }
	 
	 /// if someone used "test3" global, backup data
	 if ($DATA(^data("test3"))) {
	 	s temp3 = ^data("test3")
	 }
	 
	 /// if someone used "test4" global, backup data
	 if ($DATA(^data("test4"))) {
	 	s temp4 = ^data("test4")
	 	kill ^data("test4")
	 }
	 
	 s ^data("test") = "5sdfsddf3sdg2"
	 s ^data("test2") = "5dfsdf3sdg2"
	 s ^data("test3") = "hfhdf5df3sdg234543"
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DEL test"),"(integer) 1", "Test DEL on existing variable")
	 
	 s ^data("test") = 2344525
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DEL test4"),"(integer) 0", "Test DEL on non existing variable")
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("DEL test test2"),"(integer) 1", "Test DEL multiple arguments")
	 
	 s ^data("test") = 2344525
	 s ^data("test2") = 5346634
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DEL test test2 test3 test4"),"(integer) 3", "Test DEL multiple arguments")
	 	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
	 
	 if ($DATA(temp2)) {
	 	s ^data("test2") = temp2
	 }else{
	 	kill ^data("test2")
	 }
	 
	 if ($DATA(temp3)) {
	 	s ^data("test3") = temp3
	 }else{
	 	kill ^data("test3")
	 }
	 
	 if ($DATA(temp4)) {
	 	s ^data("test4") = temp4
	 }else{
	 	kill ^data("test4")
	 }
}

Method TestExists()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("EXISTS test"),"(integer) 1", "Test EXISTS on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("EXISTS test"),"(integer) 1", "Test EXISTS on existing variable")
	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

/*
Method TestExpire()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 /// implement functions for cleaner: -- cleaner working, cleaner kill ... kill not implemented yet..
	 /// at the beginning I will call cleaner create and after test cleaner kill
	 
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("EXPIRE test 2"),"(integer) 1", "Test EXISTS on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("EXISTS test"),"(integer) 1", "Test EXISTS on existing variable")
	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
	 
	 
}
*/
}

