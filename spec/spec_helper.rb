$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'created-and-updated-by'
require 'active_record'
require 'active_record/fixtures'
require 'active_support'
require 'active_support/core_ext'
require 'spec'
require 'spec/autorun'

# establish the database connection
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
ActiveRecord::Base.establish_connection('active_record_merge_test')

# load the schema
$stdout = File.open('/dev/null', 'w')
load(File.dirname(__FILE__) + "/db/schema.rb")
$stdout = STDOUT


require File.dirname(__FILE__) + '/db/models'
CreatedAndUpdatedBy::Stamper.attach(:User, :current)

users = [User.create!(:something => 'test'), User.create!(:something => 'something else')]

User.current = users[0]

Spec::Runner.configure do |config|
  
end
