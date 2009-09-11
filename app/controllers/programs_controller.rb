class ProgramsController < ApplicationController
  
  def index
    @programs = eyetv_instance.programs
  end

  def show
    @program = check_eyetv_object(:program, params[:id])
    redirect_to_404(@program)
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
    @program = check_eyetv_object(:program, params[:id])
    redirect_to_404(@program)
    if(params[:enabled] == nil)
        params[:enabled] = false
    end
    start_time = Time.local(params[:date][:year], params[:date][:month], params[:date][:day], params[:date][:hour], params[:date][:minute])
    params[:start_time]=start_time
    update_eyetv_object(@program, params)
    redirect_to programs_url
  end

  def destroy
    @program = check_eyetv_object(:program, params[:id])
    redirect_to_404(@program)
    if @program
      uid = @program.uid
      @program.delete
      redirect_to programs_url
    end
  end
  
end
