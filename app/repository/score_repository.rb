module Repository
  class ScoreRepository
    attr_reader :team

    def initialize( team )
      @team = team
    end
    
    def get_assist_matrix()
      assist_matrix = []
      players.sort_by { |p| p.id }.each do |player|
        build_assist_matrix( player, assist_matrix )
      end
      assist_matrix
    end
    
    private
    
    def build_assist_matrix( player, matrix )
      player_assist = []
      sorted_assisted_goals = Goal.joins( :assists ).
        where( "goals.player_id !=  #{player.id} and assists.player_id = #{player.id}" ).
        sort_by { |goal| goal.player_id }
      sorted_assisted_goals.chunk { |goal| goal.player_id }.each do |player_id, goals|
        player_assist << goals.count
      end
      players_with_goals_but_no_accompanying_assists = player_ids - sorted_assisted_goals.map( &:player_id ).uniq
      players_with_goals_but_no_accompanying_assists.each do |id|
        player_assist.insert( id - 1,  0 )
      end
      matrix << player_assist
    end
    
    def players()
      return @player if @players
      @player = team.players
    end
    
    def player_ids()
      @player_ids = players.map &:id
    end
  end
end