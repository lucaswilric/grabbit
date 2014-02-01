# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Grabbit3::Application.initialize!

Mime::Type.register "application/x-opml", :opml