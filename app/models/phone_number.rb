class PhoneNumber < ActiveRecord::Base

  set_table_name "PhoneNumbers"
  requires_uuids(:phoneNumberID)

  scope :home, where("phoneNumberTypeID = ?", PhoneNumberType::HOME)

  belongs_to :clinical_contact, :foreign_key => "ownerID"

  alias_attribute :phone_number, :phoneNumber

  def self.has_id
    where("phoneNumberTypeID is not ?", nil)
  end

end