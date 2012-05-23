require 'spec_helper'

module Abyss

  module Navigation

    describe UnorderedListRenderer do

      describe "#initialize" do

        describe "option_assignment" do

          subject { UnorderedListRenderer.new(:render_titles => "PHONE") }

          its(:render_titles) { should == "PHONE" }

        end

      end

      describe "#render_titles?" do

        it "aliases the attrbiute_reader" do
          subject.method(:render_titles).should == subject.method(:render_titles?)
        end

      end

      describe "#factory" do

        it "can factory a GroupRenderer" do
          subject.factory(:group, stub(Store)).should be_instance_of UnorderedListRenderer::GroupRenderer
        end

        it "can factory an ItemRenderer" do
          subject.factory(:item, stub(Url)).should be_instance_of UnorderedListRenderer::ItemRenderer
        end

      end

    end

    describe UnorderedListRenderer::ItemRenderer do

      describe "#initialize" do

        let(:fake_renderer) { stub(UnorderedListRenderer) }
        let(:fake_entity)   { stub }

        subject { UnorderedListRenderer::ItemRenderer.new(fake_entity, fake_renderer) }

        its(:subject)  { should == fake_entity }
        its(:renderer) { should == fake_renderer }

      end

      # Method #render is not tested here. See
      # spec/integrations/unordered_list_renderer_spec

      describe "#render_options" do

        subject { UnorderedListRenderer::ItemRenderer.new(url, UnorderedListRenderer.new) }

        before { url.stub(:root_path).and_return("/") }

        context 'when no additional class is specified in render_options' do

          let(:url) { Url.new(:root_path, "Title", {}) }

          it 'returns the correct attributes' do
            subject.render_options.should == { :href => "/", :class => "root_path" }
          end

        end

        context 'when an additional class is specified' do

          let(:url) { Url.new(:root_path, "Title", {:class => 'additional'}) }

          it 'returns the correct attributes' do
            subject.render_options.should == { :href => "/", :class => "additional root_path" }
          end

        end

        context 'when an additional options are specified' do

          let(:url) { Url.new(:root_path, "Title", {:placeholder => 'foo'}) }

          it 'returns the correct attributes' do
            subject.render_options.should == { :href => "/", :class => "root_path", :placeholder => 'foo' }
          end

        end

      end

    end

    describe UnorderedListRenderer::GroupRenderer do

      describe "#initialize" do

        let(:fake_renderer) { stub(UnorderedListRenderer) }
        let(:fake_entity)   { stub }

        subject { UnorderedListRenderer::GroupRenderer.new(fake_entity, fake_renderer) }

        its(:subject)  { should == fake_entity }
        its(:renderer) { should == fake_renderer }

      end

      # Method #render is not tested here. See
      # spec/integrations/unordered_list_renderer_spec

    end

  end

end
