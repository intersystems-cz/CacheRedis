Class REDIS.Commands.PEXPIRE Extends REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters = 2;

ClassMethod RunCommand(cmdPipeline As %List) As %String
{
	set result = ""
	
	do ##class(REDIS.CommandsHandling.Functions).LockGlobal($LIST(cmdPipeline,2))
	
	if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),1)){
			/// test if variable exist as expire variable
		if (##class(REDIS.CommandsHandling.Functions).IsGlobal($LIST(cmdPipeline,2),2) '= 0 ){
			//kill ^cleaner(^data($LIST(cmdPipeline,2),"expires"))
			//kill ^data($LIST(cmdPipeline,2))
			   set value = ##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))

			   if (  ##class(REDIS.CommandsHandling.Functions).GetLeftTimeToLive($LIST(cmdPipeline,2)) > 0 && $DATA(value)){
			   
			   		set num = $LIST(cmdPipeline,3)		
						
					// TODO TEST IF seconds($LIST(cmdPipeline,3)) is NUMBER, 
					// redis allows even 00023 format interpreted as 23s
					if ($isvalidnum(num)&&(+num\1=+num)) {
										
					 	s globalValue = ##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
						do ##class(REDIS.CommandsHandling.Functions).SetTimedVariable($LIST(cmdPipeline,2),globalValue,($LIST(cmdPipeline,3)/1000))
						
						// interrupt cleaner process to recalculate hang time
						do $System.Util.SendInterrupt(^cleanerPid)
						
						set result = "(integer) 1"
					  
					} else {
					 set result = ##class(REDIS.Terminal.ErrorHandler).NotNumber(cmdPipeline)
					}

					
			   } else{
				set result = "(integer) 0"
			   }
		}else {
		
			set value = ##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
			set num = $LIST(cmdPipeline,3)		
			
			if ($isvalidnum(num)&&(+num\1=+num)) {	
					 
			 	s globalValue = ##class(REDIS.CommandsHandling.Functions).GetData($LIST(cmdPipeline,2))
				do ##class(REDIS.CommandsHandling.Functions).SetTimedVariable($LIST(cmdPipeline,2),globalValue,($LIST(cmdPipeline,3)/1000))
				
				// interrupt cleaner process to recalculate hang time
				do $System.Util.SendInterrupt(^cleanerPid)
				
				set result = "(integer) 1"
					  
			} else {
			 set result = ##class(REDIS.Terminal.ErrorHandler).NotNumber(cmdPipeline)
			}
			
		}
	}else{
		set result = "(integer) 0"
	}
	
	do ##class(REDIS.CommandsHandling.Functions).UnlockGlobal($LIST(cmdPipeline,2))
	
	return result
}

ClassMethod GetHelp() As %String
{
	return $char(10,13)_$Char(27)_"[33m"_"  EXPIRE key seconds"_$char(10,13)_$char(10,13)_$Char(27)_"[0m"_
	$Char(27)_"[35m"_"  TIME COMPLEXITY:"_$Char(27)_"[0m"_" O(1)"_$char(10,13)_$char(10,13)_
	$Char(27)_"[35m"_"  DESCRIPTION:"_$Char(27)_"[0m"_"  This command works exactly like EXPIRE but the time to live of the key "_$char(10,13)_
	$char(9)_$char(9)_"is specified in milliseconds instead of seconds. "_$char(10,13)_$char(10,13)_
    $Char(27)_"[35m"_"  RETURN VALUE:"_$Char(27)_"[0m"_" integer reply, specifically:"_$char(10,13)_
    $Char(27)_"!<HTML><ul><ul><ul><ul><li>1 if the timeout was set.</li>"_
	"<li>0 if key does not exist or the timeout could not be set.</li></ul></ul></ul></ul></HTML>"_$char(10,13)
}

}

