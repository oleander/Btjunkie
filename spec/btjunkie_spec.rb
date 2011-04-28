require "spec_helper"

describe Btjunkie do
  describe "#page" do
    it "should be possible pass a page" do
      Btjunkie.page(10).should be_instance_of(Btjunkie)
    end
  end
  
  describe "#cookies" do
    it "should be possible pass a page" do
      Btjunkie.cookies({
        random: "random"
      }).should be_instance_of(Btjunkie)
    end
  end
  
  describe "errors" do
    it "should raise an error if no category if being defined" do
      lambda { Btjunkie.torrents }.should raise_error(ArgumentError, "You need to specify a category")
    end
    
    it "should raise an error if no cookies if being passed" do
      lambda { Btjunkie.category(:movies).torrents }.should raise_error(ArgumentError, "You need to specify a cookie using #cookies")
    end
  end
  
  describe "#torrents" do
    describe "movies category" do
      before(:each) do
        stub_request(:get, "http://btjunkie.org/browse/Video?o=72&p=1&s=1&t=0").
          to_return(:body => File.read("spec/fixtures/movies.html"))
        @bt = Btjunkie.category(:movies).cookies({
          id: "random"
        })
      end
      
      it "should return a list of 49 torrents" do
        @bt.should have(49).torrents
      end
      
      it "should contain the right data" do
        @bt.torrents.each do |torrent|
          torrent.torrent.should match(/http:\/\/dl\.btjunkie\.org\/torrent\/.+?\/\w+\/download\.torrent/)
          torrent.title.should_not be_empty
          torrent.details.should match(URI.regexp)
          torrent.should_not be_dead
          torrent.seeders.should be_instance_of(Fixnum)
          torrent.should be_instance_of(BtjunkieContainer::Torrent)
          torrent.domain.should eq("btjunkie.org")
          torrent.id.should match(/[a-z0-9]+/)
          torrent.tid.should match(/[a-fA-F\d]{32}/)
          torrent.torrent_id.should eq(torrent.id)
          torrent.should be_open
        end
      end
    end
  end
  
  
end