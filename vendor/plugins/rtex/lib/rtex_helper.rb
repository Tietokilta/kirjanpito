module RtexHelper

  BS        = "\\\\"
  BACKSLASH = "#{BS}textbackslash{}"
  HAT       = "#{BS}textasciicircum{}"
  TILDE     = "#{BS}textasciitilde{}"

  def latex_escape(s)
    s.to_s.
      gsub(/([{}])/, "#{BS}\\1").
      gsub(/\\/, BACKSLASH).
      gsub(/([_$&%#])/, "#{BS}\\1").
      gsub(/\^/, HAT).
      gsub(/~/, TILDE)
  end
  alias :l :latex_escape

end
