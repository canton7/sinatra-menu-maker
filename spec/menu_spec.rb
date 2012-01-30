require 'menu_maker/menu'
include MenuMaker

describe MenuItem do
	it "should correctly parse urls" do
		menu = Menu.new(:default => [
				{:title => 'title', :url => 'url'}
		])
		menu.set_url_parser{ |url| "parsed_#{url}" }
		menu.to_html('current').should =~ /href="parsed_url"/
	end

	it "should correctly parse a complex menu" do
		menu = Menu.new(:default => [
				{:title => 'Hello!', :url => 'hi'},
				{:title => 'Hello sub', :url => 'hi/hey1', :depth => 1, :alias => 'hi/hey'},
				{:title => 'Hello sub2', :url => 'hi/hey2'},
				{:title => 'Hello2', :url => 'hi2', :depth => 0},
				{:title => 'Hello3', :url => 'hi3'},
				{:title => 'Hello sub', :url => 'hi/heyho', :depth => 1},
		])
		menu.to_html('hi/hey').should == File.open('spec/results/complex_menu.txt'){ |f| f.read }
	end
end