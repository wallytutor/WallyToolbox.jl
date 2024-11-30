#############################################################################
# PLOTTING
#############################################################################

using CairoMakie

##############################################################################
# CONSTANT AND CONFIGURATION
##############################################################################

export WALLYMAKIETHEME

const WALLYMAKIETHEME = Theme(
	fontsize = 10,

	# https://juliagraphics.github.io/Colors.jl/stable/namedcolors/
	palette = (
		color = [
			# Start with classy black...
			:black,

			# Classic colors...
			:red, 
			:blue,
			:green,

			# Degraded classics...
			:tomato1,
			:slateblue1,
			:chartreuse1,
		],
	),

    Axis = (
		# Background:
		backgroundcolor = :gray98,
	
		# Grids:
        xgridcolor = :gray20,
        ygridcolor = :gray20,
		xgridstyle = :dot,
		ygridstyle = :dot,
		xgridwidth = 0.8,
		ygridwidth = 0.8,

		# Spines:
        leftspinevisible   = true,
        rightspinevisible  = true,
        bottomspinevisible = true,
        topspinevisible    = true,
    )
)

##############################################################################
# STRUCTURE
##############################################################################

#############################################################################
# EOF
#############################################################################