# -*- coding: utf-8 -*-
""" script_002.py: define função polinomial. """


def poly(x, b=1):
    """ Avalia o polinômio x**2 + x + b. """
    y = x**2 + x + b
    
    # Imprime algumas informações na tela.
    print('y =', y, 
          'tipo(y) =', type(y),
          'tipo(b) =', type(b))
    
    # Retorna o valor do polinômio.
    return y


if __name__ == '__main__':
    print('Executando script_002')
    y = poly(2.0)
    y = poly(2)
    y = poly(2, b=1.0)
