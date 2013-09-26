require "spec_helper"

describe FirstClickFree do
  describe "#permitted_domains" do
    subject { described_class.permitted_domains }
    it { should have_at_least(10).items }
    it { subject.select { |domain| domain =~ /google|bing|yahoo/ }.length.should eq subject.length }
  end

  describe "#test_mode" do
    it "should default to false" do
      described_class.test_mode = false
    end

    it "should be settable" do
      expect { described_class.test_mode = true }.to change(described_class, :test_mode).to(true)
    end
  end
end