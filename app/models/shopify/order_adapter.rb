module Shopify
  class OrderAdapter

    def initialize(spree_order)
      @spree_order = spree_order
    end

    def to_shopify
      @order ||= ShopifyAPI::Order.new(
        email:                   @spree_order.email,
        total_line_items_price:  @spree_order.item_total,
        total_price:             @spree_order.total,
        total_tax:               total_tax,
        total_weight:            total_weight,
        taxes_included:          true,
        order_id:                @spree_order.number,
        currency:                @spree_order.currency,
        name:                    @spree_order.number,
        created_at:              @spree_order.created_at,
        updated_at:              @spree_order.updated_at,
        source_name:             "spree",
        financial_status:        payment_state(@spree_order.payment_state),
        fulfillment_status:      shipment_state(@spree_order.shipment_state),
        customer:                customer,
        line_items:              line_items,
        billing_address:         billing_address,
        shipping_address:        shipping_address
        )
    end

    def total_tax
      @spree_order.line_items.map(&:tax_amount).reduce(:+).to_f
    end

    def total_weight
      @spree_order.line_items.map(&:product).map(&:weight).map(&:to_i).reduce(:+)
    end

    def customer
      @customer = ShopifyAPI::Customer.find(:first, :from => :search, :params => { :q => "email:#{@spree_order.email}"})
      @customer ||= CustomerAdapter.new(@spree_order.user).to_shopify rescue nil
    end

    def billing_address
      AddressAdapter.new(@spree_order.billing_address).to_shopify
    end

    def shipping_address
      AddressAdapter.new(@spree_order.shipping_address).to_shopify
    end

    def line_items
      @line_items ||= @spree_order.line_items.map do |line_item|
        LineItemAdapter.new(line_item).to_shopify
      end
    end

    def payment_state(state)
      states = {
        "paid" => "paid",
        "balance_due" => "pending",
        "failed" => "voided"
      }
      states[state]
    end

    def shipment_state(state)
      states = {
        "shipped" => "fulfilled",
        "ready" => nil,
        "pending" => nil,
        "partial" => "partial"
      }
      states[state]
    end

  end
end