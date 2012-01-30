$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'lib/menu_maker/version'

Gem::Specification.new do |s|
  s.name = 'menu_maker'
  s.version = MenuMaker::VERSION
  s.summary = 'MenuMaker: Powerful (and personal) menu generation for Sinatra'
  s.description = 'Helps generate HTML menus with some funky features'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Antony Male']
  s.email = 'antony dot mail at gmail'
  s.required_ruby_version = '>= 1.9.2'

  s.files = Dir['lib/**/*']
end
