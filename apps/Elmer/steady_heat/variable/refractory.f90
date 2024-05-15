FUNCTION conductivity(model, n, time) RESULT(k)
    ! Load Elmer library. 
    USE DefUtils
    IMPLICIT None

    ! Function interface.
    TYPE(Model_t) :: model
    INTEGER       :: n
    REAL(KIND=dp) :: time, k

    ! Function internals.
    TYPE(Variable_t), POINTER :: TemperatureVariable
    REAL(KIND=dp) :: T
    INTEGER :: idx

    ! Retrieve pointer to the temperature variable.
    TemperatureVariable => VariableGet(model%Variables, 'Temperature')

    ! Access index of current node.
    idx = TemperatureVariable%Perm(n)

    ! Retrieve nodal temperature.
    T = TemperatureVariable%Values(idx)

    ! Compute heat conductivity from NodalTemperature, k=k(T)
    k = 1.984706119175 - T * (2.531209e-03 - 1.43e-06 * T)
END FUNCTION conductivity