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
      lambda { Btjunkie.movies.torrents }.should raise_error(ArgumentError, "You need to specify a cookie using #cookies")
    end
  end
end