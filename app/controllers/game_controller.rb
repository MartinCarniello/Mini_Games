class GameController < ApplicationController
  def index
    game_name = params[:game_name]
    @game = Game.where(name: game_name).first
  end
end
