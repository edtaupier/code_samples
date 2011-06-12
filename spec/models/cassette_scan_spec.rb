require 'spec_helper'

describe "Block barcode separation" do
  before :all do
    @valid_barcodes = ["P 09NY1-TP12345671","P 09NY1-TP12345671 ","P 09NY1-TP1234567 A",
                       "P 09NY1-TP12345671 A","P 09NY1-TP123456710 A","P 09NY1-TP12345671 A2a",
                       "P 10NY1-TP1234567", "P 10NY1-TP1234567 ","TC10NY1-TP1234567",
                       "TC10NY1-TP1234567 ", "TC10NY1-AB1234567AA", "TC10NY1-AB123456710AA", 
                       "TC10NY1-AB123456710 A", "P 09NY1-AB1234567A"]
    @invalid_barcodes = ["P09NY1-TP1234567", "TC 10NY1-TP1234567", "P 09NY1-TP1234567 1 1", "P 09NY1-12345671 A",
                         "P 09NY1-AB123456 A", "P 09NY1-AB1234567A A"]
  end

  it "initializes a new valid CassetteScan Object when given a valid barcode" do
    for bc in @valid_barcodes
      cs = CassetteScan.new(bc)
      cs.valid.should == true
    end
  end

  it "sets initial values to nil if given an invalid barcode" do
    for bc in @invalid_barcodes
      cs = CassetteScan.new(bc)
      cs.valid.should == false
      cs.accession_number.should == nil
      cs.case_number.should == nil
      cs.case_prefix.should == nil
      cs.location.should == nil
      cs.patient_initials.should == nil
      cs.piece_number.should == nil
      cs.specimen_number.should == nil
    end
  end

  it "parses the barcode 'P 09NY1-TP12345671' correctly" do
    cs = CassetteScan.new('P 09NY1-TP12345671')
    cs.valid.should == true
    cs.accession_number.should == "P09NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P09"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == "1"
    cs.piece_number.should == nil
  end

  it "parses the barcode 'P 09NY1-TP1234567 A' correctly" do
    cs = CassetteScan.new('P 09NY1-TP1234567 A')
    cs.valid.should == true
    cs.accession_number.should == "P09NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P09"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == nil
    cs.piece_number.should == "A"
  end

  it "parses the barcode 'P 09NY1-TP12345671 A' correctly" do
    cs = CassetteScan.new('P 09NY1-TP12345671 A')
    cs.valid.should == true
    cs.accession_number.should == "P09NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P09"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == "1"
    cs.piece_number.should == "A"
  end

  it "parses the barcode 'P 09NY1-TP12345671 A2a' correctly" do
    cs = CassetteScan.new('P 09NY1-TP12345671 A2a')
    cs.valid.should == true
    cs.accession_number.should == "P09NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P09"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == "1"
    cs.piece_number.should == "A2a"
  end

  it "parses the barcode 'P 10NY1-TP1234567' correctly" do
    cs = CassetteScan.new('P 10NY1-TP1234567')
    cs.valid.should == true
    cs.accession_number.should == "P10NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P10"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == nil
    cs.piece_number.should == nil
  end

  it "parses the barcode 'P 09NY1-TP123456710 A' correctly" do
    cs = CassetteScan.new('P 09NY1-TP123456710 A')
    cs.valid.should == true
    cs.accession_number.should == "P09NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P09"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == "10"
    cs.piece_number.should == "A"
  end

  it "parses the barcode 'TC10NY1-TP1234567' correctly" do
    cs = CassetteScan.new('TC10NY1-TP1234567')
    cs.valid.should == true
    cs.accession_number.should == "TC10NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "TC10"
    cs.location.should == "NY1"
    cs.patient_initials.should == "TP"
    cs.specimen_number.should == nil
    cs.piece_number.should == nil
  end

  it "parses the barcode 'TC10NY1-AB123456710AA' correctly" do
    cs = CassetteScan.new('TC10NY1-AB123456710AA')
    cs.valid.should == true
    cs.accession_number.should == "TC10NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "TC10"
    cs.location.should == "NY1"
    cs.patient_initials.should == "AB"
    cs.specimen_number.should == "10"
    cs.piece_number.should == "AA"
  end

  it "parses the barcode 'TC10NY1-AB1234567AA' correctly" do
    cs = CassetteScan.new('TC10NY1-AB1234567AA')
    cs.valid.should == true
    cs.accession_number.should == "TC10NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "TC10"
    cs.location.should == "NY1"
    cs.patient_initials.should == "AB"
    cs.specimen_number.should == nil
    cs.piece_number.should == "AA"
  end

  it "parses the barcode 'P 09NY1-AB1234567A' correctly" do
    cs = CassetteScan.new('P 09NY1-AB1234567A')
    cs.valid.should == true
    cs.accession_number.should == "P09NY1-1234567"
    cs.case_number.should == "1234567"
    cs.case_prefix.should == "P09"
    cs.location.should == "NY1"
    cs.patient_initials.should == "AB"
    cs.specimen_number.should == nil
    cs.piece_number.should == "A"
    cs.block_of_origin.should == "A"
  end
end
