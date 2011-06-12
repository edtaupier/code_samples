class EmbeddingController < ApplicationController
  
  before_filter :verify_embedding_station, :except=>:set_embedding_station
  
  def verify_embedding_station
    @current_center = "Embedding"
    if !WorkStation.current
      select_embedding_station
    end
  end   
  
  def index
    render :update do |page|
      page.display_embedding
    end
  end
  
  def select_embedding_station
    @stations = WorkStation.get_embedding_work_stations
    render :update do |page|
      page.display_lightbox("shared/select_station", "Select A Workstation", {:width=>300, :height=>165})
    end
  end
  
  def set_embedding_station
    station = WorkStation.find_by_workStationId(params[:WorkStation][:id])
    WorkStation.current = session[:workstation] = station
    if !station
      render :nothing=>true
    else
      @current_center = "Embedding"
      render :update do |page|
        page.close_lightbox
        page.display_embedding
      end
    end
  end
  
  def search_block
    #TODO refactor this - encapsulate the scan processing into model
    @scan = CassetteScan.new(params[:search_block])    
    if @scan.valid
      @block = SpecimenBlock.initialize_from_scan(@scan, params[:currentBlock])
      if @block.valid
         if !params[:currentBlock].blank?
          @previous_block = SpecimenBlock.find_and_complete_embedding(params[:currentBlock])
         end
        @block.begin_embedding_activity
        display_block_information
      else
        display_block_error(@block.error_message)
      end
    else
      display_block_error("The format of the barcode you entered was not recognized.  Please contact tech support for assistance.")
    end
  end
  
  def cancel
    render :update do |page|
      page.display_lightbox("/embedding/cancel", "Confirm Cancel", {:height=>"185", :width=>"500"})
    end
  end
  
  def end_embedding_session
    @block = SpecimenBlock.find(params[:currentBlock])
    if !@block.embedding_activity.isComplete?
      confirm_complete_embedding
    else
      render :update do |page|
        page.redirect_to "/home"
      end
    end
  end
  
  def complete_embedding
    SpecimenBlock.find(params[:currentBlock]).complete_embedding
    render :update do |page|
      page.redirect_to "/home"
    end
  end
  
  def view_previous_block
    @scan = CassetteScan.new(params[:previousBlock])
    @block = SpecimenBlock.initialize_from_scan(@scan, params[:previousBlock])
    render :update do |page|
      page.display_lightbox("/embedding/block", "Previously Embedded Block", {:height=>"275"})
    end
  end
  
  private
  
  def confirm_complete_embedding
    render :update do |page|
      page.display_lightbox("/embedding/confirm", "Complete Embedding", {:width=>"500", :height=>"230"})
    end
  end
  
  def display_block_information  
    render :update do |page|
      page.clear_page_error
      page.display_block_information(@block, @previous_block)
    end
  end
  
  def display_block_error(message)
    render :update do |page|
      page.display_page_error(message)
    end
  end

end
