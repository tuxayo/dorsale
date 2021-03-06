require "rails_helper"

describe ::Dorsale::BillingMachine::QuotationLine do

  it "should have a valid factory" do
    expect(build(:billing_machine_quotation_line)).to be_valid
  end

  it { is_expected.to belong_to :quotation }
  it { is_expected.to respond_to :quantity }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :unit }
  it { is_expected.to respond_to :unit_price }

  it "should be sorted by created_at" do
    line1 = create(:billing_machine_quotation_line,:created_at => DateTime.now + 1.seconds)
    line2 = create(:billing_machine_quotation_line,:created_at => DateTime.now + 2.seconds)
    line3 = create(:billing_machine_quotation_line,:created_at => DateTime.now + 3.seconds)
    line4 = create(:billing_machine_quotation_line,:created_at => DateTime.now + 4.seconds)
    line3.update(:created_at => DateTime.now+5.seconds)
    lines = ::Dorsale::BillingMachine::QuotationLine.all
    expect(lines).to eq [line1, line2, line4, line3]
  end

  it "should update the total upon save" do
    quotation = create(:billing_machine_quotation_line, quantity: 10, unit_price: 10, total: 0)
    expect(quotation.total).to eq(100)
  end

  it "should update the total gracefully with invalid data" do
    quotation = create(:billing_machine_quotation_line, quantity: nil, unit_price: nil, total: 0)
    expect(quotation.total).to eq(0)
  end

end
