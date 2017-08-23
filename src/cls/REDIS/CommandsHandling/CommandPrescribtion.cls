/// This class is Interface for other functions in FunctionsScope
Class REDIS.CommandsHandling.CommandPrescribtion [ Abstract ]
{

/// constant max parameters
Parameter maxParameters;

/// constant min parameters
Parameter minParameters;

/// By calling this method the main routine of command for specific function should run
ClassMethod RunCommand(cmdPipeline As %List) As %String [ Abstract ]
{
}

/// After call this method should return string that contains help for specific function 
ClassMethod GetHelp() As %String [ Abstract ]
{
}

/// Special ClassMethod for making demand on implementation of prescribed methods and
/// parameters of this class. If some class extends $THIS class and will not implement
/// some of methods or parameters of this class then after compilation will programmer
/// recieve error about need of implementation of not implemented methods or parameters
ClassMethod Compile() As %Status [ CodeMode = objectgenerator, GenerateAfter = RunCommand ]
{
	set foundMethods = 0
	set foundParameters = 0
	for i=1:1:%class.Methods.Count() {
		set method = %class.Methods.GetAt(i)
		if ((method.Name = "RunCommand")||(method.Name = "GetHelp")) {
			set foundMethods = $increment(foundMethods)	
		}
	}
	for i=1:1:%class.Parameters.Count() {
		set parameter = %class.Parameters.GetAt(i)
		if ((parameter.Name = "maxParameters")) {
			set foundParameters = $increment(foundParameters)	
		}
	}
	if foundMethods'=2 return $$$ERROR($$$GeneralError, "You need to implement all compulsory methods!")
	if foundParameters'=1 return $$$ERROR($$$GeneralError, "You need to implement all compulsory parameters!")
	
	return 1
}

}

