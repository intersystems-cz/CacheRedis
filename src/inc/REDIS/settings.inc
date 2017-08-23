ROUTINE REDIS [Type=INC]

/// By changing names of system globals for this API you can loss reference to
/// existing data stored under these actual global names.

/// Class "Utesting.cls" for unit tests will actually work only with old default settings global names.

/// Default settings data from top to bottom:
/// DATA="data", CLEANER="cleaner", EXPIRES="expires", TYPE="type", CLEANERPID="cleanerPid"

/// Name of data global where all redis data, keys are stored.
#define DATA "data"
/// Name of cleaner golobal to connect global keys with their expiration time.
#define CLEANER "cleaner"
/// Name of expires subscript for $$$DATA global where is expiration time saved.
#define EXPIRES "expires"
/// Name of type subscript for $$$DATA global where is stored type of variable.
#define TYPE "type"
/// Name of actual running cleaner process ID. 
#define CLEANERPID "cleanerPid"

/// Shortucts for future developers:
///
/// ^data(globalName) 				<==> 	@("^"_$$$DATA_"("""_globalName_""")")
/// ^data(globalName,"expires") 	<==> 	@("^"_$$$DATA_"("""_globalName_""","""_$$$EXPIRES_""")")
/// ^data(globalName,"type")		<==>	@("^"_$$$DATA_"("""_globalName_""","""_$$$TYPE_""")")
/// ^cleaner(timeToExp)				<==>	@("^"_$$$CLEANER_"("""_timeToExp_""")")
/// ^cleanerPid						<==>	@("^"_$$$CLEANERPID)
