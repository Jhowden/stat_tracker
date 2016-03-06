require "spec_helper"

describe "The EASHL App" do
  before :each do
    stub_const "Team", Class.new
  end
  
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
  
  describe "GET '/view_team_stats'" do
    let( :team ) { double( "team" ) }
    
    before :each do
      stub_const "Repository::GameRepository", Class.new
      allow( Repository::GameRepository ).to receive( :new ).
        and_return Repository::GameRepository
      allow( Repository::GameRepository ).to receive( :game_victor_data )
      
      allow( Team ).to receive( :where ).and_return [team]
    end
    
    it "returns a successful response" do
      get "/view_team_stats/Home"
    
      expect( last_response ).to be_ok
    end
    
    it "finds the team" do
      get "/view_team_stats/Home"
      
      expect( Team ).to have_received( :where ).
        with( name: "Home" )
    end
    
    it "redirects if it does not find the team" do
      allow( Team ).to receive( :where ).and_return []
      
      get "/view_team_stats/Home"
      follow_redirect!
      
      expect( last_request.url ).to eq "http://example.org/"
    end
    
    it "sets a flash message when it cannot find the team" do
      allow( Team ).to receive( :where ).and_return []
      
      get "/view_team_stats/Home"
      follow_redirect!
      
      expect( last_response.body ).to match /No team/
    end
  end
  
  describe "GET '/view_score_relationships'" do
    let( :team ) { double( "team" ) }
    let( :player1 ) { double( "player1", player_name: "p1", id: 1 ) }
    let( :player2 ) { double( "player2", player_name: "p2", id: 2 ) }
    
    before :each do
      allow( Team ).to receive( :where ).and_return [team]
      allow( team ).to receive( :players ).and_return [player1, player2]
    end
    
    it "returns a successful response" do
      get "/view_score_relationships/Home"
      
      expect( last_response ).to be_ok
    end
    
    it "finds the team" do
      get "/view_score_relationships/Home"
      
      expect( Team ).to have_received( :where ).
        with( name: "Home" )
    end
    
    it "finds all the players for a team" do
      get "/view_score_relationships/Home"
      
      expect( team ).to have_received( :players ).at_least :once
    end
    
    it "redirects to the home page the team does NOT exist" do
      allow( Team ).to receive( :where ).and_return []
      
      get "/view_score_relationships/Home"
      follow_redirect!
      
      expect( last_request.url ).to eq "http://example.org/"
    end
    
    it "sets a flash message when it cannot find the team" do
      allow( Team ).to receive( :where ).and_return []
      get "/view_score_relationships/Home"
      follow_redirect!
      
      expect( last_response.body ).to match /No team/
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
      allow( Actions::CreateGame ).to receive( :new ).
        and_return Actions::CreateGame
      allow( Actions::CreateGame ).to receive( :call ).
        and_return true
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
    
    it "creates the game" do
      post "/add_game", params
      
      expect( Actions::CreateGame ).to have_received( :call )
    end
    
    it "sets a successful flash message" do
      post "/add_game", params
      follow_redirect!
      
      expect( last_response.body ).to match /Successfully/
    end
    
    it "redirects back to the home page" do
      post "/add_game", params
      follow_redirect!
      
      expect( last_request.url ).to eq "http://example.org/"
    end
    
    context "when it fails to create the game" do
      before :each do
        allow( Actions::CreateGame ).to receive( :call ).
          and_return false
      end
      
      it "redirects back to the /add_stats page when it fails" do
        post "/add_game", params
        follow_redirect!
      
        expect( last_request.url ).to eq "http://example.org/add_stats"
      end
    
      it "sets a failed flas message" do
        post "/add_game", params
        follow_redirect!
      
        expect( last_response.body ).to match /Failed/
      end
    end
  end
end