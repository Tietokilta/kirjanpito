# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry, "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end

	def sort_td_class_helper(param)
		result = 'class="sortup"' if params[:sort] == param
		result = 'class="sortdown"' if params[:sort] == param + " desc"
		return result
	end

	def sort_link_helper(text, param)
		key = param
		key += " desc" if params[:sort] == param
		options = {
			:url => {:action => 'list', :params => params.merge({:sort => key, :page => nil})},
			:update => 'table',
			:before => "Element.show('spinner')",
			:success => "Element.hide('spinner')"
		}
		html_options = {
			:title => "Sort by this field",
			:href => url_for(:action => 'list', :params => params.merge({:sort => key, :page => nil}))
		}
		link_to_remote(text, options, html_options)
	end

			


end
ActiveRecord::Base.after_save :restore_date_format
ActiveRecord::Base.before_save :change_date_format

module ActiveRecord
			
	class Base
		def restore_date_format
			ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = '%d.%m.%Y'
		end
		def change_date_format
			#@prevformat = ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default]
			ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = "%Y-%m-%d"
		end
	end
end
