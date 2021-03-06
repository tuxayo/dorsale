Given(/^an existing quotation$/) do
  @quotation = create(:billing_machine_quotation, id_card: @id_card, customer: @customer)
  @quotation.lines.create(quantity: 1, unit_price: 9.99)
end

Given(/^(\d+) existing quotations$/) do |nb|
  create_list(:billing_machine_quotation, nb.to_i, id_card: @id_card)
end

Given(/^an existing emtpy quotation$/) do
  @quotation = create(:billing_machine_quotation, label: nil, customer: nil, id_card: @id_card)
end

Given(/^an existing quotation with a "(.*?)"% VAT rate$/) do |arg1|
  @quotation = create(:billing_machine_quotation, id_card: @id_card, vat_rate: arg1)
end

Given(/^(\d+) associated documents to this quotation$/) do |arg1|
  @document1 = create(:alexandrie_attachment, attachable: @quotation)
  @document2 = create(:alexandrie_attachment, attachable: @quotation)
end

When(/^he changes the quotation VAT rate to "(.*?)"$/) do |arg1|
  fill_in 'quotation_vat_rate', with: arg1
end

When(/^the user goes to the quotations page$/) do
  visit dorsale.billing_machine_quotations_path
end

When(/^the quotation line shows the right date$/) do
  page.should have_selector '.date' , text: I18n.l(@quotation.date)
end

When(/^the quotation line shows the right traking\-id$/) do
  page.should have_selector '.tracking_id' , text: @quotation.tracking_id
end

