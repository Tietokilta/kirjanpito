# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry, "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end
end
module ActionView
  module Helpers
    module NumberHelper
      def number_to_euro(number)
        defaults = {:unit => '', :delimiter => '', :separator => ','}
        s = number_to_currency(number, defaults)
        return s
      end
    end
  end
end

