class Team < ActiveRecord::Base
  has_many :games, foreign_key: "home_team_id", class_name: "Game"
  has_many :games, foreign_key: "away_team_id", class_name: "Game"
  has_many :players

  validates_uniqueness_of :name
  validate_presence_of :name
end