class Slide::Datamatrix

  LARGE_POINT_SIZE = 28
  MEDIUM_POINT_SIZE = 21
  SMALL_POINT_SIZE = 18
  FONT = "Helvetica"
  HEIGHT = 300
  WIDTH = 300
  
  attr_reader :path, :url, :image_string, :image, :barcode, :text_image, :composite,
              :base64_string, :top_label_text, :accession_label_text, :date_label_text

  def initialize(data, top_label_text, accession_label_text, date_label_text)
    @path = Configurable.datamatrix_url(data)
    @url = URI.parse(@path)
    @top_label_text = top_label_text
    @accession_label_text = accession_label_text
    @date_label_text = date_label_text
    generate_image
  end

  def serialized
  @composite.to_blob
  end

  def sanitized_encoded_string
    strip_newlines
  end

  private

  def generate_image
    retrieve_image_string
    create_image
  end

  def retrieve_image_string
    http = Net::HTTP.new(@url.host, url.port)
    @image_string = http.get(url.path + "?" + url.query)
  end

  def create_image
    @text_image = Magick::Image.new(HEIGHT, WIDTH)
    create_annotation
    create_barcode_image
    create_composite_image
    generate_encoded_string
  end

  def create_annotation
    create_top_annotation
    create_bottom_annotation
  end

  def create_top_annotation
    gc = Magick::Draw.new
    gc.pointsize = LARGE_POINT_SIZE
    gc.font_family = FONT
    gc.stroke = 'none'
    gc.annotate(@text_image, 3, 3, 10, 3, @top_label_text)
  end

  def create_bottom_annotation
    accession_number_annotation
    date_annotation

  end

  def accession_number_annotation
    gc = Magick::Draw.new
    gc.pointsize = MEDIUM_POINT_SIZE
    gc.font_family = FONT
    gc.stroke = 'none'
    gc.gravity = Magick::SouthWestGravity
    gc.annotate(@text_image, 0, 0, 95, 60, @accession_label_text)
  end

  def date_annotation
    gc = Magick::Draw.new
    gc.pointsize = SMALL_POINT_SIZE
    gc.font_family = FONT
    gc.stroke = 'none'
    gc.gravity = Magick::SouthWestGravity
    gc.annotate(@text_image, 0, 0, 95, 20, @date_label_text)
  end

  def create_barcode_image
    @barcode = Magick::Image.from_blob(@image_string.body)[0].scale(80, 80)
  end

  def create_composite_image
    @composite = @text_image.composite(@barcode, Magick::SouthWestGravity, 8, 3, Magick::OverCompositeOp)
    @composite.format = "jpg"
  end

  def generate_encoded_string
    @base64_string = Base64.encode64(@composite.to_blob {self.quality = 100; self.density = 300;})
  end

  def strip_newlines
    @base64_string.gsub("\r", "return").gsub("\n", "newLine").gsub("\r\n", "returnNewLine").gsub("\u00a0", "UnicodeNewLine")
  end

end