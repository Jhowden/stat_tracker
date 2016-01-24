home = Team.create!( name: "Home", abbreviation: "HME" )
away = Team.create!( name: "Away", abbreviation: "AWY" )

3.times do |t|
  Player.create!( real_name: "Player#{t+1}", player_name: "Playa#{t+1}", team_id: home.id )
end

3.upto( 5 ) do |t|
  Player.create!( real_name: "Player#{t+1}", player_name: "Playa#{t+1}", team_id: away.id )
end

9.times do |t|
  if t.even? && t < 6
    game = Game.create!( date_played: "#{t}/#{t}/2015", winner: home.id, home_team_id: home.id, away_team_id: away.id )
  elsif t.even? && t > 6
    game = Game.create!( date_played: "#{t}/#{t}/2015", winner: home.id, home_team_id: away.id, away_team_id: home.id )
  elsif t.odd? && t < 5
    game = Game.create!( date_played: "#{t}/#{t}/2015", winner: away.id, home_team_id: away.id, away_team_id: home.id )
  else
    game = Game.create!( date_played: "#{t}/#{t}/2015", winner: away.id, home_team_id: home.id, away_team_id: away.id )
  end
  
  3.times do |x|
    if ( t.even? && t < 6 ) || ( t.even? && t > 6 )
      player = Player.find( rand( 1..3 ) )
      goal = Goal.create!( ppp: false, period: t + 1, time_scored: "0#{t}:#{t}#{t+2}", game_id: game.id, player_id: player.id, game_id: game.id ) 
      if player.id == 3
        Assist.create!( ppp: false, period: t + 1, player_id:  player.id - 1, goal_id: goal.id )
      elsif  player.id == 1
        Assist.create!( ppp: false, period: t + 1, player_id:  player.id + 1, goal_id: goal.id )
      else
        Assist.create!( ppp: false, period: t + 1, player_id:  player.id + 1, goal_id: goal.id )
        Assist.create!( ppp: false, period: t + 1, player_id:  player.id - 1, goal_id: goal.id )
      end
    else
      player = Player.find( rand( 3..6 ) )
      goal = Goal.create!( ppp: false, period: t + 1, time_scored: "0#{t}:#{t}#{t+2}", game_id: game.id, player_id: player.id, game_id: game.id )
      if  player.id == 6
        Assist.create!( ppp: false, period: t + 1, player_id:  player.id - 1, goal_id: goal.id )
      elsif  player.id == 4
        Assist.create!( ppp: false, period: t + 1, player_id:  player.id + 1, goal_id: goal.id )
      else
        Assist.create!( ppp: false, period: t + 1, player_id: player.id + 1, goal_id: goal.id )
        Assist.create!( ppp: false, period: t + 1 , player_id: player.id - 1, goal_id: goal.id )
      end
    end
  end
  
  2.times do |y|
    if ( t.even? && t < 6 ) || ( t.even? && t > 6 )
      player = Player.find( rand( 1..3 ) )
      goal = Goal.create!( ppp: true, period: t + 1, time_scored: "0#{t}:#{t}#{t+2}", game_id: game.id, player_id: player.id )
      if  player.id == 3
        Assist.create!( ppp: false, period: t + 1, player_id: player.id - 1, goal_id: goal.id )
      elsif  player.id == 1
        Assist.create!( ppp: false, period: t + 1, player_id: player.id + 1, goal_id: goal.id )
      else
        Assist.create!( ppp: false, period: t + 1, player_id: player.id + 1, goal_id: goal.id )
        Assist.create!( ppp: false, period: t + 1, player_id: player.id - 1, goal_id: goal.id )
      end
    else
      player = Player.find( rand( 3..6 ) )
      goal = Goal.create!( ppp: true, period: t + 1, time_scored: "0#{t}:#{t}#{t+2}", game_id: game.id, player_id: player.id )
      if  player.id == 6
        Assist.create!( ppp: false, period: t + 1, player_id: player.id - 1, goal_id: goal.id )
      elsif  player.id == 4
        Assist.create!( ppp: false, period: t + 1, player_id: player.id + 1, goal_id: goal.id )
      else
        Assist.create!( ppp: false, period: t + 1, player_id: player.id + 1, goal_id: goal.id )
        Assist.create!( ppp: false, period: t + 1, player_id: player.id - 1, goal_id: goal.id )
      end
    end
  end
end