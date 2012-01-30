require 'menu_maker'

module Sinatra
	module MenuMaker
		module Helpers
			def render_menu(menu_set=:default)
				::Sinatra::MenuMaker.menu_maker.set_url_parser{ |u| url(u) }
				::Sinatra::MenuMaker.menu_maker.to_html(request.path_info, {
					:menu_set => menu_set,
					:replace => session[:menu_replace],
				})
			end

			def menu_replace(key, value)
				session[:menu_replace][key] = value
			end
		end

		def menu_init(menu)
			@@menu_maker = ::MenuMaker::Menu.new(menu)
			#p Sinatra::Helpers.uri
			#p settings.uri
			#@@menu_maker.set_url_parser(lambda { |url| url(url) })
		end

		def self.menu_maker
			@@menu_maker
		end

		def self.registered(app)
			app.helpers Helpers
		end
	end
end