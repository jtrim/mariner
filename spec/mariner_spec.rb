require 'spec_helper'

module Mariner

  describe ".configure" do

    before { Mariner.configuration = nil }
    after  { Mariner.configuration = nil }

    it 'is shorthand for the navigation Config API' do
      expected_block = Proc.new { }
      fake_config = mock().as_null_object
      Store.stub(:new).and_return(fake_config)
      fake_config.should_receive(:instance_eval).with(&expected_block)

      Mariner.configure &expected_block
    end

    it 'sets the root-level group as virtual' do
      fake_config = mock
      fake_config.should_receive(:virtual=).with(true)
      Store.stub(:new).and_return(fake_config)

      Mariner.configure {}
    end

  end

end
