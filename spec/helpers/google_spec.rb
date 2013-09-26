require "spec_helper"
require "ostruct"

describe FirstClickFree::Helpers::Google, type: :helper do

  describe "#googlebot?" do

    context "test mode" do
      before { FirstClickFree.test_mode = true }
      subject { helper.googlebot?(false) }

      context "correct parameter is set" do
        before { helper.stub(params: {googlebot: true}) }
        it { should be_true }
      end

      context "parameter is not set" do
        before { helper.stub(params: {}) }
        it { should be_false }
      end
    end

    context "not verifying DNS" do
      subject { helper.googlebot?(false) }

      context "user agent matches" do
        before { helper.stub(request: OpenStruct.new(user_agent: "Googlebot")) }
        it { subject.should be_true }
      end

      context "user agent does not match" do
        before { helper.stub(request: OpenStruct.new(user_agent: "Google Chrome")) }
        it { subject.should be_false }
      end
    end

    context "verifying DNS" do
      subject { helper.googlebot?(true) }

      context "user agent matches, DNS verified" do
        before { helper.stub(request: OpenStruct.new(user_agent: "Googlebot"), verify_googlebot_domain: true) }
        it { subject.should be_true }
      end

      context "user agent matches, DNS not verified" do
        before { helper.stub(request: OpenStruct.new(user_agent: "Googlebot"), verify_googlebot_domain: false) }
        it { subject.should be_false }
      end

      context "user agent does not match, DNS verified" do
        before { helper.stub(request: OpenStruct.new(user_agent: "Google Chrome"), verify_googlebot_domain: true) }
        it { subject.should be_false }
      end

      context "user agent does not match, DNS not verified" do
        before { helper.stub(request: OpenStruct.new(user_agent: "Google Chrome"), verify_googlebot_domain: false) }
        it { subject.should be_false }
      end
    end
  end

  describe "#verify_googlebot_domain" do
    before { helper.stub(request: OpenStruct.new(remote_ip: "111.222.333.444")) }
    subject { helper.send(:verify_googlebot_domain) }

    context "hostname is googlebot and IP matches" do
      before do
        Resolv.stub(getname: "test.googlebot.com")
        Socket.stub(getaddrinfo: [[nil, nil, "111.222.333.444"]])
      end

      it { subject.should be_true }
    end

    context "IP matches" do
      before do
        Resolv.stub(getname: "test.test.dev")
        Socket.stub(getaddrinfo: [[nil, nil, "111.222.333.666"]])
      end

      it { subject.should be_false }
    end

    context "hostname is googlebot and IP does not match" do
      before do
        Resolv.stub(getname: "test.googlebot.com")
        Socket.stub(getaddrinfo: [[nil, nil, "111.222.333.666"]])
      end

      it { subject.should be_false }
    end

    context "hostname and IP does not match" do
      before do
        Resolv.stub(getname: "test.test.dev")
        Socket.stub(getaddrinfo: [[nil, nil, "111.222.333.666"]])
      end

      it { subject.should be_false }
    end

  end

end