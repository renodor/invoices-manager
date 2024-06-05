# frozen_string_literal:true

module FinancialMethods
  extend ActiveSupport::Concern

  TVA = 0.2

  def total_without_taxes
    line_items.sum(&:total_price)
  end

  def tva
    flavor == 'with_tva' ? total_without_taxes * TVA : 0
  end

  def total
    total_without_taxes + tva
  end
end
