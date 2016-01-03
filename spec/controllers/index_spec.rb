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
  
  describe "GET '/view_stats'" do
    let( :team ) { double( "team" ) }
    
    before :each do
      stub_const "Repository::GameRepository", Class.new
      allow( Repository::GameRepository ).to receive( :new ).
        and_return Repository::GameRepository
      allow( Repository::GameRepository ).to receive( :game_victor_data )
      
      stub_const "Team", Class.new
      allow( Team ).to receive( :where ).and_return [team]
    end
    
    it "grabs the view_stats page" do
      get "/view_stats/Home"
    
      expect( last_response ).to be_ok
    end
    
    it "finds the team" do
      get "/view_stats/Home"
      
      expect( Team ).to have_received( :where ).
        with( name: "Home" )
    end
    
    it "redirects if it does not find the team" do
      allow( Team ).to receive( :where ).and_return []
      
      get "/view_stats/Home"
      follow_redirect!
      
      expect( last_request.url ).to eq( "http://example.org/" )
    end
    
    it "sets a flash message when it cannot find the team" do
      allow( Team ).to receive( :where ).and_return []
      
      get "/view_stats/Home"
      follow_redirect!
      
      expect( last_response.body ).to match /No team/
    end
    
    it "instantiates a GameRepository" do
      get "/view_stats/Home"
      
      expect( Repository::GameRepository ).to have_received( :new ).
        with( team )
    end
    
    it "it grabs all of the games where the team is the winner" do
      get "/view_stats/Home"
      
      expect( Repository::GameRepository ).to have_received( :game_victor_data )
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