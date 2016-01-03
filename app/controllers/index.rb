get "/" do
  erb :index
end

get "/add_stats" do
  erb :add_stats
end

get "/view_stats/:team_name" do
  team = Team.where( name: params["team_name"]  ).first
  if team
    @games_data = Repository::GameRepository.new( team ).
      game_victor_data
    erb :view_stats
  else
    flash[:error] = "No team with the name #{params['team_name']} exists. Please select a correct name."
    redirect to( "/" )
  end
end

post "/add_game" do
  if Actions::CreateGame.new( params ).call
    flash[:success] = "Successfully created game!"
    redirect to( "/" )
  else
    flash[:error] = "Failed to create game, please try again."
    redirect to( "/add_stats" )
  end
end
