class IndexController < ApplicationController
  def index
    @game_category = !params[:gameCategory] ? "all" : params[:gameCategory]
    @page_number = !params[:pageNumber] ? 1 : params[:pageNumber].to_i
    @query_string_parameters = "&gameCategory=#{@game_category}"
    @games = Game.games_page(@game_category, @page_number)
    @game_quantity = Game.game_quantity(@game_category)

    render_breadcrumb
  end

  def render_breadcrumb
    @page_quantity = @game_quantity / 36
    @page_quantity += 1 if @game_quantity % 36 > 0
    @page_quantity = 10 if @page_quantity > 10
    @render_left_arrow = @page_number != 1
    @render_right_arrow = @page_number != @page_quantity
  end
end
