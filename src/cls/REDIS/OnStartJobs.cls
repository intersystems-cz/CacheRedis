/// In this class are all methods to create jobs on start.
/// Every ClassMethod will run one specific JOB as needed.
Class REDIS.OnStartJobs Extends %Persistent
{

/// Run JOB of variable removal = variable cleaner
ClassMethod RunJobCleaner()
{
	if ('##class(REDIS.CommandsHandling.Functions).IsCleanerRunning()){
		JOB ##class(REDIS.Cleaner).Run()
	}
}

/// Kill JOB - cleaner
ClassMethod EndJobCleaner()
{
	if ('##class(REDIS.CommandsHandling.Functions).IsCleanerRunning()){
		do ##class(REDIS.CommandsHandling.Functions).KillCleaner()
	}
}

/// Run all JOBs with one ClassMethod call
ClassMethod RunAll()
{
	do ..RunJobCleaner()
	// do ..run..
	// do ..run..
}

Storage Default
{
<Data name="OnStartJobsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REDIS.OnStartJobsD</DataLocation>
<DefaultData>OnStartJobsDefaultData</DefaultData>
<IdLocation>^REDIS.OnStartJobsD</IdLocation>
<IndexLocation>^REDIS.OnStartJobsI</IndexLocation>
<StreamLocation>^REDIS.OnStartJobsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

