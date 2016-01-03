get "/" do
  erb :index
end

get "/add_stats" do
  erb :add_stats
end

get "/view_stats/:team_name" do
  team = Team.where( name: params["team_name"]  ).first
  @games_data = Repository::GameRepository.new( team ).
    game_victor_data
  erb :view_stats
end

post "/add_game" do
  Actions::CreateGame.new params
end
