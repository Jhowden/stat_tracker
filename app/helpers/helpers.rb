module Helpers
  def view_stats( team )
    game_data = Repository::GameRepository.new( team ).game_victor_data
    game_data.to_json
  end
end