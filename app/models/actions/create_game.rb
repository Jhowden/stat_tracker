class CreateGame
  attr_reader :params, :logger
  
  def initialize( params, logger = EASHLStatTracker::DistortedLogger.new( "actions" ) )
    @params = params
    @logger = logger
  end
  
  def call()
    Game.transaction do
      game = create_game
      CreateGoal.new( game, transformed_params["goal"] ).call
    end
  rescue ActiveRecord::Rollback => e
    logger.error "Bad data creating data: #{e.backtrace}"
  end
  
  private
  
  def create_game()
    game_map = transformed_params["game"]
    game = Game.create! game_map
  end
  
  def transformed_params()
    return @transformed_params if @transformed_params
    game_map = transform_game_params( params.delete( "game" ) )
    @transformed_params = params.merge( "game" => game_map )
  end
  
  def transform_game_params( game_params )
    home_team = find_team( game_params["home_team"] )
    away_team = find_team( game_params["away_team"] )
    game_params.merge( "home_team" => home_team, "away_team" => away_team)
  end
  
  def find_team( team_name )
    Team.where( name: team_name ).first
  end
end