class ChannelsController < ApplicationController

  def index
    @channels = eyetv_instance.channels
  end

  def edit
    @channel = check_eyetv_object(:channel, params[:id])
    redirect_to_404(@channel)
  end

  def update
    @channel = check_eyetv_object(:channel, params[:id])
    if(params[:enabled] == nil)
      params[:enabled] = false
    end
    update_eyetv_object(@channel, params)
    redirect_to :action=>"index"
  end

end
