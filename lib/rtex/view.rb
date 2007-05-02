# Example Registration
# 
#   ActionView::Base::register_template_handler 'rtex', RTexView

module RTex
  
  class View

    def initialize(action_view)
      @action_view = action_view
    end

    def render(template, local_assigns)
		  unless @action_view.controller.headers["Content-Type"] == 'application/pdf'
			  @generate = true
				@action_view.controller.headers["Content-Type"] = 'application/pdf'
			end
      assigns = @action_view.assigns.dup
    
      if content_for_layout = @action_view.instance_variable_get("@content_for_layout")
        assigns['content_for_layout'] = content_for_layout
      end
      result = @action_view.instance_eval do
			  assigns.each do |key,val|
			    instance_variable_set "@#{key}", val
		    end
			  local_assigns.each do |key,val|
		  		class << self; self; end.send(:define_method,key){ val }
				end
        ERB.new(template).result(binding)
      end
      result
      @generate ? generate_pdf('test',result) : result
    end

    #######
    private
    #######
  
    def generate_pdf(basename, input)
      temp = Tempfile.new('rtex')
      temp.binmode # For Windows
      temp.puts input
      temp.close
      Dir.chdir(File.dirname temp.path) do
         system "pdflatex --interaction=nonstopmode #{temp.path}"
      end
      pdfpath = temp.path.sub(/\..*?$/,'')+'.pdf'
      if @action_view.controller.instance_eval{ @raise_tex }
        raise File.read(temp.path)
      end
      temp.unlink
      if File.exists?(pdfpath)
        result = File.open(pdfpath,'rb'){ |f| f.read }
        output_filename = @filename ? "#{@filename}.pdf" : @action_view.controller.action_name+'.pdf'
        @action_view.controller.instance_eval do
          send_file_headers!(:filename=>output_filename,:length=>File.size(pdfpath))
        end
        File.unlink pdfpath
        result
      else
        raise RTex::GenerationError, "Could not generate PDF"      
      end
    end

  end
  
end