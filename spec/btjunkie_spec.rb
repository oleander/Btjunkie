require "spec_helper"

describe Btjunkie do
  describe "#page" do
    it "should be possible pass a page" do
      Btjunkie.page(10).should be_instance_of(Btjunkie)
    end
  end
end