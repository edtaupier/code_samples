class User < ActiveRecord::Base
  
  set_table_name "Users"
  requires_uuids(:userID)

  has_many :case_histories, :foreign_key => "eventUserID"
  
  def self.current
    return Thread.current[:user]
  end
  
  def self.current=(user)
    Thread.current[:user] = user
  end
  
  def to_s
    "#{firstName} #{lastName}"
  end

  def username
    "#{firstName[0].upcase}#{lastName}"
  end
  
end
