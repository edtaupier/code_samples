class QaManifestPresenter < ActivePresenter::Base

  include CaseClientInformationFactory

  attr_reader :start_date, :end_date, :case, :location,
              :physician, :account, :physician_location,
              :address, :cases, :slide_shipping_info

  def initialize(start_date, end_date, case_id, location_id)
    @start_date = start_date
    @end_date = end_date
    @case = Case.find(case_id)
    set_client_information
    @slide_shipping_info = @location.slide_shipping_detail
    get_cases
  end

  private

  def get_cases
    @cases = Case.grossed_cases_for_location(@location.locationID, @start_date, @end_date)
  end


end