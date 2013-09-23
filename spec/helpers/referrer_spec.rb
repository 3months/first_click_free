require "spec_helper"
require "ostruct"

describe FirstClickFree::Helpers::Referrer, type: :helper do

  describe ".permitted_domain?" do
    subject { helper.permitted_domain? }

    context "with permitted domain" do
      before { helper.stub(request: OpenStruct.new(referrer: "https://www.google.com/search?q=test")) }
      it { should be_true }
    end

    context "without permitted domain" do
      before { helper.stub(request: OpenStruct.new(referrer: "https://test.host/not/google")) }
      it { should be_false }
    end
  end
end
