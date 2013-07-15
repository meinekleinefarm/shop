eu_vat = Spree::Zone.find_by_name!("EU_VAT")
eu_vat.default_tax = true
eu_vat.save!


standard_tax = Spree::TaxCategory.create!(:name => "Standard Tax", :description => "Standard tax for all goods", :is_default => true)

reduced_tax = Spree::TaxCategory.create!(:name => "Reduced Tax", :description => "Tax for all goods, that are applicable for reduced tax.", :is_default => false)

standard_tax_rate = Spree::TaxRate.create!({:name => "Standard Tax Rate", :tax_category => standard_tax, :zone => eu_vat, :amount => 0.19, :included_in_price => true, :show_rate_in_label => true, :calculator_type => "Spree::Calculator::DefaultTax"}, :without_protection => true)

reduced_tax_rate = Spree::TaxRate.create!({:name => "Reduced Tax Rate", :tax_category => reduced_tax, :zone => eu_vat, :amount => 0.07, :included_in_price => true, :show_rate_in_label => true, :calculator_type => "Spree::Calculator::DefaultTax"}, :without_protection => true)