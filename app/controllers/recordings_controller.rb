class RecordingsController < ApplicationController
  def index
    @recordings = eyetv_instance.recordings
  end

  def show
    check_recording
  end
  
  def edit
    check_recording    
  end

  def update
    check_recording
  end

  def destroy
    check_recording
    @recording.delete
    redirect_to recordings_url
  end
  
  private
  def check_recording
    self.logger.debug "value of params[:id] = #{params[:id]}"
    @recording = eyetv_instance.find_by_id(:recording, params[:id].to_i)
    self.logger.debug "value of @channel = #{@recording}"
    if @recording == nil
      render :file => "#{RAILS_ROOT}/public/404.html",
        :status => 404 and return
    end
  end

end
