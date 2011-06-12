require 'spec_helper'


describe "Location addresses" do

  include TestFactory

  before :each do
    @location = new_object(Location, :locationID)
    Address.stub(:offices).and_return([Address.new(:addressOwnerID=>@location.locationID, :addressTypeID=>Address::OFFICE)])
    Address.stub(:physicals).and_return([Address.new(:addressOwnerID=>@location.locationID, :addressTypeID=>Address::PHYSICAL)])
    Address.stub(:billings).and_return([Address.new(:addressOwnerID=>@location.locationID, :addressTypeID=>Address::BILLING)])
    Address.stub(:mailings).and_return([Address.new(:addressOwnerID=>@location.locationID, :addressTypeID=>Address::MAILING)])
  end

  it "sets the primary address to office" do
    @location.primary_address.addressTypeID.should == Address::OFFICE
  end

  context "when office does not exist" do

    before :each do
       Address.stub(:offices).and_return([])
    end

    it "sets the primary address to physical" do
      @location.primary_address.addressTypeID.should == Address::PHYSICAL
    end

  end

  context "when office and physical do not exist" do

    before :each do
      Address.stub(:offices).and_return([])
      Address.stub(:physicals).and_return([])
    end

    it "sets the primary address to billing" do
      @location.primary_address.addressTypeID.should == Address::BILLING
    end

  end

end