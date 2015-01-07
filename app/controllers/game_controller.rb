class GameController < ApplicationController
  def index
    @page_number = params[:pageNumber].to_i
    @game_category = params[:gameCategory]
    game_name = params[:game_name]
    @game = Game.where(name: game_name).first
  end
end
