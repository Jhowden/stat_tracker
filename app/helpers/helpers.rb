module Helpers
  def view_stats( team )
    game_data = Repository::GameRepository.new( team ).game_victor_data
    game_data.to_json
  end
  
  def view_assist_relationships( team )
    assist_matrix = Repository::ScoreRepository.new( team ).get_assist_matrix
    assist_matrix.to_json
  end
end