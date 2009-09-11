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

  def is_recording?
    eyetv_instance.is_recording?
  end

  @eyetv_ref
  protected
  def eyetv_instance
    @eyetv_ref = EyeTV::EyeTV.new if @eyetv_ref == nil
    logger.debug "value of eyetv_ref = #{@eyetv_ref}"
    @eyetv_ref
  end

  def authenticate
    if APP_CONFIG['perform_authentication']
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG['username'] && password == APP_CONFIG['password']
      end
    end
  end

  def update_eyetv_object(eyetv_object, params)
    if(params == nil)
      raise "params is nil"
    end
    if(not eyetv_object.is_a?(EyeTV::Recording) and not eyetv_object.is_a?(EyeTV::Program) and not eyetv_object.is_a?(EyeTV::Channel))
      raise "#{eyetv_object} is not an rb-eyetv object"
    end
    if(params)
      params.each do |key, value|
        if (eyetv_object.respond_to?(key) and eyetv_object.method(key).arity == 1)
          logger.debug "call #{key} with value : #{value}"
          eyetv_object.send(key, value)
        elsif (eyetv_object.respond_to?("#{key}=") and eyetv_object.method("#{key}=").arity == 1)
          logger.debug "call #{key}= with value : #{value}"
          eyetv_object.send("#{key}=", value)
        else
          logger.debug "#{eyetv_object.class} class doesn't respond to #{key}"
        end
      end
    end
  end

  def check_eyetv_object(type, id)
    self.logger.debug "value of id = #{id}"
    eyetv_obj = eyetv_instance.find_by_id(type.to_sym, id.to_i)
    self.logger.debug "value of eyetv_obj = #{eyetv_obj}"
    eyetv_obj
  end

  def redirect_to_404(eyetv_obj)
    if eyetv_obj == nil
      render :file => "#{RAILS_ROOT}/public/404.html",
        :status => 404 and return
    end
  end
end
