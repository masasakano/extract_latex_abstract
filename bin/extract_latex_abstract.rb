#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = Command extract_latex_abstract.rb
#
# == Summary
#
# (UNIX-style) command to extract the abstract part in LaTeX.
#
# == USAGE
#
#   % extract_latex_abstract.rb [File|< STDIN] | detex | wc
#   % extract_latex_abstract.rb [File|< STDIN] | texcount -
#
# == DESCRIPTION
#
# Extracts the abstract part in LaTeX sandwitched by begin and end, considering
#
# * After and before the \begin, \end{abstract} on the same line
# * lines with an even number of "\" preceded like \\end{abstract}
# * the commented-out lines ignored
# * Printing to the end if no \end{abstract} is found
#   
# == DISCLAIMER
#
# The variable names are pretty cryptic...
# 
# == TESTS
# 
#   % printf "%%\\\\begin{abstract}abc\n xx \\\\begin{abstract}xyz\n234\nE-N\\\\end{abstr\n" | ruby extract_latex_abstract.rb
#   xyz
#   234
#   E-N\end{abstr
#   % printf "%%\\\\begin{abstract}abc\n xx \\\\begin{abstract}xyz\n234\nE-N\\\\end{abstract}\n" | ruby extract_latex_abstract.rb
#   xyz
#   234
#   E-N
#
# == Image of the code (Twitter)
#
# [https://twitter.com/WiseBabel/status/890280430246793216]
# 
# == Copyright
# 
# Author::  Masa Sakano < info a_t wisebabel dot com >
# License:: MIT.
# Warranty:: No warranty.
# Versions:: The versions of this package follow Semantic Versioning (2.0.0) http://semver.org/
# 
a = ARGF.readlines
b = %w(begin end).map{ |i|
  r = /(?<!\\)(?:\\\\)*\\#{i}\{abstract\}/	# Excludes \\end, \\\\end, etc
  u,t = nil,nil
  y = a.find_index{ |x|
    if m = r.match(x)
      u, t = m.pre_match, m.post_match
    end
    m && /(?<!\\)(?:\\\\)*%/ !~ u	# Excludes those with preceding '%'
  }
  y ? [y,u,t] : nil	# [Index, pre_match, post_match]
}
b[0] && a[b[0][0]]=b[0][2]	# \begin{abstract} replaced with its post_match
b[1] && a[b[1][0]]=b[1][1]	# \end{abstract}   replaced with its pre_match
puts(a[b[0][0]..(b[1][0] rescue -1)]) rescue nil	# prints till the end if no \end{abstract} is found.

