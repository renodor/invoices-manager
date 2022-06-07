# frozen_string_literal:true

class InvoicesController < ApplicationController
  before_action :set_invoice, except: %i[index new create]

  def index
    @invoices = current_user.invoices.not_deleted.ordered
  end

  def show
    @client = @invoice.client
  end

  def new
    @clients = current_user.clients.not_deleted
    @invoice = current_user.invoices.build
  end

  def create
    @invoice = current_user.invoices.build(invoice_params)

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
    if @invoice.update(invoice_params)
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
      respond_to do |format|
        format.html { redirect_to invoices_path, notice: 'Invoice was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Invoice was successfully updated.' }
      end
    else
      render :edit_infos, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy(do_i_really_want_to_do_it: !@invoice.locked?)

    redirect_to invoices_path, notice: 'Invoice was successfully destroyed.'
  end

  def export_to_pdf
    html = render_to_string(action: :show, layout: 'pdf', formats: [:html], locals: { :@invoice => @invoice, :@client => @invoice.client })
    r = Grover::HTMLPreprocessor.process(html, 'http://localhost:3000/', 'http')

    respond_to do |format|
      format.html { render html: html }
      format.pdf do
        render_pdf(r, filename: @invoice.pdf_file_name)
      end
    end
  end

  private

  def set_invoice
    @invoice = current_user.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:name, :date, :title, :number, :client_id, :locked)
  end

  def render_pdf(html, filename:)
    pdf = Grover.new(html, format: 'A4').to_pdf
    send_data pdf, filename: filename, type: 'application/pdf'
  end
end
