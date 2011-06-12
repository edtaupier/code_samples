class Suffix < ActiveRecord::Base

  set_table_name "Suffixes"
  requires_uuids(:suffixID)

  has_many :physician_suffixes

end