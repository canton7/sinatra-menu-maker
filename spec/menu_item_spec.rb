require 'menu_maker/menu_item'
include MenuMaker

describe MenuItem do
  it "should correctly assign title and url" do
		item = MenuItem.new(1, 'some_title', 'some_url')
		item.title.should == 'some_title'
		item.url.should == 'some_url'
		item.classes.should == []
		item.rels.should == []
  end

	it "should correctly assign single class and rel" do
		item = MenuItem.new(1, 'title', 'url', {:class => 'hi', :rel => 'rel'})
		item.classes.should == ['hi']
		item.rels.should == ['rel']
	end

	it "should correctly assign multiple classes and rels" do
		item = MenuItem.new(1, 'title', 'url', {:classes => ['class1', 'class2'], :rels => ['rel1', 'rel2']})
		item.classes.should == ['class1', 'class2']
		item.rels.should == ['rel1', 'rel2']
	end

	it "should correctly add external rel and class for external urls" do
		item = MenuItem.new(1, 'title', 'http://some-url.com')
		item.classes.should == ['external']
		item.rels.should == ['external']
	end

	it "should correctly assign an ID if given" do
		item = MenuItem.new(1, 'title', 'url', :id => 'the_id')
		item.id.should == 'the_id'
	end

	it "should correctly auto-generate an ID for local urls" do
		item = MenuItem.new(1, 'title', 'page')
		item.id.should == 'page'
		item = MenuItem.new(1, 'title', 'folder/page')
		item.id.should == 'folder-page'
		item = MenuItem.new(1, 'title', 'folder/page-thing?query=hi')
		item.id.should == 'folder-page-thing'
	end

	it "should correctly auto-generate an ID for remote urls" do
		item = MenuItem.new(1, 'title', 'http://page.com/')
		item.id.should == 'remote-page-com'
		item = MenuItem.new(1, 'title', 'http://site.com/page/thing?query=string')
		item.id.should == 'remote-site-com-page-thing'
	end

	it "should correctly auto-generate an ID for alias urls" do
		item = MenuItem.new(1, 'title', 'page/{some_id|default}/testy')
		item.id.should == 'page-default-testy'
	end

	it "should replace relaceables" do
		item = MenuItem.new(1, 'title', 'page/{some_id|default}/testy')
		item.url.should == 'page/default/testy'
		item.url{ |s| s << '_yay' }.should == 'page/some_id_yay/testy'
	end

	it "should match aliases" do
		item = MenuItem.new(1, 'title', 'some_path', :alias => 'some_other/page')
		item.alias_match?('some_other/page').should == true
	end
end

