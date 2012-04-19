require 'uri'

module MenuMaker
	class MenuItem
		attr_reader :title, :depth, :rels, :id, :classes

		def initialize(depth, title, url, properties={})
			@depth, @title, @url = depth, title, url
			@classes = [*properties[:classes] || properties[:class] || []]
			@rels = [*properties[:rels] || properties[:rel] || []]
			@aliases = [*properties[:aliases] || properties[:alias] || []]
			@id = properties[:id] || create_id
			if external?
				@classes << 'external'
				@rels << 'external'
			end
		end

		def create_id
			# If there's a replacable section, use default value
			uri = URI.parse(@url.gsub(/{.*\|(.*)}/){ $1 })
			if external?
				"remote-#{uri.host}#{uri.path}".gsub(/\/$/, '').gsub(/[\/\.]/, '-')
			else
				uri.path.sub(/^\//, '').gsub(/\//, '-')
			end
		end

		def alias_match?(current_url)
			@aliases.include?(current_url)
		end

		def external?
			@url.include?('://')
		end

		def url(&block)
			# Replace replaceable if they want us to
			return @url.gsub(/{.*\|(.*)}/){ $1 } unless block_given?
			@url.gsub(/{(.*)\|(.*)}/) do
				replace = block.call($1)
				replace || $2
			end
		end
	end
end