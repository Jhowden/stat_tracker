require "spec_helper"

describe Actions::CreateScore do
  let( :params ) {
    [
      {
        "player" => "One", 
        "ppp"=> "N" , 
        "period" => "1", 
        "time_scored" => "10:10", 
        "assist"=>[{"player"=>"Two"}, {"player"=>"Three"}]}, 
      {
        "player" => "Two", 
        "ppp"=> "Y", 
        "period" => "2", 
        "time_scored" => "09:14", 
        "assist"=>[{"player"=>"Four"}]
      }
    ]
  }
  let( :goal1_map ) {
    {
      "player" => "ONE", 
      "ppp"=> false, 
      "period" => 1, 
      "time_scored" => "10:10",
      "game" => game
    }
  }
  let( :goal2_map ) {
    {
      "player" => "TWO", 
      "ppp"=> true, 
      "period" => 2, 
      "time_scored" => "09:14",
      "game" => game
    }
  }
  let( :assist1_data ) {
    [
      {"player"=>"TWO", "ppp" => false, "period" => 1, "goal" => goal1}, 
      {"player"=>"THREE", "ppp" => false, "period" => 1, "goal" => goal1}
    ]
  }
  let( :assist2_data ) {
    [{"player"=>"FOUR", "ppp" => true, "period" => 2, "goal" => goal2}]
  }
  let( :game ) { double( "game" ) }
  let( :goal1 ) { double( "goal1" ) }
  let( :goal2 ) { double( "goal2" ) }
  let( :create_assist ) { double( "create_assist", call: nil ) }
  subject( :create_goal ) { described_class.new game, params }
  
  before :each do
    stub_const "Goal", Class.new
    allow( Goal ).to receive( :create! ).and_return goal1, goal2
    
    stub_const "Player", Class.new
    allow( Player ).to receive( :where ).and_return(
      [goal1_map["player"]], 
      [assist1_data.first["player"]],
      [assist1_data.last["player"]],
      [goal2_map["player"]],
      [assist2_data.first["player"]]
    )
    
    stub_const "Assist", Class.new
    allow( Assist ).to receive( :create! ).and_return create_assist
  end
  
  describe "#call" do
    it "finds the player who scored the goal" do
      create_goal.call
      
      expect( Player ).to have_received( :where ).with player_name: params.first["player"]
      expect( Player ).to have_received( :where ).
        with( player_name: params.last["player"] ).at_least( :once )
    end
    
    it "creates the goals" do
      create_goal.call
      
      expect( Goal ).to have_received( :create! ).
        with( goal1_map )
      expect( Goal ).to have_received( :create! ).
        with( goal2_map )
    end
    
    it "creates an Assist" do
      create_goal.call
      
      expect( Assist ).to have_received( :create! ).
        with( assist1_data )
      expect( Assist ).to have_received( :create! ).
        with( assist2_data )
    end
  end
end