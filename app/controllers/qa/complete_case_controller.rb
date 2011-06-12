class Qa::CompleteCaseController < ApplicationController

  def mark_as_complete
    if params[:confirmed]
      @complete_case_service = CompleteCase.new(params[:case_id])
      if @complete_case_service.complete_case
        display_case_completed
        return
      end
      display_complete_error(@complete_case_service.errors.join("\n"))
    else
      confirm_complete_case
    end
  end

  private

  def confirm_complete_case
    render "confirm_complete_case"
  end

  def display_case_completed
    render :update do |page|
      page.close_lightbox
      page.alert("The case has successfully been completed")
      page << "$(\"#caseStatusDescription\").html(\"<span style='font-size:1.2em;font-weight:bold;color:green'>Complete</span>\")"
    end
  end

  def display_complete_error(message)
    render :update do |page|
      page.close_lightbox
      page.display_page_error(message)
    end
  end

end
