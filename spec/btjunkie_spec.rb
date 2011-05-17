require "spec_helper"

describe Btjunkie do
  before(:each) do
    @cookies = {
      :sessid => "6b9d6fac8b5c66756b4f532c175748c8"
    }
  end
  
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
      lambda { 
        Btjunkie.results
      }.should raise_error(ArgumentError, "You need to specify a category")
    end
    
    it "should raise an error if no cookies if being passed" do
      lambda { 
        Btjunkie.category(:movies).results 
      }.should raise_error(ArgumentError, "You need to specify a cookie using #cookies")
    end
  end
  
  describe "#results" do
    describe "movies category" do
      use_vcr_cassette "movies"
      before(:each) do
        @bt = Btjunkie.category(:movies).cookies(@cookies)
      end
      
      it "should return a list of 40 torrents" do
        @bt.should have_at_least(40).results
      end
      
      it "should contain the right data" do
        object = mock(Object.new)
        object.should_receive(:based_on).at_least(40).times
        
        @bt.results.each do |torrent|
          torrent.torrent.should match(URI.regexp)
          torrent.torrent.should match(/\.torrent$/)
          torrent.torrent.should match(/^http:\/\//)
          torrent.title.should_not be_empty
          torrent.details.should match(URI.regexp)
          torrent.should_not be_dead
          torrent.seeders.should be_instance_of(Fixnum)
          torrent.should be_instance_of(BtjunkieContainer::Torrent)
          torrent.domain.should eq("btjunkie.org")
          torrent.id.should match(/[a-z0-9]+/)
          torrent.tid.should match(/[a-fA-F\d]{32}/)
          torrent.torrent_id.should eq(torrent.id)
          torrent.should be_valid
          MovieSearcher.should_receive(:find_by_release_name).with(torrent.title, options: {
            :details => true
          }).and_return(Struct.new(:imdb_id).new("123"))
                    
          Undertexter.should_receive(:find).with("123", language: :english).and_return(object)
            
          torrent.subtitle(:english)
        end
      end
    end
  end
  
  describe "bugs" do
    describe "bug 1" do
      use_vcr_cassette "bug1"
      
      before(:each) do
        @bt = Btjunkie.category(:movies).cookies(@cookies)
        @bt.should_receive(:url).and_return("http://btjunkie.org/search?q=Limitless-2011-TS-XviD-IMAGiNE-torrentzilla-org")
      end
      
      it "should not raise an error calling the Btjunkie#tid method" do
        lambda { 
          @bt.results.first.tid
        }.should_not raise_error
      end
      
      it "should not be valid" do
        @bt.results.each do |torrent|
          torrent.should_not be_valid
        end
      end
    end
  end
end