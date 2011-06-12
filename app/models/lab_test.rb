class LabTest < ActiveRecord::Base
  
  set_table_name "Tests"
  requires_uuids :testID
  
  has_many :specimen_tests, :foreign_key=>"testID"
  has_many :slides, :foreign_key=>"testID"
  has_many :test_panel_components, :foreign_key => "testPanelID"
  has_many :lab_tests, :through => :test_panel_components
  
  scope :for_case, lambda{|kase| {
      :joins=>{:specimen_tests=>{:specimen=>:case}}, 
      :conditions=>["Cases.caseId=? and Tests.abbreviation IS NOT NULL", kase.caseID]  
    }
  }

  alias_attribute :cpt_code, :cptCode

  def to_s
    self.description
  end
  
  def self.tests_for_case(kase)
    for_case(kase).collect{|t| t.abbreviation}.uniq.sort{|a,b| a.downcase<=>b.downcase}
  end
  
end
