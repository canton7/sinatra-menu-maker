module MenuMaker
	class Menu
		@menu
		@url_parser

		def initialize(structure)
			@menu = parse(structure)
		end

		def add_menu(key, menu)
			@menu[key] = parse(menu)
		end

		def parse(structure)
			menu = {}

			depth = 0
			structure.each do |menu_set, menu_items|
				menu[menu_set] = []
				menu_items.each do |menu_item|
					depth = menu_item.delete(:depth) if menu_item.has_key?(:depth)
					menu[menu_set] << MenuItem.new(depth, menu_item.delete(:title), menu_item.delete(:url), menu_item)
				end
			end
			menu
		end

		def set_url_parser(&block)
			@url_parser = block
		end

		def to_html(current_url, options={})
			options = {
				:replace => {},
				:menu_set => :default,
			}.merge(options)
			r = ''
			prev_depth = 0
			@menu[options[:menu_set]].each do |item|
				depth_change = item.depth - prev_depth
				item_url = item.url{ |key| options[:replace][key] }
				classes = item.classes.dup
				classes << 'first' if r.empty?
				if depth_change == 1
					r << '<ul>'
					classes << 'first'
				elsif depth_change < 0
					r << (-depth_change).times.map{ '</li></ul></li>' }.join
				elsif depth_change == 0 && !r.empty?
					r << '</li>'
				elsif depth_change > 1
					raise "Can't go up more than one depth at a time! Item #{item.title}"
				end
				prev_depth = item.depth
				r << %Q{<li id="menu_item_#{item.id}"}
				classes << 'current' if item_url == current_url || item.alias_match?(current_url)
				r << %Q{ class="#{classes.join(' ')}"} unless classes.empty?
				url = @url_parser ? @url_parser.call(item.url) : item.url
				r << %Q{><a href="#{url}"}
				r << %Q{ rel="#{item.rels.join(' ')}"} unless item.rels.empty?
				r << "><span>#{item.title}</span></a>"
			end
			r << (prev_depth+1).times.map{ '</li></ul>' }.join
			r = '<ul>' << r
			r
		end
	end
end