class Dir
  @@creation_number = 0;

  # Creates a temp dir in location and performs the supplied code block
  def self.create_tmp_dir(name, location)
    @@creation_number += 1
    pid = Process.pid # This doesn't work on some platforms, according to the docs. A better way to get it would be nice.
    random_number = Kernel.rand(1000000000).to_s # This is to avoid a possible symlink attack vulnerability in the creation of temporary files.
    complete_dir_name = "#{location}/#{name}.#{pid}.#{random_number}.#{@@creation_number}"

    yield_result = Object.new

    self.mkdir(complete_dir_name)

    # Changing dirs must be done in a block. When you call chdir normally, really weird
    # stuff starts to happen. Functions fail silently, exceptions are ignored, etc...
    self.chdir(complete_dir_name) do
      begin
        yield_result = yield
      rescue
        raise
      ensure
        FileUtils.rmtree(["#{complete_dir_name}"])
      end
    end

    return yield_result
  end
end

module Rtex

  class LatexProcessorNotFound < StandardError; end
  class GenerationError < StandardError; end

  class View

    def initialize(action_view)
      @action_view = action_view
      class << @action_view
        include RtexHelper
      end
      # Override with @options_for_rtex Hash in your controller
      @options = {
        # Run through latex first? (for table of contents, etc)
        :preprocess => false,
        # Debugging mode; raises exception with raw latex
        :debug => false,
        # Filename of pdf to generate
        :filename => "#{@action_view.controller.action_name}.pdf",
        # Option redirection for shell output (set to  '> /dev/null 2>&1' )
        :shell_redirect => nil,
        # Temporary Directory
        :tempdir => "#{File.expand_path(RAILS_ROOT)}/tmp",
        # tex command to run
        :tex_command => "pdflatex"
      }.merge(@action_view.controller.instance_eval{ @options_for_rtex } || {}).with_indifferent_access
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
        ERB.new(template, nil, '-').result(binding)
      end
      @generate ? generate_pdf(result) : result
    end

    #######
    private
    #######

    def generate_pdf(input)

      processor = @options[:tex_command]
      system_path = ENV["PATH"]

      # Check for the presence of the tex processor in the path.
      unless FileTest.executable?(processor) or
          system_path.split(":").any?{|path| FileTest.executable?(File.join(path, processor))}
        raise LatexProcessorNotFound
      end

      Dir.create_tmp_dir("rtex", @options[:tempdir]) do
        basename = "processed_rtex_file"
        texfile = File.open("#{basename}.tex", "wb")
        texfile.write(input)
        texfile.close

        tex_command = "#{processor} -interaction=nonstopmode #{texfile.path} #{@options[:shell_redirect]}"
        tex_return = ''
        tex_return = `#{tex_command}`
        tex_return = `#{tex_command}` if @options[:preprocess] # One can wonder if it matters if it's always run twice...

        if File.exists?("#{basename}.pdf")
          output_filename = if filename = @options[:filename]
            filename =~ /\.pdf$/i ? filename : "#{filename}.pdf"
          else
            @action_view.controller.action_name+'.pdf'
          end
            @action_view.controller.instance_eval do
              # The type is required to set proper content type, to allow the browser to open it. The content-type in the render method is probably no longer needed.
              send_file_headers!(:disposition => "inline", :filename=>output_filename, :type => "application/pdf", :length=>File.size("#{basename}.pdf"))
            end
          # For some reason, File.read doesn't work, hence the call using the block
          File.open("#{basename}.pdf",'rb') { |f| f.read }
        else
          raise Rtex::GenerationError, "Could not generate PDF:\n#{tex_return}"
        end
      end
    end

  end

end
