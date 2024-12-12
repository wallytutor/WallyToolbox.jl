module ElmerMultiphysics

using DataFrames
using DelimitedFiles

export read_line_data

"Read data table stored by `SaveLine` solver."
function read_line_data(case, linename)
	path_data = joinpath(case, "$(linename).dat")
	path_cols = joinpath(case, "$(linename).dat.names")

	columns = get_line_names(path_cols)
	data = readdlm(path_data)

	return DataFrame(data, columns)
end

function get_line_names(fpath)
	started = false
	columns = String[]

	fmt(s) = replace(s |> strip |> lowercase, " "=>"_")
	
	open(fpath) do fp
		for line in readlines(fp)
			if startswith("Data on different columns", line)
				started = true
				continue
			end
			
			!started && continue

			push!(columns, fmt(split(line, ":")[end]))
		end
		
	end

	return columns
end

end # (ElmerMultiphysics)