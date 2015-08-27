module Shopify
  class FulfillmentAdapter

    def initialize(spree_shipment)
      @spree_shipment = spree_shipment
    end

    def shipping_status
      states = {
        "ready" => "pending",
        "pending" => "pending",
        "partial" => "partial",
        "shipped" => "success"
      }
      states[@spree_shipment.state]
    end

    def to_shopify
      @line_item ||= ShopifyAPI::Fulfillment.new(
        order_id: @spree_shipment.order_id,
        status:   shipping_status, # pending, success, cancelled, error, failure
        tracking_company: 'DHL',
        tracking_numbers: [@spree_shipment.tracking],
        tracking_urls: ["http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=#{@spree_shipment.tracking}"],
        created_at:       @spree_shipment.created_at,
        updated_at: @spree_shipment.updated_at
      )
    end
  end
end
