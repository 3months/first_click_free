require "spec_helper"

describe FirstClickFree::Exceptions::SubsequentAccessException do
  it { described_class.superclass.should eq Exception }
end