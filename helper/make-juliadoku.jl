begin
   using BoltzmannMachines
   io = IOBuffer()
   context = IOContext(io)
   for name in names(BoltzmannMachines)
      latexname = replace(String(name), "_" => "\\_")
      x = Main.eval(Meta.parse("@doc "* String(name)))
      if !startswith(string(x), "No documentation found") &&
            x != Main.eval(Meta.parse("@doc Array"))
         println(io, "\\subsection*{$latexname} \\phantomsection \\label{bms_$name}")
         show(context, "text/latex", x)
         println(io, "\\noindent\\rule{\\textwidth}{1pt}")
         print(io, "%======================================================\n")
      end
   end
   output = String(take!(io))

   output = replace(output, r"\\section" => "\\paragraph*")
   output = replace(output, r"\\href\{@ref\}\{([^}]+)\}" => s"\1")
   open(pwd() * "/appendix/BoltzmannMachines_Doku.tex", "w") do io
      write(io, output)
   end
end
