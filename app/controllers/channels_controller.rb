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
    check_channel
  end

  def edit
    check_channel
  end

  def update
    check_channel
    logger.debug "value of params #{params} to merge"
    if (params[:enabled] == nil)
      @channel.enabled= false
    else params[:enabled]
      @channel.enabled= true
    end
    @channel.name = params[:name]
    redirect_to :action=>"index"
  end

  def destroy
  end

  private
  def check_channel
    self.logger.debug "value of params[:id] = #{params[:id]}"
    @channel = eyetv_instance.find_by_id(:channel, params[:id].to_i)
    self.logger.debug "value of @channel = #{@channel}"
    if @channel == nil
      render :file => "#{RAILS_ROOT}/public/404.html",
        :status => 404 and return
    end
  end
end
