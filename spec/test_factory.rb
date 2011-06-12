module TestFactory
  
  def get_new_uuid
    UUIDTools::UUID.timestamp_create(Time.now).to_s.upcase
  end
  
  def new_object(klass, primary_key, opts={})
    object = klass.new
    object[primary_key] = get_new_uuid
    update_object_attributes(object, opts)
  end
  
  def update_object_attributes(object, opts)
    opts.each do |k, v|
      object[k] = v
    end
    object
  end

  def stub_case_client_information
    build_client_objects
    stub_methods
  end

  def build_client_objects
    @_physician_location = new_object(PhysicianLocation, :physicianLocationID)
    @_location = new_object(Location, :locationID)
    @_account = new_object(Account, :accountID)
    @_physician = new_object(Physician, :physicianID)
    @_address = new_object(Address, :addressID)
  end

  def stub_methods
    @_physician_location.stub(:location).and_return(@_location)
    @_physician_location.stub(:physician).and_return(@_physician)
    @_physician_location.stub(:account).and_return(@_account)
    @case.stub(:physician_location).and_return(@_physician_location)
    @_location.stub(:primary_address).and_return(@_address)
  end
  
end
