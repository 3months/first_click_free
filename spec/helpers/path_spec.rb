require 'spec_helper'
require 'ostruct'

describe FirstClickFree::Helpers::Path, type: :helper do

  describe '.permitted_path?' do
    subject { helper.permitted_path? }

    context 'with no permitted paths' do
      it { should be_false }
    end

    context 'with mismatching permitted paths' do
      before do
        helper.stub(request: OpenStruct.new(path: '/a/path'))
        FirstClickFree.permitted_paths = %w[ /another/path ]
      end

      it { should be_false }
    end

    context 'with matching permitted paths' do
      before do
        helper.stub(request: OpenStruct.new(path: '/another/path'))
        FirstClickFree.permitted_paths = %w[ /another/path ]
      end

      it { should be_true }
    end

  end
end
