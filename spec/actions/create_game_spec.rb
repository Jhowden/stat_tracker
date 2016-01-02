require "spec_helper"

describe Actions::CreateGame do
  let( :params ) {
    {"_method" => "create", 
      "game"=> 
        {
          "home_team" => "Home", 
          "away_team" => "Away", 
          "winner" => "Home", 
          "date_played" => "12/23/15"
        }, 
      "goal"=>[
        {
          "player" => "One", 
          "ppp"=> "N" , 
          "period" => "1", 
          "time_scored" => "10:10", 
          "assist"=>[{"player"=>"Two"}, {"player"=>"Three"}]}, 
        {
          "player" => "Two", 
          "ppp"=> "Y" , 
          "period" => "2", 
          "time_scored" => "09:14", 
          "assist"=>[{"player"=>"Four"}]
        }], "submit"=>"Create game"}
  }
  let( :game_params ) {
    {
      "home_team" => "HOME", 
      "away_team" => "AWAY", 
      "winner" => "Home", 
      "date_played" => "12/23/15"
    }
  }
  
  let( :goal_params ) {
    [
      {
        "player" => "One", 
        "ppp"=> "N" , 
        "period" => "1", 
        "time_scored" => "10:10", 
        "assist"=>[{"player"=>"Two"}, {"player"=>"Three"}]}, 
      {
        "player" => "Two", 
        "ppp"=> "Y" , 
        "period" => "2", 
        "time_scored" => "09:14", 
        "assist"=>[{"player"=>"Four"}]
      }
    ]
  }
  let( :game ) { double( "game" ) }
  let( :create_goal ) { double( "create_goal", call: nil ) }
  let( :logger ) { double( "logger", error: nil ) }
  
  subject( :create_game ) { described_class.new params, logger }
  
  before :each do
    ["Game", "Actions::CreateScore", "Team"].each do |klass|
      stub_const klass, Class.new
    end
    stub_const "ActiveRecord::Rollback", Class.new( StandardError )
    
    allow( Game ).to receive( :create! ).and_return game
    
    allow( Actions::CreateScore ).to receive( :new ).and_return create_goal
    
    allow( Game ).to receive( :transaction ).and_yield
    
    allow( Team ).to receive( :where ).and_return [game_params["home_team"]], [game_params["away_team"]]
  end
  
  describe "#call" do
    it "finds the home and away team" do
      create_game.call
      
      expect( Team ).to have_received( :where ).with( name: "Home" )
      expect( Team ).to have_received( :where ).with( name: "Away" )
    end
    
    it "creates a new game" do
      create_game.call
      
      expect( Game ).to have_received( :create! ).with game_params
    end
    
    it "skips CreatePoint when given no goal data" do
      create_game = described_class.new( {
        "game"=> 
          {
            "home_team" => "Home", 
            "away_team" => "Away", 
            "winner" => "Home", 
            "date_played" => "12/23/15"
          }, 
        "goal"=>[]
      }, logger )
      create_game.call
      
      expect( Actions::CreateScore ).to_not have_received( :new )
    end
    
    it "instantiates a CreateGoal" do
      create_game.call
      
      expect( Actions::CreateScore ).to have_received( :new ).with( game, goal_params )
    end
    
    it "creates a new goal" do
      create_game.call
      
      expect( create_goal ).to have_received( :call )
    end
    
    it "rescues an ActiveRecord::Rollback when invalid" do
      allow( Game ).to receive( :create! ).and_raise ActiveRecord::Rollback
      
      expect{ create_game.call }.to_not raise_error
    end
    
    it "writes to the logger when ActiveRecord::Rollback is raised" do
      allow( Game ).to receive( :create! ).and_raise ActiveRecord::Rollback
      
      create_game.call
      
      expect( logger ).to have_received( :error )
    end
  end
end