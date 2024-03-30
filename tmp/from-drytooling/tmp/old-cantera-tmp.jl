
# ct.delete!(sol)
# ct.gettemperature(sol)

# function soln_report(n; newline = false)
#     if newline
#         println("")
#     end

#     println(string(
#         "Solution $(n):",
#         "\n- name ........... $(soln_name(n))",
#         "\n- thermo ......... $(soln_thermo(n))",
#         "\n- kinetics ....... $(soln_kinetics(n))",
#         "\n- transport ...... $(soln_transport(n))",
#         "\n- nAdjacent ...... $(soln_nAdjacent(n))"
#     ))
# end

# function soln_test()
#     ct_appdelete();
#     sol = Solution("gri30.yaml", "gri30", "mixture-averaged")
#     n = sol.index.solution

#     soln_report(n)
#     soln_setTransportModel(n, "ionized-gas")
#     soln_report(n, newline = true)
#     soln_del(n)
# end

# function thermo_report(n; newline = false, fractions = false)
#     if newline
#         println("")
#     end

#     println(string(
#         "Thermo $(n):",
#         "\n- nSpecies ....... $(thermo_nSpecies(n))",
#         "\n- nElements ...... $(thermo_nElements(n))",
#         "\n- Temperature .... $(thermo_temperature(n))",
#         "\n- Density ........ $(thermo_density(n))",
#         "\n- Molar density .. $(thermo_molarDensity(n))",
#         "\n- Mol. weight .... $(thermo_meanMolecularWeight(n))",
#     ));

#     if fractions
#         println("");
#         nspecies = thermo_nSpecies(n);

#         # Set all fractions randomly and normalize.
#         mrnd = rand(nspecies);
#         thermo_setMoleFractions(n, nspecies, mrnd, 1);
#         thermo_setMassFractions(n, nspecies, mrnd, 1);

#         xarr = zeros(nspecies);
#         yarr = zeros(nspecies);

#         thermo_getMoleFractions(n, nspecies, xarr);
#         thermo_getMassFractions(n, nspecies, yarr);

#         for k in 0:nspecies-1;
#             xnum = thermo_moleFraction(n, k);
#             ynum = thermo_massFraction(n, k);
            
#             @assert xarr[k+1] ≈ xnum
#             @assert yarr[k+1] ≈ ynum

#             x = @sprintf("%.6e", xnum);
#             y = @sprintf("%.6e", ynum);
#             println(" ... $(x) | $(y)")
#         end
#     end
# end

# function thermo_test()
#     ct_appdelete();
#     n = thermo_newFromFile("gri30.yaml", "gri30");
#     thermo_report(n);

#     thermo_setTemperature(n, 400.0);
#     thermo_report(n, newline = true, fractions = false);

#     thermo_setDensity(n, 10.0);
#     thermo_report(n, newline = true, fractions = false);

#     thermo_setMolarDensity(n, 10.0);
#     thermo_report(n, newline = true, fractions = true);

#     thermo_del(n);
# end

# function JuliaCanteraExample()

#     xml_file = ccall((:JL_xml_get_XML_File, CCantera),
#                      Int32, (Cstring, Int32),
#                      "gri30.xml", 0)
#     testReturn("JL_xml_get_XML_File", xml_file)


#     phase_node = ccall((:JL_xml_findID, CCantera),
#                       Int32, (Int32, Cstring),
#                       xml_file, "gri30_mix")
#     testReturn("JL_xml_findID", phase_node)


#     thermo = ccall((:JL_thermo_newFromXML, CCantera),
#                    Int32, (Int32,),
#                    phase_node)
#     testReturn("JL_thermo_newFromXML", thermo)


#     nsp = ccall((:JL_thermo_nSpecies, CCantera),
#                 Int32, (Int32,),
#                 thermo)
#     testReturn("JL_thermo_nSpecies", nsp, eq=true, value=53)


#     ret = ccall((:JL_thermo_setTemperature, CCantera),
#                 Int32, (Int32, Float64),
#                 thermo, 500.0)
#     testReturn("JL_thermo_setTemperature", ret, eq=true, value=0)


#     ret = ccall((:JL_thermo_setPressure, CCantera),
#                 Int32, (Int32, Float64),
#                 thermo, 5.0 * 101325.0)
#     testReturn("JL_thermo_setPressure", ret, eq=true, value=0)


#     ret = ccall((:JL_thermo_setMoleFractionsByName, CCantera),
#                 Int32, (Int32, Cstring),
#                 thermo, "CH4:1.0, O2:2.0, N2:7.52")
#     testReturn("JL_thermo_setMoleFractionsByName", ret, eq=true, value=0)


#     ret = ccall((:JL_thermo_equilibrate, CCantera),
#                 Int32, (Int32, Cstring, Int32, Float64, Int32, Int32, Int32),
#                 thermo, "HP", 0, 1e-9, 50000, 1000, 0);
#     testReturn("JL_thermo_equilibrate", ret, eq=true, value=0)


#     T = ccall((:JL_thermo_temperature, CCantera),
#               Float64, (Int32,),
#               thermo)
#     ret = T > 2200 && T < 2300
#     testReturn("JL_thermo_equilibrate", ret, eq=true, value=true)


