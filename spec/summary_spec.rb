require 'spec_helper'
module Qstat
  describe "QueueStat simple"  do
    it "should have an array of summary lines from the qstat -r command" do
      q = Summary.new()
      q.get_summary_lines.should be_an Array
    end
    it "summary lines should equal qstat -r grep output" do
      q = Summary.new()
      q.get_summary_lines[0].should eq test_lines[0]
      q.get_summary_lines.size.should eq test_lines.size
      q.get_summary_lines.should eq test_lines
    end
  end
  describe "QueueStat slow"  do
    before(:each) do
      class Detail < Hash
        def initialize(args)
          super
          types = [:error_reason, :qsid, :state, :user, :start_date, :start_time, :run_time, :wait_qsid, :thread, :queue_name,:clientcode, :jobid, :command ]
          types.each {|t| self[:type] = ''}
        end
      end     
    end
    it "should return an array containing information for each job in the system" do
      q = Summary.new
      q.load_job_details!
      q.should be_an Array
    end
    it "should return an non-empty array of Detail's if 'qstat' is found on the system" do
      q = Summary.new
      q.load_job_details!
      q.should_not be_empty
      q[0].should be_a Detail
    end
  end
end
