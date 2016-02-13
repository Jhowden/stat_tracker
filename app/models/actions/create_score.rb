module Actions
  class CreateScore
    attr_reader :game, :goal_data
    
    def initialize( game, goal_data )
      @game = game
      @goal_data = goal_data
    end
    
    def call()
      goal_data.each do |data|
        transformed_goal_map = transform_goal_data data
        goal = Goal.create! transformed_goal_map
        transformed_assist_map = transform_assist_data transformed_goal_map, goal
        create_assists!( transformed_assist_map ) unless transformed_assist_map.empty?
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
    
    def transform_assist_data( map, goal )
      assist_data = map.delete( "assist" )
      return {} if assist_data.empty?
      assist_data.map do |m|
        m.merge( 
          "player" => find_player( m["player"] ),
          "ppp" => map["ppp"],
          "period" => map["period"],
          "goal" => goal
        )
      end
    end
    
    def create_assists!( assist_map )
      PrimaryAssist.create! assist_map.first
      SecondaryAssist.create! assist_map.last unless assist_map.size == 1
    end
    
    def find_player( player_name )
      Player.where( player_name:  player_name ).first
    end
  end
end