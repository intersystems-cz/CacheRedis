Include REDIS.settings

Class REDIS.Utesting Extends %UnitTest.TestCase
{

/// to test unit testing with this class, use: do ##class(%UnitTest.Manager).RunTest("mytests")
Method TestStrlen()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 
	 s ^data("test") = ""
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("STRLEN test"),"0", "Test STRLEN on empty string variable")
	 
	/// if someone used "test2" global, backup data
	 if ($DATA(^data("test2"))) {
	 	s temp2 = ^data("test2")
	 }
	 
	 s ^data("test2") = ""
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("STRLEN test2"),"0", "Test STRLEN on non existing variable")

	/// if someone used "test3" global, backup data
	 if ($DATA(^data("test3"))) {
	 	s temp3 = ^data("test3")
	 	/// sorry, but subscripts will die .. maybe TODO
	 	kill ^data("test3")
	 }
	
	 s ^data("test3") ="4fs2332df5"
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("STRLEN test3"),"7", "Test STRLEN on wrong value 7, 10 is correct")
	 
	 
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

	 do $$$AssertEquals(##class(REDIS.Shell).Execute("APPEND test supervalue45data"),"16", "Test APPEND on non existing variable")
	 
	 kill ^data("test")
	 s ^data("test") = "supervalue45data"
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("APPEND test anotherData"),"15", "Test APPEND on existing variable on wrong value")

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
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECR test"),"72", "Test DECR on existing positive number variable")
	 
	 s ^data("test") = 0
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("DECR test"),"1", "Test DECR on underzero result on wrong number")
	 
	 kill ^data("test")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECR test"),"-1", "Test DECR on non existing variable")
	 
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
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECRBY test 43"),"489", "Test DECRBY on existing positive number variable")
	 
	 s ^data("test") = 0
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("DECRBY test 50"),"50", "Test DECRBY on underzero result on wrong number")
	 
	 kill ^data("test")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DECRBY test 37"),"-37", "Test DECRBY on non existing variable")
	 
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
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DEL test"),"1", "Test DEL on existing variable")
	 
	 s ^data("test") = 2344525
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DEL test4"),"0", "Test DEL on non existing variable")
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("DEL test test2"),"1", "Test DEL multiple arguments")
	 
	 s ^data("test") = 2344525
	 s ^data("test2") = 5346634
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("DEL test test2 test3 test4"),"3", "Test DEL multiple arguments")
	 	 
	 
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
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("EXISTS test"),"1", "Test EXISTS on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("EXISTS test"),"1", "Test EXISTS on existing variable")
	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestExpire()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 s isRunning = ##class(REDIS.CommandsHandling.Functions).IsCleanerRunning()
	 
	 /// rerun cleaner
	 if (isRunning){
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 	HANG 1
	 }
	 do ##class(REDIS.OnStartJobs).RunJobCleaner()
	 HANG 1
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("EXPIRE test 2"),"1", "Test EXPIRE on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("EXPIRE test 2"),"1", "Test EXPIRE on existing variable")
	 
	 HANG 3
	 
	 s deleted = 0
	 
	 if ('$DATA(^data("test"))){
	 	s deleted = 1
	 }
	 
	 do $$$AssertEquals(deleted,1, "Test EXPIRE if variable expired")

	 if ('isRunning)
	 {
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 }
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestPexpire()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 set isRunning = ##class(REDIS.CommandsHandling.Functions).IsCleanerRunning()
	 
	 /// rerun cleaner
	 if (isRunning){
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 	HANG 1
	 }
	 do ##class(REDIS.OnStartJobs).RunJobCleaner()
	 HANG 1
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("PEXPIRE test 2000"),"1", "Test PEXPIRE on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("PEXPIRE test 2000"),"1", "Test PEXPIRE on existing variable")
	 
	 HANG 3
	 
	 s deleted = 0
	 
	 if ('$DATA(^data("test"))){
	 	s deleted = 1
	 }
	 
	 do $$$AssertEquals(deleted,1, "Test PEXPIRE if variable expired")

	 if ('isRunning)
	 {
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 }
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestTtl()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 s isRunning = ##class(REDIS.CommandsHandling.Functions).IsCleanerRunning()
	 
	 /// rerun cleaner
	 if (isRunning){
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 	HANG 1
	 }
	 do ##class(REDIS.OnStartJobs).RunJobCleaner()
	 HANG 1
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("TTL test"),"-2", "Test TTL on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("TTL test"),"-1", "Test TTL on existing variable")
	 
	 
	set actualTime = $NOW()
	set dateval = $PIECE(actualTime,",",1)
	set timeval = $PIECE(actualTime,",",2)
	// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
	set actualTimeInSec = dateval*24*3600 + timeval
	set whenToKillVariable = actualTimeInSec + 20
	s ^data("test","expires") = whenToKillVariable
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("TTL test"),"20", "Test TTL on existing timed variable")
	 
	 HANG 0.95
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("TTL test"),"19", "Test TTL on existing timed variable")
	 
	 if ('isRunning)
	 {
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 }
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 	kill ^data("test","expires")
	 }else{
	 	kill ^data("test")
	 }
}

