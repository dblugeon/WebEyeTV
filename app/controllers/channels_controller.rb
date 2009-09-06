class ChannelsController < ApplicationController

  def index
    redirect_to :action => "list"
  end

  def list
    @channels = eyetv_instance.channels
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
    self.logger.debug "value of params[:id] = #{params[:id]}"
    @channel = eyetv_instance.find_by_id(:channel, params[:id].to_i)
    self.logger.debug "value of @channel = #{@channel}"
  end

  def update
  end

  def destroy
  end

end
