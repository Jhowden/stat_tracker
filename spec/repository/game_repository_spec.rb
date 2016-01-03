require "spec_helper"

describe Repository::GameRepository do
  let( :team ) { double( "team", home_games: ["Game3", "Game2"], away_games: ["Game1", "Game4", "Game5"] ) }
  let( :games ) { ["Game1", "Game2"] }
  let( :game_repo ) { described_class.new( team ) }
  
  describe "#game_victor_data" do
    before :each do
      stub_const "Game", Class.new
      allow( Game ).to receive( :where ).and_return games
    end
    it "returns json of the games won and games lost" do
      expect( game_repo.game_victor_data ).to eq( 
        [{label: "won", count: 2}.to_json, {label: "lost", count: 3}.to_json] )
    end
  end
end