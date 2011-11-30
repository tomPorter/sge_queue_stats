#mock_example_spec.rb
require 'spec_helper'
module Qstat
  describe Summary  do
    before :each do
      ## This only works because Summary doesn't expect much back from CommandRunner.
      CommandRunner.stub!(:run).with('qstat -r').and_return([])
    end
    it "should have an array of summary lines from the qstat -r command when CommandRunner stubbed." do
      q = Summary.new()
      q.get_summary_lines.should be_an Array
      q.get_summary_lines.should be_empty #Makes sure I am really using my mock.
    end
  end
  describe Detail do
    before :each do
      ## Note that the three-element array is the minimum that causes Detail.new() to run without throwing an error.
      ## The Detail class does a _lot_ of work and expects CommandRunner to return very particular data.  Probably
      ## need helper methods to fill out data.
      CommandRunner.stub!(:run).with('qstat -j 2559238 2>&1').and_return(['a','b','c'])
      @run_line          = '2559238 0.55500 x.jasperx. fooork       r     11/21/2011 05:04:59 Archive@archive02                  1        '
    end
    it "should return a hash containing detail info about a job" do
      q = Detail.new(@run_line)
      q.should be_a Hash
    end
    
  end
end
