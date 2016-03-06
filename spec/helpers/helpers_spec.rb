require "spec_helper"

describe Helpers do
  class TestHelper
    include Helpers
  end

  subject( :helper ) { TestHelper.new }

  describe "#view_stats" do
    let( :data ) { [{"label" => "won", "count" => 5}, {"label" => "lost", "count" => 4}]}
    
    before :each do
      stub_const "Repository::GameRepository", Class.new
      allow( Repository::GameRepository ).to receive( :new ).
        and_return Repository::GameRepository
      allow( Repository::GameRepository ).to receive( :game_victor_data ).
        and_return data
    end
    
    it "grabs the data from the Repository::GameRepository" do
      helper.view_stats( "Home" )
      expect( Repository::GameRepository ).to have_received( :new ).
        with( "Home" )
    end
    
    it "retrives the game_victor_data" do
      helper.view_stats( "Home" )
      
      expect( Repository::GameRepository ).to have_received( :game_victor_data )
    end
    
    it "returns the data as JSON" do
      expect( helper.view_stats( "Home" ) ).to eq( data.to_json )
    end
  end
  
  describe "#view_assist_relationships" do
    let( :data ) { [[0, 1, 0], [4,0,5]]}
    
    before :each do
      stub_const "Repository::ScoreRepository", Class.new
      allow( Repository::ScoreRepository ).to receive( :new ).
        and_return Repository::ScoreRepository
      allow( Repository::ScoreRepository ).to receive( :get_assist_matrix ).
        and_return data
    end
    
    it "grabs the data from the Repository::ScoreRepository" do
      helper.view_assist_relationships( "Home" )
      
      expect( Repository::ScoreRepository ).to have_received( :new ).
        with "Home"
    end
    
    it "retrieves the relationship assist matrix" do
      helper.view_assist_relationships( "Home" )
      
      expect( Repository::ScoreRepository ).
        to have_received( :get_assist_matrix )
    end
    
    it "returns the data as JSON" do
      expect( helper.view_assist_relationships( "home" ) ).
        to eq data.to_json
    end
  end
end