require "./spec_helper"

describe ExpiringHash do
  it "works" do
    hash = ExpiringHash(Int32, Int32).new(10, 5.minutes)
    hash[1] = 2
    hash[2] = 3

    hash[1].should eq 2
    hash[2].should eq 3
  end
end
