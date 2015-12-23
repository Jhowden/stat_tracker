get "/" do
  erb :index
end

get "/add_stats" do
  erb :add_stats
end

post "/add_game" do
  puts params
end
