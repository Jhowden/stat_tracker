module Repository
  class GameRepository
    attr_reader :team
    
    def initialize( team )
      @team = team
    end
    
    def all()
      team.home_games + team.away_games
    end
    
    def game_victor_data()
      games_won = Game.where( winner: team )
      [
        {label: "won", count: games_won.count }, 
        {label: "lost", count: all.size - games_won.size}
      ]
    end
  end
end