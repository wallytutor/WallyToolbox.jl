##############################################################################
# MANAGERS
##############################################################################

export transport_pipe
export cooled_crushing

#############################################################################
# Model options managers
#############################################################################

"Manage use of `TransportPipeline` with different models."
function transport_pipe(product, temp_out, temp_env, glob_htc)
    verbose = false

    function target_pipeline()
        return TransportPipeline(; model = :TARGET_EXIT_TEMP, verbose,
            product, temp_out)
    end

    function simul_pipeline()
        temp_out = isnothing(temp_out) ? product.T : temp_out

        pipe = TransportPipeline(; model = :USING_GLOBAL_HTC, verbose,
            product, temp_out, glob_htc, temp_env)

        temp_out = pipe.product.T
        return pipe, temp_out
    end

    pipe = isnothing(glob_htc) ? target_pipeline() : let
        pipe, temp_out = simul_pipeline()
        pipe
    end

    return pipe, temp_out
end

"Manage use of `CooledCrushingMill` with different models."
function cooled_crushing(; product, coolant, power, temp_out, temp_cru,
                           glob_htc, α = 1.0e-04)
    verbose = false

    function target_pipeline()
        return CooledCrushingMill(; model = :TARGET_COOLANT_TEMP, verbose,
            product, coolant, power, temp_out)
    end

    function simul_pipeline()
        temp_out = isnothing(temp_out) ? coolant.T : temp_out
        temp_cru = isnothing(temp_cru) ? product.T : temp_cru
        
        pipe = CooledCrushingMill(; model = :USING_GLOBAL_HTC, verbose, 
            product, coolant, power, temp_out, glob_htc, temp_cru)

        temp_out = α * pipe.coolant.T + (1-α) * temp_out
        temp_cru = α * pipe.product.T + (1-α) * temp_cru
        
        # temp_out = pipe.coolant.T
        # temp_cru = pipe.product.T
        
        return pipe, temp_out, temp_cru
    end

    pipe = isnothing(glob_htc) ? target_pipeline() : let
        pipe, temp_out, temp_cru = simul_pipeline()
        pipe
    end

    return pipe, temp_out, temp_cru
end

##############################################################################
# EOF
##############################################################################