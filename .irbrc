##
# Load development gems
#

load File.expand_path('ruby_version.rb', Dir.pwd)
# require 'debug'


##
# Load all the gem files in /lib
#
Dir[Dir.pwd + '/lib/*.rb'].each    { |f| load f }
Dir[Dir.pwd + '/lib/**/*.rb'].each { |f| load f }

puts "LOADED"
##
# Reload all the gem files in /lib
#
def reload!
  load File.expand_path('ruby_version.rb', Dir.pwd)
  Dir[Dir.pwd + '/lib/*.rb'].each    { |f| load f }
  Dir[Dir.pwd + '/lib/**/*.rb'].each { |f| load f }
end
