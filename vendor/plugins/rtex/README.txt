= RTex Template Engine

A template engine allowing the inclusion of ERB-enabled TeX template files.

The resulting tex is passed through pdflatex and generates a PDF file for the user.

== Example Usage

In the controller, something like:

  def mypdf
    @time = Time.now
  end

In the view (mypdf.rtex)

  \documentclass[10pt]{article}
  \begin{document}

  The time is <%= @time %>.

  \end{document}

The mypdf action will now generate "mypdf.pdf" for the user.

You can use the l (escape_latex) helper, as well:

  <%=l @something %>

== Configuring

You can configure Rtex by using an @options_for_rtex hash in your controllers.

Here are a few options:

:filename (default: action_name.pdf)
  Filename of PDF to generate

:debug (default: false)
  Debugging mode; raises exception with raw latex

:tempdir (default: RAILS_ROOT/tmp)
  Temporary Directory

:preprocess (default: false)
  Run through latex first (for TOCs, etc)

:shell_redirect (default: nil)
  Optional redirection for shell output (set to  '> /dev/null 2>&1' on *NIX, perhaps)

:tex_command (default: pdflatex)
  TeX command to run

If you need to pass command line parameters to the tex_command, you can do something like this:
  :tex_command => "xelatex --papersize letter"

Note: If you're using the same settings for @options_for_rtex often, you might want to
put your assignment in a before_filter (perhaps overriding :filename, etc in your actions).

== Problems

Layouts are currently not supported; for the moment use header and footer partials.
