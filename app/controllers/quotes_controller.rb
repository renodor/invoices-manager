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
      redirect_to quote_path(@quote), notice: I18n.t("quote_creation_success")
    else
      @clients = current_user.clients.not_deleted
      flash.now[:alert] = I18n.t("quote_creation_error")
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @quote.destroy

    redirect_to quotes_path, notice: I18n.t("quote_destroy_success")
  end

  def edit_client; end

  def update_client
    if @quote.update(quote_params)
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: I18n.t("quote_update_success") }
        format.turbo_stream { flash.now[:notice] = I18n.t("quote_update_success") }
      end
    else
      render :edit_client, status: :unprocessable_entity
    end
  end

  def edit_infos; end

  def update_infos
    if @quote.update(quote_params)
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: I18n.t("quote_update_success") }
        format.turbo_stream { flash.now[:notice] = I18n.t("quote_update_success") }
      end
    else
      render :edit_infos, status: :unprocessable_entity
    end
  end

  def edit_with_agreement; end

  def update_with_agreement
    @quote.update(with_agreement: ActiveModel::Type::Boolean.new.cast(params[:with_agreement]))
  end

  def new_description_block; end

  def create_description_block
    @quote.description_blocks << {
      type: params[:block_type],
      value: params[:block_type] == "list" ? params[:block_value].gsub("- ", "").split("\n") : params[:block_value],
      position: @quote.description_blocks&.last&.dig("position").to_i + 1
    }

    @quote.save!
  end

  def edit_description_block
    @description_block = find_description_block_by_position
  end

  def update_description_block
    description_block = find_description_block_by_position
    description_block["value"] = params[:block_type] == "list" ? params[:block_value].gsub("- ", "").split("\n") : params[:block_value]
    @quote.save!
  end

  def destroy_description_block
    description_block = find_description_block_by_position

    @quote.description_blocks.delete(description_block)
    @quote.save!
  end

  def export_to_pdf
    render_pdf(
      locals: { :@quote => @quote },
      file_name: @quote.pdf_file_name
    )
  end

  private

  def set_quote
    @quote = current_user.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:number, :date, :title, :client_name, :client_address1, :client_address2, :client_zipcode, :client_city, :client_country, :flavor, :with_agreement)
  end

  def find_description_block_by_position
    @quote.description_blocks.detect { |block| block["position"] == params[:block_position].to_i }
  end
end
