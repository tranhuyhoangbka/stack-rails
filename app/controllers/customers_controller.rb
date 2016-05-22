class CustomersController < ApplicationController
  PAGE_SIZE = 10

  def index
    @page = params[:page].to_i || 0
    @customers = if params[:keywords].present?
      customer_search_term = CustomerSearchTerm.new params[:keywords]
      Customer.search(customer_search_term.where_clause,
        customer_search_term.where_args, customer_search_term.order)
        .offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
    else
      []
    end
  end
end
