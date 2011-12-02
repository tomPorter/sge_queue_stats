=begin
require 'spec_helper'
require_relative '../lib/queue_stat/helper'
include Qstat::Helper
module Qstat
  module Helper
    describe ".set_filter_class"  do
      session.stub!(has_key?).with(:xxx).and_return(true)
      it "should return 'filtered' if session has filter_type as a key" do
        Qstat::Helper.set_filter_class('xxx').should == 'filtered'
      end
    end
  end  
end
=end
