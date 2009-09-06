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
  end

  def update
  end

  def destroy
  end

end
