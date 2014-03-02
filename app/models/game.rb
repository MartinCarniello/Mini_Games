class Game < ActiveRecord::Base
  def self.games_page(game_category, page_number)
    games_taken = if game_category == "all"
                    #Game.order("RANDOM()").take(36 * page_number)
                    Game.take(36 * page_number)
                  else
                    Game.where(:category => game_category).take(36 * page_number)
                  end

    first_in_range = ((page_number - 1) * 36)
    last_in_range = games_taken.size
    games_taken[first_in_range..last_in_range]
  end

  def self.game_quantity(game_category)
    game_category == "all" ? Game.all.size : Game.where(category: game_category).size
  end
end
