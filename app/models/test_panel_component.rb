class TestPanelComponent < ActiveRecord::Base

  set_table_name "TestPanelComponents"
  requires_uuids :testPanelComponentID

  belongs_to :panel, :class_name => "LabTest", :foreign_key => "testPanelID"
  belongs_to :lab_test, :foreign_key => "testID"

end