class ProgramsController < ApplicationController
  
  def index
    order_by = params[:order_by] ||= :start_time
    order = params[:order] ||= :asc
    if(EyeTV::Program.public_instance_methods.include?(order_by.to_s))
      @programs = eyetv_instance.programs.sort  do |progA, progB|
        if(order.to_sym == :asc)
          progA.send(order_by) <=> progB.send(order_by)
        else
          progB.send(order_by) <=> progA.send(order_by)
        end
      end
    else
      @programs = eyetv_instance.programs
    end
    @map_chans = Hash.new
    eyetv_instance.channels.each {|chan| @map_chans[chan.channel_number] = chan.name}
  end

  def show
    @program = check_eyetv_object(:program, params[:id])
    redirect_to_404(@program)
  end

  def new
    @input_sources = EyeTV::Program.input_sources_possible
    @repeats = EyeTV::Program.repeats_possible
    @quality = EyeTV::Program.qualities_possible
    @channels = eyetv_instance.channels
    @current_channel = eyetv_instance.current_channel_number
  end

  def create
    if request.post?
      new_program_options = {}
      key_possibles = ["duration", "title", "repeats", "date", "enabled", "channel_number", "description", "input_source", "quality"]
      params.each do |key, value|
        if key_possibles.include?(key)
          if key != "date"
            new_program_options[key.to_sym] = value
          else
            new_program_options[:start_time] = Time.local(params[:date][:year], params[:date][:month],
                params[:date][:day], params[:date][:hour], params[:date][:minute])
          end
        end
      end
      if !params.has_key?("enabled")
        new_program_options["enabled"] = false
      end
      logger.debug "new_program_options #{new_program_options.inspect}"
      begin
        logger.info "attempt create program"
        @program = eyetv_instance.make_program(new_program_options)
      rescue EyeTV::ConflictProgramException => e
        logger.info "program creation in conflict with #{e.program_exist.title} at #{e.program_exist.start_time}"
        flash[:error] = t(:program_in_conflict, :title => e.program_exist.title, :start_time => e.program_exist.start_time, :duration =>e.program_exist.duration)
        redirect_to new_program_url
      else
        logger.info "program creation successfull"
        flash[:notice] = t(:program_crated, :title => @program.title)
        redirect_to programs_path
      end
    end
  end

  def edit
    @program = check_eyetv_object(:program, params[:id])
    redirect_to_404(@program)
    @input_sources = EyeTV::Program.input_sources_possible
    @repeats = EyeTV::Program.repeats_possible
    @quality = EyeTV::Program.qualities_possible
    @channels = eyetv_instance.channels
  end

  def update
    if request.put? or request.post?
      @program = check_eyetv_object(:program, params[:id])
      redirect_to_404(@program)
      if @program
        if(params[:enabled] == nil)
            params[:enabled] = false
        end
        start_time = Time.local(params[:date][:year], params[:date][:month], params[:date][:day], params[:date][:hour], params[:date][:minute])
        params[:start_time]=start_time
        update_eyetv_object(@program, params)
      end
    else
      redirect_to programs_url
    end
  end

  def destroy
    if request.delete? or request.post?
      @program = check_eyetv_object(:program, params[:id])
      redirect_to_404(@program)
      if @program
        uid = @program.uid
        @program.delete
        redirect_to programs_url
      end  
    end
  end
end
