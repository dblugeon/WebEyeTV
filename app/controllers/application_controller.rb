# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require('eyetv')
include EyeTV

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :authenticate

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9a79600b1c112326d5099f8c00a7757e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  @eyetv_ref
  protected
  def eyetv_instance
    @eyetv_ref = EyeTV::EyeTV.new if @eyetv_ref == nil
  end

  def authenticate
    if APP_CONFIG['perform_authentication']
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG['username'] && password == APP_CONFIG['password']
      end
    end
  end
end
