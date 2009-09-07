class ProgramsController < ApplicationController
  
  def index
    @programs = eyetv_instance.programs
  end

  def show
    check_program
  end

  def edit
    check_program
  end
  
  private
  def check_program
    self.logger.debug "value of params[:id] = #{params[:id]}"
    @program = eyetv_instance.find_by_id(:program, params[:id].to_i)
    self.logger.debug "value of @channel = #{@program}"
    if @program == nil
      render :file => "#{RAILS_ROOT}/public/404.html",
        :status => 404 and return
    end
  end
end
