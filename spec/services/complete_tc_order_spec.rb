require 'spec_helper'

describe "Completing a tc case" do

  include TestFactory

  before :each do
    @case = new_object(Case, :caseID)
    @tc_service = TcService.new(@case)
  end

end