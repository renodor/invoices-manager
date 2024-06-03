# frozen_string_literal:true

class QuotesController < ApplicationController
  def index
    @quotes_grouped_by_year = current_user.quotes.ordered.group_by { |quote| quote.date.year }
  end
end
