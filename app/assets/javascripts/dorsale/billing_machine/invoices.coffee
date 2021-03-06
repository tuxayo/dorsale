$(document).on "ready page:load", ->
  if ($('#invoice.edit').size() > 0)
    sum_line = (line) ->
      q = line.find('input.line-quantity').val().replace(',', '.')
      up = line.find('input.line-unit_price').val().replace(',', '.')
      total =  q * up

    update_line_total = (line)->
      total = sum_line(line)
      display_euros(total, line.find('.line-total'))

    update_total = ->
      total_duty = 0
      vat_rate = $('#invoice_vat_rate').val().replace(',', '.')
      advance = $('#invoice_advance').val().replace(',', '.')

      $('.invoice-line').each (index, element)->
          remove_me = $(element).find('.remove-line input[type="hidden"]').val()
          total_duty += sum_line $(element) if remove_me == 'false'
      vat_amount = vat_rate * total_duty / 100.0

      display_euros(total_duty, $('#invoice-total_duty'))
      display_euros(vat_amount, $('#invoice-vat_amount'))
      display_euros(vat_amount+total_duty, $('#invoice-total_all_taxes'))
      display_euros(vat_amount+total_duty-advance, $('#invoice-balance'))

    # Set listener on inputs
    $('#invoice-lines').on 'input', 'input.line-quantity, input.line-unit_price', (event) ->
      update_line_total $(event.currentTarget).parents('.invoice-line')
      update_total()
    $('#invoice').on 'input', 'input#invoice_vat_rate, input#invoice_advance', (event) ->
       update_total()
    $('#invoice').on 'cocoon:after-remove', (event) ->
       update_total()

    # Update values on page loading
    $('.invoice-line').each (index, element)->
      update_line_total $(element)
    update_total()
