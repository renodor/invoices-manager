# frozen_string_literal:true

module InvoicesHelper
  def hide_on_pdf
    'display-none' if params[:action] == 'export_to_pdf'
  end

  def flavors_select_hash
    Invoice.flavors.to_h do |flavor|
      [t("invoice_flavors.#{flavor}"), flavor]
    end
  end
end
