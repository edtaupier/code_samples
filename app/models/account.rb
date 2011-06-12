class Account < ActiveRecord::Base
  set_table_name "Accounts"
  requires_uuids(:accountID)

  has_many :locations, :foreign_key => "accountID"
  has_many :physician_locations, :foreign_key => "accountID"

  alias_attribute "account_name", :accountName

  def self.account_for_manifest(account_id)
    find(account_id).includes
  end

end