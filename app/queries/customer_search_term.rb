class CustomerSearchTerm
  attr_reader :where_clause, :where_args, :order

  def initialize search_term
    search_term.downcase!
    @where_clause = ""
    @where_args = {}
    if search_term =~ /@/
      build_for_email_search search_term
    else
      build_for_name_search search_term
    end
  end

  private
  def build_for_name_search search_term
    search_with_name search_term
    @order = "last_name ASC"
  end

  def build_for_email_search search_term
    search_with_name extract_name(search_term)
    @where_clause << "OR #{case_insensitive_search(:email)}"
    @where_args.merge!({email: search_term})
    @order = "lower(email) = #{ActiveRecord::Base.connection.quote(search_term)} DESC, last_name ASC"
  end

  def search_with_name name
    @where_clause << case_insensitive_search(:first_name) << "OR #{case_insensitive_search(:last_name)}"
    @where_args.merge!({first_name: starts_with(name), last_name: starts_with(name)})
  end

  def case_insensitive_search field_name
    "lower(#{field_name}) LIKE :#{field_name} "
  end

  def starts_with search_term
    "#{search_term}\%"
  end

  def extract_name search_term
    search_term.gsub  /@.+\.\w+/, ""
  end
end