class SlideLabel

  attr_reader :patient_name, :slide_identifier, :block_label,
              :stain, :accession_number, :specimen_number,
              :specimen_count, :datamatrix, :printed_on

  def initialize(slide, kase, specimen_count)
    @slide_identifier = kase.slide_identifier
    @patient_name = kase.barcode_patient_name
    @block_label = slide.label
    @stain = slide.stain
    @printed_on = slide.printed_on.strftime("%m/%d/%y")
    @accession_number = kase.accessionNumber
    @specimen_number = get_specimen_number(slide)
    @specimen_count = specimen_count
    @datamatrix = Slide::Datamatrix.new(kase.accessionNumber, top_label_text, accession_label_text, date_label_text)
  end

  def serialize
    @datamatrix.serialized
  end

  def encoded_string
    @datamatrix.sanitized_encoded_string
  end

  private

  def get_specimen_number(slide)
    if slide.specimen_number then return slide.specimen_number end
    slide.printed_slide_specimen_number
  end

  def top_label_text
    label_string = "\n\n\n#{@slide_identifier}\n"
    label_string += "#{@patient_name}\n"
    label_string += "#{@block_label}\n"
    label_string += "#{@stain}\n"
    label_string
  end

  def accession_label_text
    "#{@accession_number}"
  end

  def date_label_text
    "Spec. #{@specimen_number} of #{@specimen_count}  #{@printed_on}"
  end

  def self.get_for_collection(collection, kase)
    count = Specimen.cases_count(kase)
    list = []
    collection.each do |slide|
      list << new(slide, kase, count)
    end
    list.sort{|a,b| a.specimen_number <=> b.specimen_number }
  end

end