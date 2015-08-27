module Shopify
  class OrderAdapter

    def initialize(spree_order)
      @spree_order = spree_order
    end

    def to_shopify
      @order ||= ShopifyAPI::Order.new(attributes)
    end

    def attributes
      {
        email:                   @spree_order.email,
        send_receipt:            false,
        total_line_items_price:  @spree_order.item_total,
        total_price:             @spree_order.total,
        total_tax:               total_tax,
        total_weight:            total_weight,
        taxes_included:          true,
        tax_lines:               tax_lines,
        shipping_lines:          shipping_lines,
        total_discounts:         total_discounts,
        order_id:                @spree_order.number,
        currency:                @spree_order.currency,
        name:                    @spree_order.number,
        order_number:            @spree_order.number,
        created_at:              @spree_order.created_at,
        updated_at:              @spree_order.updated_at,
        processed_at:            @spree_order.completed_at,
        source_name:             "spree",
        financial_status:        payment_state(@spree_order.payment_state),
        transactions:            transactions,
        fulfillment_status:      shipment_state(@spree_order.shipment_state),
        fulfillments:            fulfillments,
        customer:                customer,
        line_items:              line_items,
        billing_address:         billing_address,
        shipping_address:        shipping_address
      }
    end

    def total_tax
      @spree_order.line_items.map(&:tax_amount).reduce(:+).to_f
    end

    def total_discounts
      @spree_order.adjustments.where("amount < 0").map(&:amount).reduce(:+).to_f
    end

    def shipping_lines
      @spree_order.adjustments.where(originator_type: "Spree::ShippingMethod").map do |adjustment|
        {
          code: adjustment.originator.name,
          price: adjustment.amount.to_f,
          title: adjustment.originator.name,
          source: 'spree_commerce',
          taxlines: []
        }
      end
    end

    def tax_lines
      [{
        price: total_tax,
        rate: 0.07,
        title: "inkl. USt."
      }]
    end

    def total_weight
      @spree_order.line_items.map(&:variant).map(&:weight).map(&:to_i).reduce(:+)
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

    def fulfillments
      @fulfillments ||= @spree_order.shipments.map do |shipment|
        FulfillmentAdapter.new(shipment).to_shopify
      end
    end

    def transactions
      @transaction ||= @spree_order.payments.map do |payment|
        TransactionAdapter.new(payment).to_shopify
      end
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
        "ready" => nil,
        "pending" => nil,
        "partial" => "partial",
        "shipped" => "fulfilled"
      }
      states[state]
    end

  end
end