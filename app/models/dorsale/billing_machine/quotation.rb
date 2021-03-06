module Dorsale
  module BillingMachine
    class Quotation < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_quotations"

      belongs_to :customer, polymorphic: true
      belongs_to :id_card
      belongs_to :payment_term
      has_many :lines,
        :inverse_of => :quotation,
        :dependent  => :destroy,
        :class_name => ::Dorsale::BillingMachine::QuotationLine

      has_many :attachments,
        :as         => :attachable,
        :dependent  => :destroy,
        :class_name => ::Dorsale::Alexandrie::Attachment

      accepts_nested_attributes_for :lines, allow_destroy: true

      polymorphic_id_for :customer

      validates :id_card, presence: true
      validates :date,    presence: true

      # simple_form
      validates :id_card_id, presence: true

      def initialize(*args)
        super
        self.date       = Date.today     if date.nil?
        self.expires_at = date + 1.month if expires_at.nil?
        self.vat_rate   = 20             if vat_rate.nil?
      end

      before_create :assign_unique_index
      before_create :assign_tracking_id

      def assign_unique_index
        if unique_index.nil?
          self.unique_index = self.class.all.pluck(:unique_index).max.to_i.next
        end
      end

      def assign_tracking_id
        self.tracking_id = date.year.to_s + "-" + unique_index.to_s.rjust(2, "0")
      end

      before_save :update_total

      def update_total
        self.vat_rate        = 0 if vat_rate.nil?
        self.total_duty      = lines.pluck(:total).sum
        self.vat_amount      = total_duty * vat_rate / 100.0
        self.total_all_taxes = total_duty + vat_amount
      end

      def pdf
        pdf = ::Dorsale::BillingMachine::QuotationPdf.new(self)
        pdf.build
        pdf
      end

    end # Quotation
  end # BillingMachine
end # Dorsale
