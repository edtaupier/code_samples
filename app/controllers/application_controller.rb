class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :validate_session, :except=>[:validate_session]
  before_filter :validate_lab_location, :except=>[:logout, :validate_lab_location, :validate_session]
  
   def handle404
    render :file => "public/404.html", :layout => false
  end
  
  def validate_session
    if session[:user]
      User.current = session[:user]
      LabLocation.current = session[:location]
      WorkStation.current = session[:workstation]
    else
      redirect_to_login
    end
  end
  
  def validate_lab_location
    if !LabLocation.current
      render :template=>"login/no_location"
    end
  end
  
  def redirect_to_login
    if request.xhr?
      render :update do |page|
        page.redirect_to "/login"
      end
    else
      redirect_to "/login"
    end
  end
  
  def search_case
     respond_to do |format|
      format.js {
        render :template=>"shared/search_case.js.rjs"
      }
    end
  end
  
  def case_not_found_error
    @message = "A case with the accession number you entered could not be located."
    respond_to do |format|
      format.js{
        render :template=>"shared/lightbox_error_message.js.rjs"
      }
    end
  end
  
end
