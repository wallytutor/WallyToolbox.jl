extract ()
{
    if [ -d "$1/case/logging/" ]; then
        echo "\nCASE $1"
        tail -50 $1/case/logging/log.foamRun | grep ^Time | tail -1
        tail -50 $1/case/logging/log.foamRun | grep ^deltaT | tail -1
        tail -50 $1/case/logging/log.foamRun | grep ^Courant | tail -1
        tail -50 $1/case/logging/log.foamRun | grep ^ExecutionTime | tail -1
    fi
}

extract "001"
extract "002"
extract "003"
extract "004"
