require 'spec_helper'

describe Slide::QaSlide do

  include TestFactory
  
  before :all do
    @case = new_object(Case, 'caseID')
    @specimen_test = new_object(SpecimenTest, 'specimenTestID', {:partNumber=>'A'})
    @specimen = new_object(Specimen, 'specimenID', {:caseID=>@case.caseID})
    @specimen_test.specimen = @specimen
    @body_site = new_object(Bodysite, 'bodysiteID', {:description=>"Body Site"})
    @specimen.bodysite = @body_site
    @test = LabTest.new(:abbreviation=>"A")
  end
  
  context "Creating new slide" do
    
    before :all do
      @slide = Slide.new
      @slide.lab_test = @test
      @qa_slide = Slide::QaSlide.new(@specimen_test, @slide)
    end
    
    it "creates a new qa slide record" do
      @qa_slide.specimen.should_not == nil
    end
    
    it "sets the block label from the specimen test" do
      @qa_slide.label.should == "A"
    end
  
    it "sets the specimen number from the specimen" do
      @qa_slide.specimen_number.should == @specimen.specimenNumber
    end
    
    it "sets the body site from the specimen body site" do
      @qa_slide.body_site_description.should == @specimen.body_site_description
    end
  
    it "sets the stain from the test" do
      @qa_slide.stain.should == @slide.lab_test.abbreviation
    end
    
  end
  
  context "Retrieving a previously edited slide" do
  
    before :all do
      @slide = Slide.new
      @slide.lab_test = @test
      @slide.stain = "stain"
      @slide.label = "Z"
      @qa_slide = Slide::QaSlide.new(@specimen_test, @slide)
    end
    
    it "uses stain and label values from slide if they exist" do
      @qa_slide.stain.should == @slide.stain
      @qa_slide.label.should == @slide.label
    end
  
  end
  
  context "Retrieving list of slides for case" do

    before :all do
      @slide = Slide.new(:stain=>"stain")
      @printed_record = PrintedSlideRecord.new
      @printed_record.specimen_test = SpecimenTest.new
      @printed_record.specimen_test.specimen = @specimen
      Slide.stub(:case_specimen_slides).and_return([])
    end

    context "Slide is a negative control" do

      before :each do
        @slide = Slide.new(:lab_test=>LabTest.new(:abbreviation=>"A"), :negative_control_type=>NegativeControlType.new(:description=>"negative"),
                         :negativeControlTypeID=>1)
        @printed_record.stub(:slides).and_return([@slide])
        PrintedSlideRecord.stub(:with_assoc).and_return([@printed_record])
      end

      it "gets the negative control description for control slides" do
        @qa_slides = Slide::QaSlide.get_slides_for_case(@case)
        @qa_slides.find{|s| s.stain == "negative"}.should_not be_nil
      end

    end

    context "Slide is a recut" do

      before :each do
        @recutslide = Slide.new(:lab_test=>LabTest.new(:abbreviation=>"B"), :labelName=>"recut")
        @printed_record.stub(:slides).and_return([@recutslide])
        PrintedSlideRecord.stub(:with_assoc).and_return([@printed_record])
      end

      it "gets the label name from the slide if it exists" do
        @qa_slides = Slide::QaSlide.get_slides_for_case(@case)
        @qa_slides.find{|s| s.stain == "recut"}.should_not be_nil
      end

    end

  end
  
end