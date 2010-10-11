module WillPaginate
  module ViewHelpers
    @@pagination_options[:prev_label] = '&larr;'
    @@pagination_options[:next_label] = '&rarr;'
    @@pagination_options[:class] = 'pagination'
    
    #@@pagination_options[:inner_window] = 2
    #@@pagination_options[:outer_window] = 1
  end
end