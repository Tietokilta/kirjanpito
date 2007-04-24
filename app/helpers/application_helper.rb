# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry, "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end
end

# TODO: SystemStackError, caused by some stupid bug in ruby or rails
#
# module ActionView
#   module Helpers
#      module NumberHelper
#         def number_to_currency_with_euro(number, options = {})
#            defaults = {:unit => ''}
#            s = nil
#            s = number_to_currency_without_euro(number, defaults.merge(options))
#            s << ' &euro;' unless options[:unit]
#         end
#         alias_method_chain :number_to_currency, :euro
#      end
#   end
# end
