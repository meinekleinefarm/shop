module ValidationLogger
  extend ActiveSupport::Concern

  included do
    cattr_reader :logger
    after_validation :log_errors, if: ->(m) { m.errors.present? }

    VALIDATION_LOGGER ||= Logger.new(Rails.root.join('log', 'validations.log'))

    private

    def log_errors
      VALIDATION_LOGGER.warn "#{self.class.name} #{self.id || '(new)'} is invalid: ERRORS: #{self.errors.full_messages.inspect}, ATTRIBUTES: #{self.attributes.inspect}"
    end
  end
end