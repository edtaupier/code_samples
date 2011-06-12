require 'spec_helper'

describe Slide do

  context "when creating a new slide" do

    before :each do
      the_case = double('case')
      the_case.stub(:slideSeed).and_return(1)
      the_case.stub(:update_attributes).and_return(true)
      the_case.stub(:update_attribute).and_return(true)
      Case.stub(:find).and_return(the_case)

      the_user = double('user')
      the_user.stub(:userID).and_return("1111")
      User.current=the_user

      @params = {:specimenId=>"1234", :stain=>"stain", :label=>"label"}
      @slide = Slide.new_from_qa(@params)
    end

    it "creates a new qa slide" do
      @slide.ownerID.should == @params[:specimenId]
      @slide.label.should == @params[:label]
      @slide.stain.should == @params[:stain]
    end

    it "initializes the slideID" do
      @slide.slideID.should_not be_nil
      @slide.slideID.length.should == 36
    end

    context "retrieving list of slides" do

      before :each do
        kase = double('case')
        account = double('account')

        Slide.stub(:slides_with_assoc).and_return([Slide.new, Slide.new, Slide.new])
        @slide_labels = Slide.slides_with_assoc([1,2,3])
      end

      it "generates a list of slide labels for slides" do
        @slide_labels.length.should == 3
      end

    end

  end

end
