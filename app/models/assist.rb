class Assist < ActiveRecord::Base
  belongs_to :goal
  
  belongs_to :player
  
  validates_presence_of :type
end