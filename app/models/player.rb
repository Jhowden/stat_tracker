class Player < ActiveRecord::Base
  belongs_to :team
  
  has_many :primary_assists
  has_many :secondary_assists
  has_many :goals
end