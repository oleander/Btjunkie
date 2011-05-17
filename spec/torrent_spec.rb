require "spec_helper"

describe BtjunkieContainer::Torrent do
  before(:each) do
    @torrent = {
      :torrent => "http://dl.btjunkie.org/torrent/Joanna-2010-DVDRiP-XviD-DvF/43588d77f182c5c280c596f3c68c90357bbdfad7ea84/download.torrent",
      :details => "/torrent/Joanna-2010-DVDRiP-XviD-DvF/43588d77f182c5c280c596f3c68c90357bbdfad7ea84",
      :title   => "Joanna 2010 DVDRiP XviD-DvF",
      :seeders => "123"
    }
  end
  
  describe "Torrent#valid?" do
    it "should have a valid torrent" do
      BtjunkieContainer::Torrent.new(@torrent).should be_valid
    end
    
    it "should not be valid due to empty id" do
      BtjunkieContainer::Torrent.new(@torrent.merge(:torrent => "http://google.com")).should_not be_valid
    end
    
    it "should not be valid due to bad seeder param" do
      BtjunkieContainer::Torrent.new(@torrent.merge(:seeders => "abc")).should_not be_valid
    end
    
    it "should not be valid due to empty title" do
      BtjunkieContainer::Torrent.new(@torrent.merge(:title => "")).should_not be_valid
      BtjunkieContainer::Torrent.new(@torrent.merge(:title => nil)).should_not be_valid
    end
    
    it "should not be valid due to invalid torrent url" do
      BtjunkieContainer::Torrent.new(@torrent.merge(:torrent => "http://dl.btjunkie.org/torrent/Joanna-2010-DVDRiP-XviD-DvF/43588d77f182c5c280c596f3c68c90357bbdfad7ea84/download")).should_not be_valid
    end
  end
end