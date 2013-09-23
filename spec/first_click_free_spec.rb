require "spec_helper"

describe FirstClickFree do
  describe "#permitted_domains" do
    subject { described_class.permitted_domains }
    it { should have_at_least(10).items }
    it { subject.select { |domain| domain =~ /google/ }.length.should eq subject.length }
  end
end