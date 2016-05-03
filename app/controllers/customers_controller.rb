class CustomersController < ApplicationController
  def index
    @customers = if params[:keywords].present?
      @keywords = params[:keywords]
      customer_search_term = CustomerSearchTerm.new @keywords
      Customer.search customer_search_term.where_clause,
        customer_search_term.where_args, customer_search_term.order
    else
      []
    end
  end
end
