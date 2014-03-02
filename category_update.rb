games = Game.where(category: "Aventuras")

games.each do |game|
	game.category = "aventuras"
	game.save
end