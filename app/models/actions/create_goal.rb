module Actions
  class CreateGoal
    attr_reader :game, :goal_data
    
    def initialize( game, goal_data )
      @game = game
      @goal_data = goal_data
    end
    
    def call()
      goal_data.each do |data|
        transformed_goal_map = transform_goal_data data
        goal = Goal.create! transformed_goal_map
        transformed_assist = transform_assist transformed_goal_map, goal
        Actions::CreateAssist.new( transformed_assist )
      end
    end
    
    private
    
    def transform_goal_data( map )
      map.merge( 
        "player" => find_player( map["player"] ),
        "period" => map["period"].to_i,
        "ppp" => map["ppp"] == "Y" ? true : false,
        "game" => game
      )
    end
    
    def find_player( player_name )
      Player.where( player_name:  player_name ).first
    end
    
    def transform_assist( map, goal )
      assist_data = map.delete( "assist" )
      return {} if assist_data.empty?
      assist_data.each do |m|
        m.merge!( 
          "player" => find_player( m["player"] ),
          "ppp" => map["ppp"],
          "period" => map["period"],
          "goal" => goal
        )
      end
    end
  end
end