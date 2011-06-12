class QaController < ApplicationController
  
  before_filter :verify_qa_workstation, :except=>:verify_qa_workstation
  
  def verify_qa_workstation
    @current_center = "QA"
  end
  
  def index
    if !@case and request.xhr?
      search_case
      return
    end
    @presenter = QaDashboardPresenter.new(params[:id])
    @case = @presenter.case
  end
  
   def get_case
    @case = Case.find_by_accessionNumber(params[:caseNumber])
    if @case
      render :update do |page|
        page.redirect_to "/qa/?id=#{@case.id}"
      end
    else
      case_not_found_error
    end
  end
  
  
end
