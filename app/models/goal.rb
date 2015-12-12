class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  
  has_many :assists
end