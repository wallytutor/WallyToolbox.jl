##############################################################################
# READERS
##############################################################################

export read_csv
export read_janaf

##############################################################################
# CSV
##############################################################################

function read_csv(fname;
        sep::Char = ',',
        comments = true,
        comment_char = '#'
    )::DataFrame
	data, header = readdlm(fname, sep; header=true, comments, comment_char)
	return dlm2df(data, header)
end

##############################################################################
# JANAF Tables (not Data Science but why not!?)
##############################################################################

function read_janaf(fname; verbose=true)
    verbose && @warn("""\
        This function is fragile, please verify the downloaded JANAF table \
        you are trying to read is well formed; a common issue when copying \
        data is the presence of some spaces where tabs should be.
    """)
	opts = (skipstart=2, comments=true, header=true)
	data, header = readdlm(fname, '\t'; opts...)
	return dlm2df(parse_matrix_with_nan(data), header)
end

##############################################################################
# Internals
##############################################################################

# This snippet happens all the time when using DelimitedFiles/DataFrames.
dlm2df(data, header) = DataFrame(data, vec(Symbol.(header)))


function try_parse_number(v, target)
    # It is already a number? Got it!
	isa(v, Number) && return v

    # Try only once here:
	parsed = tryparse(target, v)
	
    # It is not a number, then NaN-it!
	isnothing(parsed) && return NaN

    # It's a number!
	return parsed
end


function parse_vector_with_nan(data; target = Float64)
	return [try_parse_number(x, target) for x in data]
end


function parse_matrix_with_nan(data)
	return hcat([parse_vector_with_nan(row) for row in eachcol(data)]...)
end

##############################################################################
# EOF
##############################################################################