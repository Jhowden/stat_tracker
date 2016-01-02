require "spec_helper"

describe "The EASHL App" do
  
  describe "GET '/'" do
    it "grabs the index page" do
      get "/"
    
      expect( last_response ).to be_ok
    end
  end
  
  describe "GET '/add_stats'" do
    it "grabs the add_stats page" do
      get "/add_stats"
    
      expect( last_response ).to be_ok
    end
  end
  
  describe "POST '/add_game'" do
    let( :params ) do
      {
        "game" => 
          {
            "home_team" => "Home",
            "away_team" => "Away",
            "winner" => "Away",
            "date_played" => "12/13/2015"
          }, 
        "goal" => 
          [
            {"player" => "Player1",
              "ppp" => "N", 
              "period" => "2",
              "time_scored" => "10:10"
            }
          ],
        "submit"=>"Create game"
      }
    end
    
    before :each do
      stub_const "Actions::CreateGame", Class.new
      allow( Actions::CreateGame ).to receive( :new )
    end
    
    it "instantiates a new Actions::CreateGame" do
      post "/add_game", params
      
      expect( Actions::CreateGame ).to have_received( :new )
    end
    
    it "passes in the params to Actions::CreateGame" do
      post "/add_game", params
      
      expect( Actions::CreateGame ).to have_received( :new ).
        with( params )
    end
  end
end