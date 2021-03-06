module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByPaymentStatus < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          table_name = query.model.table_name

          if @value == "paid"
            return query.where("#{table_name}.paid = ?", true)
          elsif @value == "unpaid"
            return query.where("#{table_name}.paid = ?", false)
          elsif @value == "pending"
            return query.where("#{table_name}.paid = ? and #{table_name}.due_date >= ?", false, Date.today)
          elsif @value == "late"
            return query.where("#{table_name}.paid = ? and (#{table_name}.due_date < ? or #{table_name}.due_date is null)", false, Date.today)
          else
            return query
          end
        end
      end
    end
  end
end
