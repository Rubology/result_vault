##
# Load development gems
#
require 'debug'


##
# Load all the gem files in /lib
#
Dir['./lib/*.rb'].each    { |f| load f }
Dir['./lib/**/*.rb'].each { |f| load f }


##
# Reload all the gem files in /lib
#
def reload!
  Dir['./lib/*.rb'].each    { |f| load f }
  Dir['./lib/**/*.rb'].each { |f| load f }
end
