require "spec_helper"
require "ostruct"

describe FirstClickFree::Helpers::Referrer, type: :helper do

  describe ".permitted_domain?" do
    subject { helper.permitted_domain? }

    context "test mode" do
      before { FirstClickFree.test_mode = true }
      subject { helper.permitted_domain? }

      context "correct parameter is set" do
        before { helper.stub(params: {google_referrer: true}) }
        it { should be_true }
      end

      context "parameter is not set" do
        before { helper.stub(params: {}) }
        it { should be_false }
      end
    end

    context "with permitted domain" do
      before { helper.stub(request: OpenStruct.new(referrer: "https://www.google.com/search?q=test")) }
      it { should be_true }
    end

    context "without permitted domain" do
      before { helper.stub(request: OpenStruct.new(referrer: "https://test.host/not/google")) }
      it { should be_false }
    end

    context "no referrer" do
      before { helper.stub(request: OpenStruct.new(referrer: nil)) }
      it { should be_false }
    end
  end
end
