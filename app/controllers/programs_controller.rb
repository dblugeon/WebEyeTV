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
      @programs = eyetv_instance.channels
    end
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
