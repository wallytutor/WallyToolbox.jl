" Vim syntax file
"
" Language:    FreeFem++
" Maintainer:  Richard Michel <Richard.Michel@lepmi.inpg.fr>
" Contributor: Walter Dal'Maz Silva <walter.dalmazsilva.manager@gmail.com>
" Last Change: 2023 Dec 22 (for FreeFem++ v4.13)
"
" Note: this file was formatted and set to work only with recent versions of
" Vim, and more specifically with Neovim. It no longer tests for version number
" and was only tested with Neovim under Windows.
"
" Place this file under your Neovim installation directory (assuming portable,
" for installed version search on the web) in `share\nvim\runtime\syntax\`. If
" the root `share\nvim\runtime\` does not have a `filetype.vim`, then create a
" file and add the following lines (without starting `"`):
"
" au BufRead,BufNewFile *.edp                set filetype=edp
" au BufRead,BufNewFile *.idp                set filetype=edp

" -----------------------------------------------------------------------------
" Do we have the current syntax?
" -----------------------------------------------------------------------------

if exists("b:current_syntax")
  finish
endif

" -----------------------------------------------------------------------------
" Read the Cpp syntax to start with
" -----------------------------------------------------------------------------

runtime! syntax/cpp.vim
unlet b:current_syntax

" -----------------------------------------------------------------------------
" FF++ extensions
" -----------------------------------------------------------------------------

syn keyword ffBoolean            false
syn keyword ffBoolean            true

syn keyword ffConstantEF         P0
syn keyword ffConstantEF         P0edge
syn keyword ffConstantEF         P0VF
syn keyword ffConstantEF         P1
syn keyword ffConstantEF         P1b
syn keyword ffConstantEF         P1dc
syn keyword ffConstantEF         P1nc
syn keyword ffConstantEF         P2
syn keyword ffConstantEF         P2b
syn keyword ffConstantEF         P2dc
syn keyword ffConstantEF         P2h
syn keyword ffConstantEF         RT0
syn keyword ffConstantEF         RT0Ortho
syn keyword ffConstantEF         RTmodif

syn keyword ffConstantNum        i
syn keyword ffConstantNum        pi

syn keyword ffConstantQF         qf1pE
syn keyword ffConstantQF         qf1pElump
syn keyword ffConstantQF         qf1pT
syn keyword ffConstantQF         qf1pTlump
syn keyword ffConstantQF         qf2pE
syn keyword ffConstantQF         qf2pT
syn keyword ffConstantQF         qf2pT4P1
syn keyword ffConstantQF         qf3pE
syn keyword ffConstantQF         qf5pT
syn keyword ffConstantQF         qf7pT
syn keyword ffConstantQF         qf9pT

syn keyword ffConstantSolver     CG
syn keyword ffConstantSolver     Cholesky
syn keyword ffConstantSolver     Crout
syn keyword ffConstantSolver     GMRES
syn keyword ffConstantSolver     LU
syn keyword ffConstantSolver     UMFPACK

syn keyword ffException          catch
syn keyword ffException          throw
syn keyword ffException          try

syn keyword ffFunctionField      average
syn keyword ffFunctionField      jump
syn keyword ffFunctionField      mean
syn keyword ffFunctionField      otherside

syn keyword ffFunctionDiff       dn
syn keyword ffFunctionDiff       dx
syn keyword ffFunctionDiff       dxx
syn keyword ffFunctionDiff       dxy
syn keyword ffFunctionDiff       dy
syn keyword ffFunctionDiff       dyx
syn keyword ffFunctionDiff       dyy
syn keyword ffFunctionDiff       dz

syn keyword ffFunctionFE         interpolate

syn keyword ffFunctionInt        int1d
syn keyword ffFunctionInt        int2d
syn keyword ffFunctionInt        intalledges
syn keyword ffFunctionInt        on

syn keyword ffFunctionMath       abs
syn keyword ffFunctionMath       acos
syn keyword ffFunctionMath       acosh
syn keyword ffFunctionMath       arg
syn keyword ffFunctionMath       asin
syn keyword ffFunctionMath       asinh
syn keyword ffFunctionMath       atan
syn keyword ffFunctionMath       atan2
syn keyword ffFunctionMath       atanh
syn keyword ffFunctionMath       ceil
syn keyword ffFunctionMath       conj
syn keyword ffFunctionMath       cos
syn keyword ffFunctionMath       cosh
syn keyword ffFunctionMath       exp
syn keyword ffFunctionMath       floor
syn keyword ffFunctionMath       imag
syn keyword ffFunctionMath       log
syn keyword ffFunctionMath       log10
syn keyword ffFunctionMath       max
syn keyword ffFunctionMath       min
syn keyword ffFunctionMath       norm
syn keyword ffFunctionMath       polar
syn keyword ffFunctionMath       pow
syn keyword ffFunctionMath       sin
syn keyword ffFunctionMath       sinh
syn keyword ffFunctionMath       sqrt
syn keyword ffFunctionMath       tan
syn keyword ffFunctionMath       tanh
syn keyword ffFunctionMath       randinit
syn keyword ffFunctionMath       randint31
syn keyword ffFunctionMath       randint32
syn keyword ffFunctionMath       randreal1
syn keyword ffFunctionMath       randreal2
syn keyword ffFunctionMath       randreal3
syn keyword ffFunctionMath       randres53

syn keyword ffFunctionMatrix     set

syn keyword ffFunctionMesh       adaptmesh
syn keyword ffFunctionMesh       buildmesh
syn keyword ffFunctionMesh       buildmeshborder
syn keyword ffFunctionMesh       checkmovemesh
syn keyword ffFunctionMesh       emptymesh
syn keyword ffFunctionMesh       movemesh
syn keyword ffFunctionMesh       readmesh
syn keyword ffFunctionMesh       savemesh
syn keyword ffFunctionMesh       splitmesh
syn keyword ffFunctionMesh       square
syn keyword ffFunctionMesh       triangulate
syn keyword ffFunctionMesh       trunc

syn keyword ffFunctionPara       broadcast
syn keyword ffFunctionPara       processor

syn keyword ffFunctionPlot       plot

syn keyword ffFunctionSolver     BFGS
syn keyword ffFunctionSolver     convect
syn keyword ffFunctionSolver     EigenValue
syn keyword ffFunctionSolver     LinearCG
syn keyword ffFunctionSolver     LinearGMRES
syn keyword ffFunctionSolver     Newton
syn keyword ffFunctionSolver     NLCG

syn keyword ffFunctionSystem     assert
syn keyword ffFunctionSystem     clock
syn keyword ffFunctionSystem     dumptable
syn keyword ffFunctionSystem     exec
syn keyword ffFunctionSystem     exit

syn keyword ffGlobal             area
syn keyword ffGlobal             cin
syn keyword ffGlobal             cout
syn keyword ffGlobal             cerr
syn keyword ffGlobal             HaveUMFPACK
syn keyword ffGlobal             hTriangle
syn keyword ffGlobal             label
syn keyword ffGlobal             lenEdge
syn keyword ffGlobal             N
syn keyword ffGlobal             NoUseOfWait
syn keyword ffGlobal             nTonEdge
syn keyword ffGlobal             nuEdge
syn keyword ffGlobal             nuTriangle
syn keyword ffGlobal             P
syn keyword ffGlobal             region
syn keyword ffGlobal             verbosity
syn keyword ffGlobal             version
syn keyword ffGlobal             x
syn keyword ffGlobal             y
syn keyword ffGlobal             z

syn keyword ffmethodCoordo       x
syn keyword ffmethodCoordo       y
syn keyword ffmethodCoordo       z

syn keyword ffmethodFespace      ndof
syn keyword ffmethodFespace      ndofK

syn keyword ffmethodStream       default
syn keyword ffmethodStream       fixed
syn keyword ffmethodStream       noshowbase
syn keyword ffmethodStream       noshowpos
syn keyword ffmethodStream       showbase
syn keyword ffmethodStream       showpos
syn keyword ffmethodStream       precision
syn keyword ffmethodStream       scientific
syn keyword ffmethodStream       eof
syn keyword ffmethodStream       good

syn keyword ffmethodMatrix       coef
syn keyword ffmethodMatrix       diag
syn keyword ffmethodMatrix       m
syn keyword ffmethodMatrix       n
syn keyword ffmethodMatrix       nbcoef
syn keyword ffmethodMatrix       resize

syn keyword ffmethodMesh         area
syn keyword ffmethodMesh         label
syn keyword ffmethodMesh         nt
syn keyword ffmethodMesh         nuTriangle
syn keyword ffmethodMesh         nv
syn keyword ffmethodMesh         region

syn keyword ffmethodString       find
syn keyword ffmethodString       length
syn keyword ffmethodString       rfind
syn keyword ffmethodString       size

syn keyword ffmethodVector       im
syn keyword ffmethodVector       l1
syn keyword ffmethodVector       l2
syn keyword ffmethodVector       linfty
syn keyword ffmethodVector       max
syn keyword ffmethodVector       min
syn keyword ffmethodVector       re
syn keyword ffmethodVector       resize
syn keyword ffmethodVector       sum

syn keyword ffParameter          abserror
syn keyword ffParameter          anisomax
syn keyword ffParameter          append
syn keyword ffParameter          aspectratio
syn keyword ffParameter          bb
syn keyword ffParameter          binside
syn keyword ffParameter          bmat
syn keyword ffParameter          bw
syn keyword ffParameter          cadna
syn keyword ffParameter          clean
syn keyword ffParameter          cmm
syn keyword ffParameter          cutoff
syn keyword ffParameter          dimKrylov
syn keyword ffParameter          eps
syn keyword ffParameter          err
syn keyword ffParameter          errg
syn keyword ffParameter          factorize
syn keyword ffParameter          fill
syn keyword ffParameter          grey
syn keyword ffParameter          hmax
syn keyword ffParameter          hmin
syn keyword ffParameter          hsv
syn keyword ffParameter          init
syn keyword ffParameter          inquire
syn keyword ffParameter          inside
syn keyword ffParameter          IsMetric
syn keyword ffParameter          iso
syn keyword ffParameter          ivalue
syn keyword ffParameter          keepbackvertices
syn keyword ffParameter          label
syn keyword ffParameter          maxit
syn keyword ffParameter          maxsubdiv
syn keyword ffParameter          metric
syn keyword ffParameter          nbarrow
syn keyword ffParameter          nev
syn keyword ffParameter          nbiso
syn keyword ffParameter          nbiter
syn keyword ffParameter          nbiterline
syn keyword ffParameter          nbjacoby
syn keyword ffParameter          nbsmooth
syn keyword ffParameter          nbvx
syn keyword ffParameter          ncv
syn keyword ffParameter          nomeshgeneration
syn keyword ffParameter          omega
syn keyword ffParameter          op
syn keyword ffParameter          optimize
syn keyword ffParameter          periodic
syn keyword ffParameter          power
syn keyword ffParameter          precon
syn keyword ffParameter          ps
syn keyword ffParameter          qfe
syn keyword ffParameter          qfnbpE
syn keyword ffParameter          qfnbpT
syn keyword ffParameter          qforder
syn keyword ffParameter          qft
syn keyword ffParameter          ratio
syn keyword ffParameter          rescaling
syn keyword ffParameter          save
syn keyword ffParameter          sigma
syn keyword ffParameter          solver
syn keyword ffParameter          split
syn keyword ffParameter          splitin2
syn keyword ffParameter          splitpbedge
syn keyword ffParameter          strategy
syn keyword ffParameter          sym
syn keyword ffParameter          t
syn keyword ffParameter          tgv
syn keyword ffParameter          thetamax
syn keyword ffParameter          tol
syn keyword ffParameter          tolpivot
syn keyword ffParameter          tolpivotsym
syn keyword ffParameter          value
syn keyword ffParameter          varrow
syn keyword ffParameter          vector
syn keyword ffParameter          veps
syn keyword ffParameter          verbosity
syn keyword ffParameter          viso
syn keyword ffParameter          wait

syn keyword ffSyntax             break
syn keyword ffSyntax             continue
syn keyword ffSyntax             else
syn keyword ffSyntax             end
syn keyword ffSyntax             endl
syn keyword ffSyntax             for
syn keyword ffSyntax             if
syn keyword ffSyntax             include
syn keyword ffSyntax             load
syn keyword ffSyntax             mpirank
syn keyword ffSyntax             mpisize
syn keyword ffSyntax             return
syn keyword ffSyntax             while

syn keyword ffType               BoundaryProblem
syn keyword ffType               bool
syn keyword ffType               border
syn keyword ffType               complex
syn keyword ffType               fespace
syn keyword ffType               func
syn keyword ffType               ifstream
syn keyword ffType               int
syn keyword ffType               matrix
syn keyword ffType               mesh
syn keyword ffType               ofstream
syn keyword ffType               problem
syn keyword ffType               R3
syn keyword ffType               real
syn keyword ffType               solve
syn keyword ffType               string
syn keyword ffType               varf

" syn keyword ffUnclear

" -----------------------------------------------------------------------------
" Default highlighting
" -----------------------------------------------------------------------------

command -nargs=+ HiLink hi def link <args>

HiLink ffBoolean              Boolean
HiLink ffConstantEF           Constant
HiLink ffConstantNum          Number
HiLink ffConstantQF           Constant
HiLink ffConstantSolver       Constant
HiLink ffFunctionField        Function
HiLink ffFunctionDiff         Function
HiLink ffFunctionFE           Function
HiLink ffFunctionInt          Function
HiLink ffFunctionMath         Function
HiLink ffFunctionMatrix       Function
HiLink ffFunctionMesh         Function
HiLink ffFunctionPara         Function
HiLink ffFunctionPlot         Function
HiLink ffFunctionSolver       Function
HiLink ffFunctionSystem       Function
HiLink ffGlobal               Function
HiLink ffmethodCoordo         Function
HiLink ffmethodFespace        Function
HiLink ffmethodMatrix         Function
HiLink ffmethodMesh           Function
HiLink ffmethodStream         Function
HiLink ffmethodString         Function
HiLink ffmethodVector         Function
HiLink ffParameter            Function
HiLink ffSyntax               Statement
HiLink ffType                 Type
HiLink ffUnclear              Error         " En attendant...

delcommand HiLink

" -----------------------------------------------------------------------------
" Set current syntax
" -----------------------------------------------------------------------------

let b:current_syntax = "edp"

" -----------------------------------------------------------------------------
" EOF
" -----------------------------------------------------------------------------