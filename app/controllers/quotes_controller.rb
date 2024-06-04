# frozen_string_literal:true

class QuotesController < ApplicationController
  before_action :set_quote, except: %i[index new create]

  def index
    @quotes_grouped_by_year = current_user.quotes.ordered.group_by { |quote| quote.date.year }
  end

  def new
    @quote = current_user.quotes.build
  end

  def create
    @quote = current_user.quotes.new(quote_params)

    if @quote.save
      redirect_to quote_path(@quote), notice: 'Invoice was successfully created.'
    else
      @clients = current_user.clients.not_deleted
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit_client; end

  def update_client
    if @quote.update(quote_params)
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: 'Quote was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Quote was successfully updated.' }
      end
    else
      render :edit_client, status: :unprocessable_entity
    end
  end

  def edit_infos; end

  def update_infos
    if @quote.update(quote_params)
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: 'Quote was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Quote was successfully updated.' }
      end
    else
      render :edit_infos, status: :unprocessable_entity
    end
  end

  private

  def set_quote
    @quote = current_user.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:date, :title, :client_name, :flavor)
  end
end
