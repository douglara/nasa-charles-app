class Message < ApplicationRecord
  
  before_create do
    #self.name = login.capitalize if name.blank?
  end
end
