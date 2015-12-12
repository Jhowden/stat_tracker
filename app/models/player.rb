class Player < ActiveRecord::Base
  belongs_to :team
  
  has_many :primary_assists
  has_many :secondary_assists
  has_many :goals
  
  validates_uniquess_of :real_name
end