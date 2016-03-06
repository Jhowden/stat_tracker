helpers do
  include Helpers
end

get "/" do
  erb :index
end

get "/add_stats" do
  erb :add_stats
end

get "/view_team_stats/:team_name" do
  @team = Team.where( name: params["team_name"]  ).first
  if @team
    erb :view_stats
  else
    flash[:error] = "No team with the name #{params['team_name']} exists. Please select a correct name."
    redirect to( "/" )
  end
end

get "/view_score_relationships/:team_name" do
  @team = Team.where( name: params["team_name"] ).first
  if @team
    @players = @team.players.sort_by { |player| player.id }.map( &:player_name )
    erb :view_score_relationships
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
