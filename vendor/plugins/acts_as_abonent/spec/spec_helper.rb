if defined?(RAILS_ROOT)
  require "#{RAILS_ROOT}/spec/spec_helper.rb"
else
  require File.dirname(__FILE__) + "../../../../../spec/spec_helper.rb" unless defined?(RAILS_ROOT)
end

