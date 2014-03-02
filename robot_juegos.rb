# require 'nokogiri'
require 'open-uri'
# require 'debugger'
# require 'watir-webdriver'


def get_html(url)

	Nokogiri::HTML(open(url))

end


def get_all_games(html)

	html.css('div#orden_juegos div.juegos')

end


def get_game_name(game)

	name = game.children[3].attributes["title"].value.downcase.gsub(" ", "_")

	name.valid_encoding? ? name : name.force_encoding('iso-8859-1').encode('utf-8')
	

end


def get_game_description(game)

	desc = game.children[1].content

	desc.valid_encoding? ? desc : desc.force_encoding('iso-8859-1').encode('utf-8')

end


def get_game_category(game)

	"disparos"

end


def get_game_rating(game)

	[0, 0, 0, 0, 0]

end


def get_game_comments(game)

	[]

end


def download_game_img(game, game_name)

	img = game.children[3].children[0].attributes["src"].value

	begin
		`wget #{img} -O /home/martin/mini_games_app/mini_games_app/app/assets/games/#{game_name}.jpg`
	rescue
		`wget #{img} -O /home/martin/mini_games_app/mini_games_app/app/assets/games/#{game_name}.jpg`
	end

end


def download_game_swf(game, game_name)

	game_src = $browser.div(id: 'juego_marco').embed.src

	begin
		`wget #{game_src} -O /home/martin/mini_games_app/mini_games_app/app/assets/games/#{game_name}.swf`
	rescue
		retry
	end

end


def create_game_in_bd(name, description, category, rating, comments)

	Game.create name: name, description: description, category: category, rating: rating, comments: comments

end


#INSTANTIATE BROWSER
$browser = Watir::Browser.new

#GET HTML WITH NOKOGIRI
url = 'http://www.juegosdiarios.com/juegos-de-disparos.html'
home = get_html(url)


get_all_games(home).collect do |game|

	#GET ALL THE GAME DATA
	game_name = get_game_name(game)
	game_description = get_game_description(game)
	game_category = get_game_category(game)
	game_rating = get_game_rating(game)
	game_comments = get_game_comments(game)

	if Game.where(name: game_name).empty?
		#GO TO GAME'S PAGE
		begin
			$browser.goto(game.children[3].attributes["href"].value)
		rescue
			retry
		end

		sleep(5)

		if $browser.div(id: 'juego_marco').present?
			#DOWNLOAD GAME'S SWF
			download_game_swf(game, game_name)

			#DOWNLOAD GAME'S IMAGE
			download_game_img(game, game_name)

			#CREATE THE GAME IN THE DATABASE
			create_game_in_bd(game_name, game_description, game_category, game_rating, game_comments)
		else
			puts "No existe el div con id juego_marco para descargar"
		end
	else
		puts "El juego #{game_name} ya se encuentra en la base de datos"
	end

end
