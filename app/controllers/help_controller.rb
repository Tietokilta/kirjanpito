class HelpController < ApplicationController

	def index
		@pages = {
			'käytäntö' => "Käytännöt", 
			'kirjanpito' => "Yleistä kirjanpidosta", 
			'rahastonhoitajan-vuosi' => "Rahastonhoitajan vuosi Tietokillassa"
			}
	end
	
	def kirjanpito
	  @pagesarray = [
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
	  if !params[:page].nil?
	   @previous = params[:page].to_i - 1
	   if @previous < 0
	     @previous = -1
	   end
	   @current = params[:page].to_i
	   if (@current < 0) || (@current > (@pagesarray.size - 1))
	     @current = -1
	   end
	   @next = params[:page].to_i + 1
	   if @next >= @pagesarray.size
	     @next = -1
	   end
	  end
  end

end
