require 'rtex_view'

ActionView::Base::register_template_handler 'rtex', Rtex::View
