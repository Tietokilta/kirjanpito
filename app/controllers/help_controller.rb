class HelpController < ApplicationController

	def index
		@pages = {
			'käytäntö' => "Käytännöt", 
			'kirjanpito' => "Yleistä kirjanpidosta", 
			'rahastonhoitajan-vuosi' => "Rahastonhoitajan vuosi Tietokillassa"
			}
	end

end
