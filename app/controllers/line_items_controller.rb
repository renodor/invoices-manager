# frozen_string_literal:true

class LineItemsController < ApplicationController
  before_action :set_document
  before_action :set_line_item, only: %i[edit update destroy]

  def new
    @line_item = @document.line_items.new
  end

  def create
    @line_item = @document.line_items.build(line_item_params)

    if @line_item.save
      respond_to do |format|
        format.html { redirect_to invoice_path(@invoice), notice: I18n.t('line_item_creation_success') }
        format.turbo_stream { flash.now[:notice] = I18n.t('line_item_creation_success') }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @line_item.update(line_item_params)
      respond_to do |format|
        format.html { redirect_to invoice_path(@invoice), notice: I18n.t('line_item_update_success') }
        format.turbo_stream { flash.now[:notice] = I18n.t('line_item_update_success') }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to invoice_path(@document), notice: I18n.t('line_item_destroy_success') }
      format.turbo_stream { flash.now[:notice] = I18n.t('line_item_destroy_success') }
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:description, :quantity, :unit_price)
  end

  def set_document
    @document = params[:invoice_id].present? ? current_user.invoices.find(params[:invoice_id]) : current_user.quotes.find(params[:quote_id])
  end

  def set_line_item
    @line_item = @document.line_items.find(params[:id])
  end
end
