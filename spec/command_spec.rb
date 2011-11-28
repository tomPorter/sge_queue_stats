require 'spec_helper'
module Qstat
  describe CommandRunner  do
  	it "should throw an exception if the command is not a valid 'qstat' command" do
		  lambda{CommandRunner.run('xxx')}.should raise_error(InvalidQstatCommandError)
	  end
  	it "should throw an exception if run with 'qstat -j'" do
		  lambda{CommandRunner.run('qstat -j')}.should raise_error(InvalidQstatCommandError)
	  end
    it "should return a non-empty array of command output if run with 'qstat -r'" do
      CommandRunner.run('qstat -r').should be_an Array
      CommandRunner.run('qstat -r').should_not be_empty
    end
    it "should return a non-empty array of command output if run with 'qstat -j {qsid}'" do
      CommandRunner.run('qstat -j 12345').should be_an Array
      CommandRunner.run('qstat -j 12345').should_not be_empty
    end
  end
end
