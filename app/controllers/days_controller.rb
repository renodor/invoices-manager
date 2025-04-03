# frozen_string_literal:true

class DaysController < ApplicationController
  before_action :set_invoice
  before_action :set_day, only: %i[edit update]

  def new
    @day = @invoice.days.build
  end

  def edit; end

  def update
    if @day.update(day_params)
      respond_to do |format|
        format.html { redirect_to invoice_path(@invoice), notice: I18n.t("day_update_success") }
        format.turbo_stream { flash.now[:notice] = I18n.t("day_update_success") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def generate_month
    date = Date.parse(params[:date])
    (Date.new(date.year, date.month, 1)..Date.new(date.year, date.month, -1)).each do |day|
      next if [0, 6].include?(day.wday)

      @invoice.days.create(date: day)
    end

    respond_to do |format|
      format.html { redirect_to invoice_path(@invoice), notice: I18n.t("calendar_creation_success") }
      format.turbo_stream { flash.now[:notice] = I18n.t("calendar_creation_success") }
    end
  end

  def remove_month
    @invoice.days.destroy_all

    respond_to do |format|
      format.html { redirect_to invoice_path(@invoice), notice: I18n.t("calendar_destroy_success") }
      format.turbo_stream { flash.now[:notice] = I18n.t("calendar_destroy_success") }
    end
  end

  private

  def set_invoice
    @invoice = current_user.invoices.find(params[:invoice_id])
  end

  def set_day
    @day = @invoice.days.find(params[:id])
  end

  def day_params
    params.require(:day).permit(:worked, :comment)
  end
end
