class AddWithAgreementToQuotes < ActiveRecord::Migration[7.0]
  def change
    add_column :quotes, :with_agreement, :boolean, default: false
  end
end
