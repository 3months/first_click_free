require 'spec_helper'
require 'ostruct'

describe FirstClickFree::Helpers::Path, type: :helper do

  describe '.permitted_path?' do
    subject { helper.permitted_path? }

    context 'with no permitted paths' do
      it { should be_false }
    end

    describe 'with permitted paths' do
      before { FirstClickFree.permitted_paths = %w[ /another/path ] }

      context 'and mismatching path' do
        before { helper.stub(request: OpenStruct.new(fullpath: '/a/path')) }

        it { should be_false }
      end

      context 'and matching path' do
        before { helper.stub(request: OpenStruct.new(fullpath: 'http://www.example.com/another/path')) }

        it { should be_true }
      end

      context 'and matching path with params' do
        before { helper.stub(request: OpenStruct.new(fullpath: 'https://www.example.com/another/path?a=1')) }

        it { should be_true }
      end
    end
  end
end
