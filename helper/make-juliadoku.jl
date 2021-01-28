function writelatexdocu(pkg, labelprefix, outputfile)
   io = IOBuffer()
   context = IOContext(io)
   lastname = names(pkg)[end]
   for name in names(pkg)
      latexname = replace(String(name), "_" => "\\_")
      x = Main.eval(Meta.parse("@doc "* String(name)))
      if !startswith(string(x), "No documentation found") &&
            x != Main.eval(Meta.parse("@doc Array"))
         println(io, "\\subsection*{$latexname} \\phantomsection \\label{$(labelprefix)_$(name)}")
         show(context, "text/latex", x)
         if name != lastname
         println(io, "\\noindent\\rule{\\textwidth}{1pt}")
            print(io, "%======================================================\n")
         end
      end
   end
   output = String(take!(io))
   output = replace(output, r"\\texttt\{([^}]+)([!.])([^}]+)\}" => s"\\texttt{\1\2\\allowbreak \3}")
   output = replace(output, r"\\section" => "\\paragraph*")
   output = replace(output, r"\\href\{@ref\}\{([^}]+)\}" => s"\1")
   output = replace(output, "}/" => "}\\slash ")
   open(pwd() * "/appendix/$outputfile", "w") do io
      write(io, output)
   end
end


using BoltzmannMachines
using BoltzmannMachinesPlots
writelatexdocu(BoltzmannMachines, "bms", "BoltzmannMachines_Doku.tex")
writelatexdocu(BoltzmannMachinesPlots, "bmplots", "BoltzmannMachinesPlots_Doku.tex")