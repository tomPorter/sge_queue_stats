require 'spec_helper'
module Qstat
  describe Summary  do
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
    it "should return an non-empty array of Detail's" do
      q = Summary.new
      q.load_job_details!
      q.should_not be_empty
      q[0].should be_a Detail
    end
  end
end
