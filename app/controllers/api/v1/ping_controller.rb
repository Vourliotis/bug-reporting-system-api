class Api::V1::PingController < ApplicationController
  def index
    render plain: 'pong'
  end
end
