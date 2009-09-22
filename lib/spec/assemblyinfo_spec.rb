require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'assemblyinfotester'
require 'assemblyinfo'

describe AssemblyInfo, "when providing custom attributes" do
	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.custom_attributes :CustomAttribute => "custom attribute data", :AnotherAttribute => "more data here"

		asm.file = @tester.assemblyinfo_file
		asm.write
		@filedata = @tester.read_assemblyinfo_file
	end
	
	it "should write the custom attributes to the assembly info file" do
		@filedata.should include("[assembly: CustomAttribute(\"custom attribute data\")]")
		@filedata.should include("[assembly: AnotherAttribute(\"more data here\")]")
	end
end

describe AssemblyInfo, "when specifying a custom attribute with no data" do
	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.custom_attributes :NoArgsAttribute => nil

		asm.file = @tester.assemblyinfo_file
		asm.write
		@filedata = @tester.read_assemblyinfo_file		
	end
	
	it "should write the attribute with an empty argument list" do
		@filedata.should include("[assembly: NoArgsAttribute()]")
	end
end

describe AssemblyInfo, "when specifying an attribute with non-string data" do
	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.custom_attributes :NonStringAttribute => true

		asm.file = @tester.assemblyinfo_file
		asm.write
		@filedata = @tester.read_assemblyinfo_file		
	end
	
	it "should write the attribute data without quotes" do
		@filedata.should include("[assembly: NonStringAttribute(true)]")
	end
end

describe AssemblyInfo, "when generating an assembly info file" do
	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.version = @tester.version
		asm.title = @tester.title
		asm.description = @tester.description
		asm.copyright = @tester.copyright
		
		asm.file = @tester.assemblyinfo_file
		asm.write
		@filedata = @tester.read_assemblyinfo_file
	end
	
	it "should use the system.reflection namespace" do
		@filedata.should include("using System.Reflection;")
	end
	
	it "should use the system.runtime.interopservices namespace" do
		@filedata.should include("using System.Runtime.InteropServices;")
	end
	
	it "should contain the specified version information" do
		@filedata.should include("[assembly: AssemblyVersion(\"#{@tester.version}\")]")
	end
	
	it "should contain the assembly title" do
		@filedata.should include("[assembly: AssemblyTitle(\"#{@tester.title}\")]")
	end
	
	it "should contain the assembly description" do
		@filedata.should include("[assembly: AssemblyDescription(\"#{@tester.description}\")]")
	end
	
	it "should contain the copyright information" do
		@filedata.should include("[assembly: AssemblyCopyright(\"#{@tester.copyright}\")]")
	end
end

describe AssemblyInfo, "when generating an assembly info file with no attributes provided" do
	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.file = @tester.assemblyinfo_file
		asm.write
		@filedata = @tester.read_assemblyinfo_file
	end
	
	it "should not contain the specified version information" do
		@filedata.should_not include("[assembly: AssemblyVersion(\"#{@tester.version}\")]")
	end
	
	it "should not contain the assembly title" do
		@filedata.should_not include("[assembly: AssemblyTitle(\"#{@tester.title}\")]")
	end
	
	it "should not contain the assembly description" do
		@filedata.should_not include("[assembly: AssemblyDescription(\"#{@tester.description}\")]")
	end
	
	it "should not contain the copyright information" do
		@filedata.should_not include("[assembly: AssemblyCopyright(\"#{@tester.copyright}\")]")
	end
end