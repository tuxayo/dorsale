module Dorsale
  module Flyboy
    module SmallData
      class FilterForTasks < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          'status' => FilterStrategyByDone.new("tasks")
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "tasks"
        end
      end
    end
  end
end
