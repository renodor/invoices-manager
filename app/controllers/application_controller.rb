# frozen_string_literal:true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?

  def render_pdf(locals:, file_name:)
    html = render_to_string(action: :show, layout: "pdf", formats: [:html], locals: locals)
    pre_processed_pdf = Grover::HTMLPreprocessor.process(html, Rails.application.config.asset_host, "http")

    respond_to do |format|
      format.html { render html: html }
      format.pdf do
        pdf = Grover.new(pre_processed_pdf, format: "A4").to_pdf
        send_data pdf, filename: file_name, type: "application/pdf"
      end
    end
  end
end
