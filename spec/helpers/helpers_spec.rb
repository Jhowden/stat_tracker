require "spec_helper"

describe Helpers do
  class TestHelper
    include Helpers
  end
  
  describe "view_stats" do
    let( :data ) { [{"label" => "won", "count" => 5}, {"label" => "lost", "count" => 4}]}
    subject( :helper ) { TestHelper.new }
    
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
    
    it "retrives the game_vitor_data" do
      helper.view_stats( "Home" )
      
      expect( Repository::GameRepository ).to have_received( :game_victor_data )
    end
    
    it "returns the data as JSON" do
      expect( helper.view_stats( "Home" ) ).to eq( data.to_json )
    end
  end
end