When(/^the quotation line shows the right customer's name$/) do
  page.should have_selector '.customer_name', text: @customer.name
end

When(/^the quotation line shows the right total\-duty value$/) do
  page.should have_selector '.total_duty' , text: "9,99 €"
end

When(/^the quotation line shows the right all taxes value$/) do
  page.should have_selector '.total_all_taxes' , text: "11,99 €"
end

When(/^the user goes to the quotation details$/) do
  visit dorsale.billing_machine_quotation_path(@quotation)
end

When(/^he fills an quotation line with "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/) do |arg1, arg2, arg3, arg4|
  within(all('.quotation-line').last()) do
    find(:css,"input.line-label").set(arg1)
    find(:css,"input.line-quantity").set arg2
    find(:css,"input.line-unit").set arg3
    find(:css,"input.line-unit_price").set arg4
  end
end

When(/^he creates a new quotation$/) do
  find(".link_create").click
end

When(/^he fills the reference and the date$/) do
  fill_in 'quotation_label', with: @label = 'My reference'
  fill_in 'quotation_date', with: @date = '01/01/2014'
  select @payment_term.label
  fill_in 'quotation_comments', with: "I-am-a-comment"
end

When(/^he saves the quotation$/) do
  find("[type=submit]").click
end

When(/^he goes on the edit page of the quotation$/) do
  visit dorsale.edit_billing_machine_quotation_path(@quotation)
end

When(/^changes the quotation label$/) do
  @new_label=  @quotation.label + " Edited"
  fill_in 'quotation_label', with: @new_label
end

When(/^he delete a document$/) do
  all(".link_delete").first.click
end

Then(/^the document is not in the quotation details$/) do
  visit dorsale.billing_machine_quotation_path(@quotation)
  page.should have_link 'pdf.pdf', count: 1
end

Then(/^the quotation new line total is "(.*?)"$/) do |arg1|
 page.should have_selector '.quotation-line .line-total', text: arg1
end

Then(/^the existing quotation line total is "(.*?)"$/) do |arg1|
  page.should have_selector '.quotation-line .line-total', text: arg1
end

Then(/^a message signals the success of the quotation update$/) do
  page.should have_selector '.alert-success'
end

Then(/^the quotation's label has changed$/) do
  visit dorsale.edit_billing_machine_quotation_path(@quotation)
  page.should have_field('quotation_label', with: @new_label)
end

Then(/^it's added to the quotation list$/) do
  page.should have_selector '.quotation .date', text: @date
  @quotation = ::Dorsale::BillingMachine::Quotation.unscoped.order(:id).last
  page.should have_selector '.quotation .tracking_id', text: @quotation.tracking_id
  page.should have_selector '.quotation .customer_name', text: @customer.name
  page.should have_selector '.quotation .total_duty', text: '200,00 €'
end

Then(/^he can see all the quotation informations$/) do
  expect(page).to have_selector '.quotation-label', @quotation.label

  expect(page).to have_selector ".quotation-expires_at", "21/12/2012"
end

Then(/^the quotation default date is set to today's date\.$/) do
  page.should have_field('quotation_date', with: I18n.l(Date.today))
end

Then(/^he should see (\d+) quotations$/) do |arg1|
  page.should have_selector '.quotation', count: arg1
end

Then(/^the quotation is displayed correctly$/) do
  expect(page).to have_selector '.tracking_id', @quotation.tracking_id
end

Then(/^the quotation total duty is "(.*?)"$/) do |arg1|
  page.should have_selector '.total #quotation-total_duty', text: arg1
end

Then(/^the quotation VAT due is "(.*?)"$/) do |arg1|
  page.should have_selector '.total #quotation-vat_amount', text: arg1
end

Then(/^the quotation total all taxes included is "(.*?)"$/) do |arg1|
  page.should have_selector '.total #quotation-total_all_taxes', text: arg1
end

Then(/^a message signals the success of the quotation creation$/) do
  page.should have_selector '.alert-success'
end

Then(/^the quotation VAT rate is "(.*?)"$/) do |arg1|
  page.should have_field('quotation_vat_rate', with: arg1)
end

Then(/^he will see links to the documents$/) do
  page.should have_link 'pdf.pdf', count: 2
end

Then(/^the quotation informations are visible on the quotation details$/) do
  @quotation = ::Dorsale::BillingMachine::Quotation.unscoped.order(:id).last
  visit dorsale.billing_machine_quotation_path(@quotation)
  expect(page).to have_content @payment_term.label
  expect(page).to have_content "I-am-a-comment"
end

Given(/^a bunch of existing quotations$/) do
  c1 = create(:customer_vault_corporation, name: 'Bidule')
  c2 = create(:customer_vault_corporation, name: 'Machin')
  c3 = create(:customer_vault_corporation, name: 'Chose')

  i1 = create(:customer_vault_individual, first_name: 'Oh')
  i2 = create(:customer_vault_individual, first_name: 'Ah')
  i3 = create(:customer_vault_individual, first_name: 'Eh')

  create(:billing_machine_quotation, id_card: @id_card, customer: c1, date: Date.today)
  create(:billing_machine_quotation, id_card: @id_card, customer: c2, date: Date.today)
  create(:billing_machine_quotation, id_card: @id_card, customer: c3, date: Date.today)
  create(:billing_machine_quotation, id_card: @id_card, customer: c1, date: Date.today - 2.days)

  create(:billing_machine_quotation, id_card: @id_card, customer: i1, date: Date.today - 3.days)
  create(:billing_machine_quotation, id_card: @id_card, customer: i2, date: Date.today - 3.days)
  create(:billing_machine_quotation, id_card: @id_card, customer: i3, date: Date.today - 3.days)
end

Then(/^only the quotations of this customer do appear$/) do
  expect(page).to have_selector(".customer_name", text: 'Bidule', count: 2)
end

Then(/^only the quotations of today do appear$/) do
  expect(page).to have_selector(".quotation", count: 3)
end

When(/^he fill the quotation expiry$/) do
  fill_in :quotation_expires_at, with: "21/12/2012"
end

Given(/^existing "(.*?)" quotations with "(.*?)" amount$/) do |n, amount|
  n.to_i.times do
    quotation = create(:billing_machine_quotation)
    quotation_line = create(:billing_machine_quotation_line,
      quotation: quotation,
      quantity: 1,
      unit_price: amount,
      total: nil
    )
  end
end
