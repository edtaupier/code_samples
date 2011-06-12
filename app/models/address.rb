class Address < ActiveRecord::Base

  set_table_name "Addresses"
  requires_uuids(:addressID)

  OFFICE =    "FF827966-A5C7-4680-A368-4D0A7C4246AA"
  PHYSICAL =  "FF69941C-9C94-40B2-B5C1-37BB8E9DEE97"
  HOME =      "8BF71993-90CD-4384-A5E6-5B006BF42575"
  MAILING =   "4B883DE6-4C3E-4371-9312-BBDE1C255CB8"
  BILLING =   "4F3090F3-84EF-422E-81EE-BCF53EC26667"

  scope :offices, where("addressTypeID = ?", OFFICE)
  scope :homes, where("addressTypeID = ?", HOME)
  scope :mailings, where("addressTypeID = ?", MAILING)
  scope :physicals, where("addressTypeID = ?", PHYSICAL)
  scope :billings, where("addressTypeID = ?", BILLING)

  belongs_to :location, :foreign_key => "addressOwnerID"
  belongs_to :clinical_contact, :foreign_key => "addressOwnerID"

  alias_attribute(:line_one, :lineOne)
  alias_attribute(:line_two, :lineTwo)
  alias_attribute(:zip_code, :zipCode)

  def single_line_address
    line = lineOne
    line += " #{lineTwo}" if lineTwo?
    line += " #{city}, #{state} #{zipCode}"
    line
  end

end