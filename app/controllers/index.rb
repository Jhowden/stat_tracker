get "/" do
  erb :index
end

get "/add_stats" do
  erb :add_stats
end

post "/add_game" do
  Actions::CreateGame.new( params )
end
