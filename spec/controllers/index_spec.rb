require "spec_helper"

describe "The EASHL App" do
  
  describe "GET '/'" do
    it "grabs the index page" do
      get "/"
    
      expect( last_response ).to be_ok
    end
  end
end