class FormHelper
  extend Sinatra::FormHelpers, Sinatra::Templates
  
  def self.link_to_add_fields( name, fields )
    link( name, '#', class: "add_fields", data: fields.gsub( "\n", "" ) )
  end
end