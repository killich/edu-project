# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
#ENV["RAILS_ENV"] ||= 'test'
ENV["RAILS_ENV"] = 'test'

p 'SPEC CONFIG HELPER'

require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    
  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

###################################################################################################
# Более удобное тестирование фильтров контроллеров
###################################################################################################

=begin
describe PostsController do
  describe "before filters" do
    it "should have find_post" do
      controller.before_filters.should include(:find_post)
    end
    it "find_post should have options" do
      controller.before_filter(:find_post).should have_options(:only => [:show])
    end
    it "find_post should find a post" do
      Post.should_receive(:find).with("1")
      controller.run_filter(:find_post, :id => "1")
    end
  end
end
=end

module Spec
  module Rails
    module Filters

      def before_filter(name)
        self.class.before_filter.detect { |f| f.method == name }
      end
      
      def run_filter(filter_method, params={})
        self.params = params
        instance_eval filter_method.to_s
      end
      
      def before_filters
        return self.class.before_filter.collect { |f| f.method }
      end

    end
    
    module BeforeFilters
      
      def has_options?(expected_options)
        expected_options.each do |key, values|
          expected_options[key] = Array(values).map(&:to_s).to_set
        end
        
        options == expected_options
      end
      
    end
    
  end
end

ActionController::Base.send(:include, Spec::Rails::Filters) 
ActionController::Filters::BeforeFilter.send(:include, Spec::Rails::BeforeFilters)
###################################################################################################
# Более удобное тестирование фильтров контроллеров
###################################################################################################



