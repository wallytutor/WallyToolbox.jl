# -*- coding: utf-8 -*-


def tdma_solve(A: list[float], B: list[float], C: list[float],
               R: list[float], S: list[float]) -> list[float]:
    """ Tridiagonal (Thomas) matrix algorithm for solution.
    
    A: list[float]
        Lower diagonal array.
    B: list[float]
        Main diagonal array.
    C: list[float]
        Upper diagonal array.
    R: list[float]
        Problem right-hand side.
    S: list[float]
        Allocated solution memory.

    Returns
    -------
    list[float]
        Solution (modified in place) on `S`.
    """
    S[:] = R.copy()

    for i in range(1, S.shape[0]):
        m = A[i-1] / B[i-1]
        B[i] -= m * C[i-1]
        S[i] -= m * S[i-1]

    S[-1] /= B[-1]

    for i in range(S.shape[0] - 2, -1, -1):
        S[i] = (S[i] - C[i] * S[i+1]) / B[i]

    return S
