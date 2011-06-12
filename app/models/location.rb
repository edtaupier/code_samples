class Location < ActiveRecord::Base

  set_table_name "Locations"
  requires_uuids :locationID

  attr_reader :queries

  belongs_to :account, :foreign_key => "accountID"

  has_many :physician_locations, :foreign_key => "locationID"
  has_many :addresses, :foreign_key => "addressOwnerID"
  has_one :slide_shipping_detail, :foreign_key => "ownerId"

  delegate :line_one, :line_two, :city, :state, :zip_code,  :to=>:primary_address

  def primary_address
    return @current_address if @current_address
    return @current_address = office if office
    return @current_address = physical if physical
    return @current_address = billing if billing
    return @current_address = mailing if mailing
    @current_address
  end

  def office
    addresses.offices.first
  end
  def physical
    addresses.physicals.first
  end
  def mailing
    addresses.mailings.first
  end
  def billing
    addresses.billings.first
  end

end