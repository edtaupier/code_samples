class SlidesController < ApplicationController
  
  def index
    @case = Case.find(params[:case_id])
    @slides = Slide::QaSlide.get_slides_for_case(@case)
  end

  def new_qa_slide
    @slide = Slide.new_from_qa(params)
    respond_to do |format|
      format.js{
        render :template=> "slides/new_slide_row"
      }
    end
  end

  def save_and_close
    Slide.update_qa_slides(params[:slides], params[:caseId])
    respond_to do |format|
      format.js {
        render :update do |page|
          page.close_lightbox
        end
      }
    end
  end

  def print
    @kase = Case.find(params[:caseId])
    @slide_labels = Slide.update_slides_for_print(params[:slides], @kase)
    respond_to do |format|
      format.js {render "slides/print_slides.js.rjs"}
    end
  end

  def view_test_barcode
    send_data SlideLabel.new(Slide.first, Case.first(:conditions=>["hospitalLabID is not null"]), 3).serialize, :disposition=>"inline", :type=>"image/png"
  end

end
