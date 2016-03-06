require "spec_helper"

describe Repository::ScoreRepository do
  let( :team ) { double( "team") }
  let( :player1 ) { double( "p1", name: "p1", id: 1 ) }
  let( :player2 ) { double( "p2", name: "p2", id: 2 ) }
  let( :player3 ) { double( "p3", name: "p3", id: 3 ) }
  
  subject( :score_repo ) { described_class.new( team ) }

  before "each" do
    allow( team ).to receive( :players ).and_return [player1, player2, player3]
    goal1 = Goal.create( player_id: 2 )
    goal2 = Goal.create( player_id: 1 )
    goal3 = Goal.create( player_id: 1 )
    goal4 = Goal.create( player_id: 3 )
    assist1 = PrimaryAssist.create( player_id: 1 )
    assist2 = SecondaryAssist.create( player_id: 2 )
    assist3 = PrimaryAssist.create( player_id: 2 )
    assist4 = PrimaryAssist.create( player_id: 2 )
    
    goal1.assists << assist1
    goal2.assists << assist2
    goal3.assists << assist3
    goal4.assists << assist4
  end
  
  describe "#get_assist_matrix" do
    it "returns a matrix of assists between each player" do
      expect( subject.get_assist_matrix ).to eq( 
        [
          [0, 1, 0],
          [2, 0, 1],
          [0, 0, 0]
        ]
      )
    end
  end
end