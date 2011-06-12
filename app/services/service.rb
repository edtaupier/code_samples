require 'soap/wsdlDriver'
class Service

  TIMEOUT = 120
  AUTH_TOKEN = "902347890234790789027890789007890-9000+"

  attr_reader :errors, :code

  private

  def timeout_request(request_name, &block)
    begin
      response = Timeout::timeout(TIMEOUT) {
        block.call
      }
      return response, nil
    rescue Timeout::Error
      return nil, "#{request_name} has timed out."
    end
  end

  def process_response(response, error_message, &block)
    if response.nil?
      @errors << error_message
      return nil
    end
    block.call(response)
  end

   def rpc_driver
    driver = SOAP::WSDLDriverFactory.new(url).create_rpc_driver
#    driver.wiredump_dev = STDERR
    driver
   end

  def evaluate_response_status(status, message, request)
    @status = status
    @message = message
    if status == '200'
      return true
    end
    @errors << "#{request} FAILED with status:#{status} and message:#{message}"
    nil
  end

end