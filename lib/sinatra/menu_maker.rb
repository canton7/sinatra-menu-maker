require 'menu_maker'

module Sinatra
	module MenuMaker
		module Helpers
			def render_menu(menu_set=:default)
				menu_set = @menu_maker_set || menu_set
				settings.menu_maker.set_url_parser{ |u| url(u) }
				settings.menu_maker.to_html(request.path_info, {
					:menu_set => menu_set,
					:replace => session[:menu_replace],
				})
			end

			def menu_replace(key, value)
				session[:menu_replace][key] = value
			end
			
			def menu_set(menu_set)
				@menu_maker_set = menu_set
			end
		end

		def menu_init(menu)
			settings.menu_maker = ::MenuMaker::Menu.new(menu)
		end

		def self.registered(app)
			app.helpers Helpers
			app.settings.set :menu_maker, nil
		end
	end
end
