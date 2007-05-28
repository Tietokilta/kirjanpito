class HelpController < ApplicationController
	before_filter :pages
	def pages
		@pages = {
		  'kayttoohje' => "Käyttöohjeet",
			'käytäntö' => "Käytännöt", 
			'kirjanpito' => "Yleistä kirjanpidosta", 
			'rahastonhoitajan-vuosi' => "Rahastonhoitajan vuosi Tietokillassa"
			}
	end
	
	def kirjanpito
	  @subpages = [
	    {'esittely' => "Kirjanpito"},
      {'kirjaamisperiaatteita' => "Kirjaamisperiaatteita"},
      {'kirjanpitotapa' => "Hyvä kirjanpitotapa"},
      {'tilikausi' => "Tilikausi"},
      {'liiketapahtumat' => "Liiketapahtumat"},
      {'tilit' => "Tilit"},
      {'tiliryhmät' => "Tiliryhmät"},
      {'rahoitustilit' => "Tiliryhmät > Rahoitustilit"},
      {'menotilit' => "Tiliryhmät > Menotilit"},
      {'tulotilit' => "Tiliryhmät > Tulotilit"},
      {'tilinpäätöksen_tilit' => "Tiliryhmät > Tilinpäätöksen tilit"},
      {'tilikauden_vaiheet' => "Tilikauden kirjanpidon vaiheet"},
      {'hankintamenon_jaksottaminen' => "Hankintamenon jaksottaminen"},
      {'tositteet' => "Tositteet"},
      {'tililuettelo' => "Tililuettelo"}
	  ]

		params[:page] = 0 unless params[:page]
		page = params[:page].to_i

		@previous = page - 1
		@previous = nil if @previous < 0

		@current = page
		@current = nil if (@current < 0) || (@current > (@subpages.size - 1))

		@next = page + 1
		@next = nil if @next >= @subpages.size
	
	end

	def kayttoohje
	  @subpages = [
	    {'kayttoohje' => "Käyttöohjeet"},
	    {'tilikaudet' => "Tilikaudet"},
	    {'tilien_kaytto' => "Tilit"},
	    {'budjetit' => "Budjetit"},
	    {'tilitapahtumat' => "Tilitapahtumat"},
	    {'käyttäjät' => "Käyttäjät"}
	  ]

		params[:page] = 0 unless params[:page]
		page = params[:page].to_i

		@previous = page - 1
		@previous = nil if @previous < 0

		@current = page
		@current = nil if (@current < 0) || (@current > (@subpages.size - 1))

		@next = page + 1
		@next = nil if @next >= @subpages.size
	
	end

end
