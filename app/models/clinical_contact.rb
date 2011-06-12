class ClinicalContact < ActiveRecord::Base
  set_table_name "ClinicalContacts"
  requires_uuids(:clinicalContactID)
  
  has_many :cases, :foreign_key=>'clinicalContactID'
  has_many :phone_numbers, :foreign_key => 'ownerID'
  has_one :address, :foreign_key => "addressOwnerID"

  alias_attribute :ssn, :socialSecurityNumber
  alias_attribute :dob, :dateOfBirth

  delegate :line_one, :line_two, :city, :state, :zip_code, :to=>:address, :prefix=>true, :allow_nil=>true
  delegate :phone_number, :to=>:phone, :allow_nil=>true

  def name
    "#{firstName} #{lastName} (#{firstName[0]}#{lastName[0]})"
  end

  def barcode_patient_name
    lastName + ', ' + firstName[0,1].upcase
  end

  def reverse
    name = lastName + ', ' + firstName
    name += " #{middleName}." if middleName?
    name
  end

  def phone
    phone_numbers.home.first
  end

end