#     ret = ccall((:JL_thermo_print, CCantera),
#               Int32, (Int32, Int32, Int32),
#               thermo, 1, 0)
#     testReturn("JL_thermo_print", ret, eq=true, value=0)


#     kin = ccall((:JL_kin_newFromXML, CCantera),
#               Int32, (Int32, Int32, Int32, Int32, Int32, Int32),
#               phase_node, thermo, 0, 0, 0, 0)
#     testReturn("JL_kin_newFromXML", thermo)


#     nr = ccall((:JL_kin_nReactions, CCantera),
#               UInt32, (Int32,),
#               kin)
#     testReturn("JL_kin_nReactions", nr, eq=true, value=325)


#     ret = ccall((:JL_thermo_setTemperature, CCantera),
#                 Int32, (Int32, Float64),
#                 thermo, T - 200.0)
#     testReturn("JL_thermo_setTemperature", ret, eq=true, value=0)

#     buf::String = " " ^ 50
#     ropf::Vector{Float64} = Vector{Float64}(325)

#     println("\n                   Reaction           Forward ROP\n")

#     # ATTENTION: need to declare Ptr{Void} for double*!
#     ret = ccall((:JL_kin_getFwdRatesOfProgress, CCantera),
#                 Int32, (Int32, UInt32, Ptr{Void}),
#                 kin, 325, ropf)

#     for n=1:325
#         # Here had to use Ptr{UInt8} instead of Cstring
#         ret = ccall((:JL_kin_getReactionString, CCantera),
#                     Int32, (Int32, Int32, Int32, Ptr{UInt8}),
#                     kin, n, sizeof(buf), buf)
#         rate = ropf[n]
#         #TODO Consider using Formatting
#         println("$buf $rate\n")
#     end


#     println("\n  Species    Mix diff coeff\n")
#     tran = ccall((:JL_trans_new, CCantera),
#                  Int32, (Cstring, Int32, Int32),
#                  "Mix", thermo, 0)

#     dkm::Vector{Float64} = Vector{Float64}(53)
#     ret = ccall((:JL_trans_getMixDiffCoeffs, CCantera),
#                  Int32, (Int32, Int32, Ptr{Void}),
#                  tran, 53, dkm)

#     #FIXME this should not be necessary!
#     buf = " " ^ 50

#     for k=1:nsp

#         ret = ccall((:JL_thermo_getSpeciesName, CCantera),
#                      Int32, (Int32, UInt32, UInt32, Ptr{UInt8}),
#                      thermo, k, sizeof(buf), buf)
#          frac = dkm[k]
#          #TODO Consider using Formatting
#          println("$buf $frac\n")
#     end


#     ret = ccall((:JL_thermo_setTemperature, CCantera),
#                 Int32, (Int32, Float64),
#                 thermo, 1050.0)
#     testReturn("JL_thermo_setTemperature", ret, eq=true, value=0)


#     ret = ccall((:JL_thermo_setPressure, CCantera),
#                 Int32, (Int32, Float64),
#                 thermo, 5.0 * 101325.0)
#     testReturn("JL_thermo_setPressure", ret, eq=true, value=0)


#     ret = ccall((:JL_thermo_setMoleFractionsByName, CCantera),
#                 Int32, (Int32, Cstring),
#                 thermo, "CH4:1.0, O2:2.0, N2:7.52")
#     testReturn("JL_thermo_setMoleFractionsByName", ret, eq=true, value=0)



#     reactor = ccall((:JL_reactor_new, CCantera),
#                     Int32, (Int32,),
#                     5)


#     net = ccall((:JL_reactornet_new, CCantera),
#                     Int32, ())


#     ret = ccall((:JL_reactor_setThermoMgr, CCantera),
#                 Int32, (Int32, Int32),
#                 reactor, thermo)
#     testReturn("JL_reactor_setThermoMgr", ret, eq=true, value=0)


#     ret = ccall((:JL_reactor_setKineticsMgr, CCantera),
#                 Int32, (Int32, Int32),
#                 reactor, kin)
#     testReturn("JL_reactor_setKineticsMgr", ret, eq=true, value=0)


#     ret = ccall((:JL_reactornet_addreactor, CCantera),
#                 Int32, (Int32, Int32),
#                 net, reactor)
#     testReturn("JL_reactornet_addreactor", ret, eq=true, value=0)


#     println("\ntime       Temperature\n");

#     t::Float64 = 0.0

#     while t < 0.1 && ret == 0
#         T = ccall((:JL_reactor_temperature, CCantera),
#                   Float64, (Int32,),
#                   reactor)

#         t = ccall((:JL_reactornet_time, CCantera),
#                   Float64, (Int32,),
#                   net)

#         println("$t  $T")


#         ret = ccall((:JL_reactornet_advance, CCantera),
#                     Int32, (Int32, Float64),
#                     net, t + 5.0e-03)
#         testReturn("JL_reactornet_advance", ret, eq=true, value=0)
#     end


#     ret = ccall((:JL_ct_appdelete, CCantera), Int32, ())
#     testReturn("JL_ct_appdelete", ret, eq=true, value=0)

# end
