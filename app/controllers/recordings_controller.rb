class RecordingsController < ApplicationController
  def index
    @recordings = eyetv_instance.recordings
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
