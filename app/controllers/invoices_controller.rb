# frozen_string_literal:true

class InvoicesController < ApplicationController
  before_action :set_invoice, except: %i[index new create]

  def index
    @invoices_grouped_by_year = current_user.invoices.not_deleted.ordered.group_by { |invoice| invoice.date.year }
  end

  def show
    @client = @invoice.client
    @bank = @invoice.bank
  end

  def new
    @clients = current_user.clients.not_deleted
    @invoice = current_user.invoices.build
  end

  def create
    @invoice = current_user.invoices.new
    @invoice.attributes = invoice_params
    @invoice.seller_name = current_user.full_name
    @invoice.seller_address1 = current_user.address1
    @invoice.seller_zipcode = current_user.zipcode
    @invoice.seller_city = current_user.city
    @invoice.seller_country = current_user.country
    @invoice.seller_email = current_user.email
    @invoice.seller_website = current_user.website
    @invoice.seller_siren = current_user.siren
    assign_client_attributes_to_invoice

    if @invoice.save
      redirect_to invoice_path(@invoice), notice: 'Invoice was successfully created.'
    else
      @clients = current_user.clients.not_deleted
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @invoice.update(invoice_params)
      redirect_to invoice_path(@invoice), notice: 'Invoice was successfully updated.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def edit_client
    @clients = current_user.clients.not_deleted
    @client = @invoice.client
  end

  def update_client
    @invoice.client_id = invoice_params[:client_id]
    assign_client_attributes_to_invoice
    if @invoice.save
      @client = @invoice.client
      respond_to do |format|
        format.html { redirect_to invoices_path, notice: 'Invoice was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Invoice was successfully updated.' }
      end
    else
      render :edit_client, status: :unprocessable_entity
    end
  end

  def edit_infos; end

  def update_infos
    if @invoice.update(invoice_params)
      @bank = @invoice.bank
      respond_to do |format|
        format.html { redirect_to invoices_path, notice: 'Invoice was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Invoice was successfully updated.' }
      end
    else
      render :edit_infos, status: :unprocessable_entity
    end
  end

  def edit_bank
    @banks = current_user.banks
    @bank = @invoice.bank
  end

  def update_bank
    if @invoice.update(invoice_params)
      @bank = @invoice.bank
      respond_to do |format|
        format.html { redirect_to invoices_path, notice: 'Invoice was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Invoice was successfully updated.' }
      end
    else
      render :edit_bank, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy(do_i_really_want_to_do_it: !@invoice.locked?)

    redirect_to invoices_path, notice: 'Invoice was successfully destroyed.'
  end

  def export_to_pdf
    render_pdf(
      locals: { :@invoice => @invoice, :@client => @invoice.client, :@bank => @invoice.bank },
      file_name: @invoice.pdf_file_name
    )
  end

  private

  def set_invoice
    @invoice = current_user.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:date, :title, :number, :client_id, :bank_id, :locked, :flavor)
  end

  def assign_client_attributes_to_invoice
    @invoice.client_name = @invoice.client.name
    @invoice.client_address1 = @invoice.client.address1
    @invoice.client_address2 = @invoice.client.address2
    @invoice.client_zipcode = @invoice.client.zipcode
    @invoice.client_city = @invoice.client.city
  end
end
