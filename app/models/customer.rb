class Customer < ActiveRecord::Base
  scope :search, ->(where_clause, args, order_clause){where(where_clause, args).order order_clause}
end