Method TestPttl()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 s isRunning = ##class(REDIS.CommandsHandling.Functions).IsCleanerRunning()
	 
	 /// rerun cleaner
	 if (isRunning){
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 	HANG 1
	 }
	 do ##class(REDIS.OnStartJobs).RunJobCleaner()
	 HANG 1
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("PTTL test"),"-2", "Test PTTL on non existing variable")
	 
	 s ^data("test") = 42342
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("PTTL test"),"-1", "Test TTL on existing variable")
	 
	 
	set actualTime = $NOW()
	set dateval = $PIECE(actualTime,",",1)
	set timeval = $PIECE(actualTime,",",2)
	// numberOfDays * numberOfHoursAday * numberOfSecondsAHour
	set actualTimeInSec = dateval*24*3600 + timeval
	set whenToKillVariable = actualTimeInSec + 101
	s ^data("test","expires") = whenToKillVariable
	 
	 do $$$AssertEquals($length(##class(REDIS.Shell).Execute("PTTL test")) = 6 ,1, "Test PTTL on existing timed variable")
	 
	 HANG 1.5
	 
	 do $$$AssertEquals($length(##class(REDIS.Shell).Execute("PTTL test")) = 5,1, "Test PTTL on existing timed variable")
	 
	 if ('isRunning)
	 {
	 	do ##class(REDIS.OnStartJobs).EndJobCleaner()
	 } 
	 	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 	kill ^data("test","expires")
	 }else{
	 	kill ^data("test")
	 }
}

Method TestGet()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }

	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("GET test"),"1", "Test GET on non existing variable")
	 
	 s ^data("test") = "my23test55"
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("GET test"),"(nil)", "Test GET on existing variable")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("GET test"),"my23test55", "Test GET on existing variable")
	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestSet()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }

	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("SET test 3553fsdf356"),"OK", "Test SET on non existing variable")
	 
	 s ^data("test") = "my23test55"
	 	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("SET test abcdef EX 2"),"OK", "Test SET to set timed variable")
	 
	 HANG 2.5
	 
	 do $$$AssertNotEquals($DATA(^data("test")),1, "Test SET if variable expired")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("SET test abcdef PX 700"),"OK", "Test SET to set timed variable with milisec")
	 
	 HANG 1
	 
	 do $$$AssertNotEquals($DATA(^data("test")),1, "Test SET if variable expired")
	 
	 k ^data("test")
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("SET test data53 NX"),"(nil)", "Test SET on non existing var")
	 
	 s ^data("test") = "asdd355sf"
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("SET test data34 XX"),"OK", "Test SET on non existing var")
	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestTime()
{

	s temp = ##class(REDIS.Shell).Execute("time")

	s seconds = $replace($piece(temp,$char(10,13),1)," 1)  ","")
	s miliseconds = $replace($piece(temp,$char(10,13),2)," 2)  ","")
		 
	do $$$AssertEquals($isvalidnum(seconds)&&(+seconds\1=+seconds),1, "Test TIME on seconds - valid number?")
	do $$$AssertEquals((+seconds\1=+seconds),1, "Test TIME on seconds - is integer?")
	do $$$AssertEquals($isvalidnum(miliseconds)&&(+miliseconds\1=+miliseconds),1, "Test TIME on miliseconds - valid number?")
	do $$$AssertEquals((+miliseconds\1=+miliseconds),1, "Test TIME on miliseconds - is integer?")
}

Method TestType()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("TYPE test"),"""none""", "Test TYPE on non existing variable")
	 s ^data("test") = "my23test55"
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("TYPE test"),"""string""", "Test TYPE on existing variable")

	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestHelp()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 	kill ^data("test")
	 }

	 
	 do $$$AssertEquals($length(##class(REDIS.Shell).Execute("help")) > 300,1, "Test HELP of returning string longer than 300 chars")

	/// GET ALL COMPILED CLASSES FROM PACKAGE: Commands	
	&sql(select LIST(id) into :classesList from %Dictionary.CompiledClass where
	id LIKE 'REDIS.Commands.%' AND id not like 'REDIS.Commands.HELP' ORDER BY id ASC)
			
	set classesList = $LISTFROMSTRING(classesList)
	
	for i=1:1:$ll(classesList)
	{
	 set result = $CLASSMETHOD($LIST(classesList,i), "GetHelp")	 
	 do $$$AssertEquals($length(result) > 50,1, "Test HELP of command "_$PIECE($LIST(classesList,i),".",3)_" returning string longer than 50 chars")
	}	 
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestIncr()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 s ^data("test") = 73
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("INCR test"),"74", "Test INCR on existing positive number variable")
	 
	 s ^data("test") = 0
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("INCR test"),"-1", "Test INCR on positive result on wrong number")
	 
	 kill ^data("test")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("INCR test"),"1", "Test INCR on non existing variable")
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestIncrby()
{
	/// if someone used "test" global, backup data
	 if ($DATA(^data("test"))) {
	 	s temp = ^data("test")
	 }
	 s ^data("test") = 532
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("INCRBY test 43"),"575", "Test INCRBY on existing positive number variable")
	 
	 s ^data("test") = 0
	 	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("INCRBY test 50"),"-50", "Test INCRBY on positive result on wrong number")
	 
	 kill ^data("test")
	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("INCRBY test 37"),"37", "Test INCRBY on non existing variable")
	 
	 if ($DATA(temp)) {
	 	s ^data("test") = temp
	 }else{
	 	kill ^data("test")
	 }
}

Method TestPing()
{
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("ping"),"PONG", "Test PING on basic respond")
	 	 
	 do $$$AssertEquals(##class(REDIS.Shell).Execute("ping hello_world"),"hello_world", "Test PING on string respond")
	 
	 do $$$AssertNotEquals(##class(REDIS.Shell).Execute("ping no_problem"),"problem", "Test PING on string incorrect respond")
}

}

