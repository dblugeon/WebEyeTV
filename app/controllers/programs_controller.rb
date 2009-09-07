class ProgramsController < ApplicationController
  
  def index
    @programs = eyetv_instance.programs
  end

  def show
    check_program
  end

  def edit
    check_program
    @input_sources = EyeTV::Program.input_sources_possible
    @repeats = EyeTV::Program.repeats_possible
    @quality = EyeTV::Program.qualities_possible
    @channels = eyetv_instance.channels
  end

  def update
    check_program
    start_time = Time.local(params[:date][:year], params[:date][:month], params[:date][:day], params[:date][:hour], params[:date][:minute])
    params[:start_time]=start_time
    update_program(@program, params)
    redirect_to programs_url
  end

  def destroy
    check_program
    uid = @program.uid
    @program.delete
    redirect_to programs_url
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

  def update_program(program, params)
    if(params)
      params.each do |key, value|
        if (program.respond_to?(key) and program.method(key).arity == 1)
          logger.debug "call #{key} with value : #{value}"
          program.send(key, value)
        elsif (program.respond_to?("#{key}=") and program.method("#{key}=").arity == 1)
          logger.debug "call #{key}= with value : #{value}"
          program.send("#{key}=", value)
        else
          logger.debug "Program class doesn't respond to #{key}"
        end
      end
    end
  end
end
