module Shopify
  class TransactionAdapter

    def initialize(spree_payment)
      @spree_payment = spree_payment
    end

    def payment_status
      states = {
        "checkout" => "pending",
        "pending" => "pending",
        "processing" => "pending",
        "invalid" => "failure",
        "failed" => "failure",
        "completed" => "success"
      }
      states[@spree_payment.state]
    end

    def to_shopify
      @line_item ||= ShopifyAPI::Fulfillment.new(
        order_id: @spree_payment.order_id,
        status:   payment_status, # pending, failure, success or error
        currency: "EUR",
        amount: @spree_payment.amount.to_f,
        gateway: @spree_payment.payment_method.name,
      )
    end
  end
end
