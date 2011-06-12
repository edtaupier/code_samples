class QaDashboardPresenter < ActivePresenter::Base

  include CaseClientInformationFactory

  attr_reader :case, :physician, :location, :physician_location,
              :account, :patient, :case_histories, :specimens,
              :case_notes, :informational

  def initialize(case_id)
    set_case_information(case_id)
    set_client_information
    set_informational
  end

  private

  def set_case_information(case_id)
    @case = Case.qa_case(case_id)
    @specimens = @case.specimens.number_order
    @patient = @case.patient
    @case_histories = @case.case_histories
    @case_notes = @case.notes
  end

  def set_informational
    if @physician_location.wantsDigitalSlides?
      @informational = "Physician needs digital slide images"
    end
  end

end