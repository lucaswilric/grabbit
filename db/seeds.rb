# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

User.create({:name => 'Lucas Wilson-Richter', :open_id => 'http://openid.lucasrichter.id.au/'}) unless User.find_by_open_id 'http://openid.lucasrichter.id.au/'

