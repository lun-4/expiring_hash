require "./spec_helper"

describe ExpiringHash do
  it "works" do
    hash = ExpiringHash(Int32, Int32).new(10, 5.minutes)
    hash[1] = 2
    hash[2] = 3

    hash[1].should eq 2
    hash[2].should eq 3
  end

  it "invalidates" do
    hash = ExpiringHash(Int32, Int32).new(10, 1.seconds)
    hash[1] = 2

    sleep 1.seconds

    hash[1]?.should eq nil
  end

  it "cleans when full" do
    hash = ExpiringHash(Int32, Int32).new(1, 1.seconds)
    hash[1] = 2
    hash[1].should eq 2

    sleep 1.seconds

    hash[2] = 3
    hash[1]?.should eq nil
    hash[2].should eq 3
  end

  it "doesnt clean when max size is nil" do
    hash = ExpiringHash(Int32, Int32).new(nil, 1.seconds)
    hash[1] = 2
    hash[1].should eq 2

    hash[2] = 3
    hash[2].should eq 3
  end
end
