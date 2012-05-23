require 'spec_helper'

module Abyss

  module Navigation

    describe ".configure" do

      before { Navigation.configuration = nil }
      after  { Navigation.configuration = nil }

      it 'is shorthand for the Navigation Config API' do
        expected_block = Proc.new { }
        fake_config = mock().as_null_object
        Store.stub(:new).and_return(fake_config)
        fake_config.should_receive(:instance_eval).with(&expected_block)

        Navigation.configure &expected_block
      end

      it 'sets the root-level group as virtual' do
        fake_config = mock
        fake_config.should_receive(:virtual=).with(true)
        Store.stub(:new).and_return(fake_config)

        Navigation.configure {}
      end

    end

  end

end
