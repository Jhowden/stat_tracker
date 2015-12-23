require "spec_helper"

describe FormHelper do
  let( :fields ) { double( "fields", gsub: "text stuff" ) }
  
  describe ".link_to_add_fields" do
    it "creates a link" do
      expect( described_class.link_to_add_fields( "route", fields ) )
        .to eq "<a class=\"add_fields\" data=\"text stuff\" href=\"#\">route</a>"
    end
  end
end