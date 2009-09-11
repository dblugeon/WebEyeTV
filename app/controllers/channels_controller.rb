class ChannelsController < ApplicationController

  def index
    order_by = params[:order_by] ||= :channel_number
    order = params[:order] ||= :asc
    if(EyeTV::Channel.public_instance_methods.include?(order_by.to_s))
      @channels = eyetv_instance.channels.sort  do |chanA, chanB|
        if(order.to_sym == :asc)
          chanA.send(order_by) <=> chanB.send(order_by)
        else
          chanB.send(order_by) <=> chanA.send(order_by)
        end
      end
    else
      @channels = eyetv_instance.channels
    end
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
