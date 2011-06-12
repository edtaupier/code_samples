module CaseClientInformationFactory

  private

  def set_client_information
    @location = @case.location
    @physician = @case.physician
    @physician_location = @case.physician_location
    @account = @physician_location.account
    @address = @location.primary_address
  end

end