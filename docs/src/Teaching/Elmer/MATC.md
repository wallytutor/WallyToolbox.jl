# MATC

Elmer provides a few extension methods. For complex models you might be prompted to use directly Fortran 90. For simpler things, such as providing temperature dependent thermophysical properties, it has its own parser for use in SIF, the metalanguage MATC. Expressions provided in MATC can be evaluated when file is read or during simulation execution.

Because it is quite concise, I summarized the whole of MATC syntax and functions in this page. For the official documentation please refer to [this document](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf).

## Declaring variables

Variables in MATC can be matrices and strings; nonetheless, both are stored as double precision arrays so creating large arrays of strings can represent a waste of memory. For some weird reason I could not yet figure out, MATC language can be quite counterintuitive.

Let's start by creating a variable, say `x` below; attribution, such a in Python, creates the variable. It was stated that everything is a matrix or string; since `x` is not a string, it is actually a $1\times{}1$ matrix and in this case we can omit the indexing when allocating its memory.

```C
x = 1
```

So far nothing weird; when declaring a string as `k` below we are actually creating a $1\times{}5$ row matrix, what is not unusual in many programming languages (except for being double precision here). Furthermore, we use the typical double-quotes notation for strings.

```C
k = "hello"
```

Matrix indexing is zero-based, as in C or Python. Matrix slicing is done as in many scripting languages, such as Python, Julia, Octave, ..., and we can reverse the order of the first *six* elements of an array `y` as follows: 

```C
y(0, 0:5) = y(0, 5:0)
```

Notice above the fact that matrix slicing is *last-inclusive*, as in Julia, meaning that all elements from index zero to five *inclusive* are included in the slice. Weirdness starts when you do something like

```C
z(0:9) = 142857
```

which according to the documentation will produce an array `1 4 2 8 5 7 1 4 2 8`; I could not verify this behavior yet. Additionally, the following produces another unexpected result:

```C
z(9, 9) = 1
```

If matrix `z` does not exist, this results in a $10\times{}10$ matrix with all zeros except the explicitly declared element. The size of variables are dynamic, so in the above if `z` already existed but wa smaller, it would be padded with zeros instead.

Finally, logical indexing is also allowed:

```C
x(x < 0.05) = 0.05
```

## Control structures

MATC provides conditionals and loops as control structures. Below we have the `if-else` statement, which can be declared inline of using a C-style declaration using braces.

```C
if ( expr ) expr; else expr;

if ( expr )
{
    expr;
    ...
    expr;
} else {
    expr;
    ...
    expr;
}
```

Loops can be declared using both `for` or `while`. There is no mechanism of generating values within a `for` loop and one must provide a vector of indexes for repetition. *In the official documentation there is no reference to a `continue` or `break` statement and I could not verify their existence yet*.

```C
for( i=vector ) expr;

for( i=vector )
{
    expr;
    ...
    expr;
}

while( expr ) expr;

while( expr )
{
    expr;
    ...
    expr;
}
```

## Operators

Assume the following definitions:

- `a`, `b` and `c` ordinary matrices  
- `l`, `t` and `r` logical matrices 
- `s`, `n` and `m` scalars 

<table>
<tr>
  <th style="width:120px">Operation</th>
  <th>Meaning</th>
</tr>
<tr>
  <td>`b = a'`     </td>
  <td>is transpose of matrix a.</td>
</tr>
<tr>
  <td>`b = @a`     </td>
  <td>evaluate content of a string variable a as a MATC statement.</td>
</tr>
<tr>
  <td>`t = ~l`     </td>
  <td>elementwise logical not of  if x is not zero.</td>
</tr>
<tr>
  <td>`b = a ^ s`  </td>
  <td>if a is a square matrix and s is integral, a matrix power is computed, otherwise an elementwise power.</td>
</tr>
<tr>
  <td>`c = a * b`  </td>
  <td>if a and b are compatible for matrix product, that is computed, otherwise if they are of the same size or at least one of them is scalar, an elementwise product is computed.</td>
</tr>
<tr>
  <td>`c = a # b`  </td>
  <td>elementwise multiplication of a and b.</td>
</tr>
<tr>
  <td>`c = a / b`  </td>
  <td>is fraction of a and b computed elementwise.</td>
</tr>
<tr>
  <td>`c = a + b`  </td>
  <td>is sum of matrices a and b computed elementwise.</td>
</tr>
<tr>
  <td>`c = a - b`  </td>
  <td>is difference of matrices a and b computed elementwise.</td>
</tr>
<tr>
  <td>`l = a == b` </td>
  <td>equality of matrices a and b elementwise.</td>
</tr>
<tr>
  <td>`l = a <> b` </td>
  <td>inequality of matrices a and b elementwise.</td>
</tr>
<tr>
  <td>`l = a < b`  </td>
  <td>true if a is less than b computed elementwise.</td>
</tr>
<tr>
  <td>`l = a > b`  </td>
  <td>true if a is greater than b computed elementwise.</td>
</tr>
<tr>
  <td>`l = a <= b` </td>
  <td>true if a is less than or equal to b computed elementwise.</td>
</tr>
<tr>
  <td>`l = a >= b` </td>
  <td>true if a is greater than or equal to b computed elementwise.</td>
</tr>
<tr>
  <td>`a = n : m`  </td>
  <td>return a vector of values starting from n and ending to m by increment of (plus-minus) one.</td>
</tr>
<tr>
  <td>`r = l & t`  </td>
  <td>elementwise logical and of a and b.</td>
</tr>
<tr>
  <td>`l = a \| b` </td>
  <td>elementwise logical or of a and b.</td>
</tr>
<tr>
  <td>`c = a ? b`  </td>
  <td>reduction: set values of a where b is zero to zero.</td>
</tr>
<tr>
  <td>`b = n m % a`</td>
  <td>resize a to matrix of size n by m.</td>
</tr>
<tr>
  <td>`b = a`      </td>
  <td>assigning a to b.</td>
</tr>
</table>

## Function definitions

The syntax of the function definition is similar to that of Fortran but without an `end` statement and is given below. Notice the `!` denoting comments in the description of the function.

```Fortran
function name(arg1, arg2, ...)
!
! Optional function description (seen with help("name"))
!
import var1, var2
export var3, var4

    expr;
     ...
    expr;

    _name = value
```

Functions have their own list of variables. Global variables are not seen in this function unless imported by `import` or given as arguments. Local variables can be made global by the `export` statement. 

Functions, if returning matrices, behave in many ways as variables do. So if you have defined function `mult` as follows 

```Fortran
function mult(a, b)

   _mult = a * b;

```

You can get element (3,5) of the `a` times `b` matrix with `mult(x,y)[3,5]` or the diagonal values of the same matrix by `diag(mult(x, y))`.

## Built-in functions

The following listing provides a series of mathematical functions which follow a their meaning in C. The only exceptions are `ln` denoting the natural logarithm and `log` used here for base 10 logarithms.

```C
r = sin(x)

r = cos(x)

r = tan(x)

r = asin(x)

r = acos(x)

r = atan(x)

r = sinh(x)

r = cosh(x)

r = tanh(x)

r = exp(x)

r = ln(x)

r = log(x)

r = sqrt(x)

r = ceil(x)

r = floor(x)

r = abs(x)

r = pow(x,y) 
```