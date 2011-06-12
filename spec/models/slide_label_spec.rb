require 'spec_helper'

describe SlideLabel do

  context "create label from data" do

    before :each do
      @case = double('case')
      @case.stub(:barcode_patient_name).and_return("Taupier")
      @case.stub(:slide_identifier).and_return("zzzzz")
      @case.stub(:accessionNumber).and_return("acc1234")

      Specimen.stub(:cases_count).and_return(3)

      @slide = double('slide')
      @slide.stub(:label).and_return('A')
      @slide.stub(:stain).and_return('stain')
      @slide.stub(:printed_on).and_return(DateTime.now)
    end

    context "slide belongs to a specimen" do

      before :each do
        @slide.stub(:specimen_number).and_return(1)
        @slide_label = SlideLabel.new(@slide, @case, 3)
      end

      it "sets the case identifier from the case" do
        @slide_label.slide_identifier.should == "zzzzz"
      end

      it "sets the patient name from the case" do
        @slide_label.patient_name.should == "Taupier"
      end

      it "sets the block id from the slide" do
        @slide_label.block_label.should == "A"
      end

      it "sets the stain from the slide" do
        @slide_label.stain.should == "stain"
      end

      it "sets the accession number from the case" do
        @slide_label.accession_number.should == "acc1234"
      end

      it "gets the specimen number from the specimen if the slide belongs to a specimen" do
        @slide_label.specimen_number.should == 1
      end

    end

    context "slide belongs to a printed slide record" do
      before :each do
        @slide.stub(:specimen_number).and_return(nil)
        @slide.stub(:printed_slide_specimen_number).and_return(1)
        @slide_label = SlideLabel.new(@slide, @case, 3)
      end

      it "gets the specimen number from the printed slide if it does not belong to a specimen" do
        @slide_label.specimen_number.should == 1
      end

      it "gets the number of specimens for the case" do
        @slide_label.specimen_count.should ==3
      end

    end
    
  end

end