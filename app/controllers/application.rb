# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
include EyeTV

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9a79600b1c112326d5099f8c00a7757e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  @instance
  def eyetv_instance
    @instance = EyeTV::EyeTV.new if @instance == nil
  end
end
