class RecordingsController < ApplicationController
  def index
    order_by = params[:order_by] ||= :start_time
    order = params[:order] ||= :asc
    if(EyeTV::Recording.public_instance_methods.include?(order_by.to_s))
      @recordings = eyetv_instance.recordings.sort  do |recordA, recordB|
        if(order.to_sym == :asc)
          recordA.send(order_by) <=> recordB.send(order_by)
        else
          recordB.send(order_by) <=> recordA.send(order_by)
        end
      end
    else
      @recordings = eyetv_instance.recordings
    end
  end

  def show
    @recording = check_eyetv_object(:recording, params[:id])
    redirect_to_404(@recording)
  end
  
  def edit
    @recording = check_eyetv_object(:recording, params[:id])
    redirect_to_404(@recording)
  end

  def update
    @recording = check_eyetv_object(:recording, params[:id])
    redirect_to_404(@recording)
  end

  def destroy
    @recording = check_eyetv_object(:recording, params[:id])
    redirect_to_404(@recording)
    if @recording
      @recording.delete
      redirect_to recordings_url
    end
  end

end
