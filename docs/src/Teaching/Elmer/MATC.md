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

| <div style="width:120px">Operation</div> | Meaning                                                                                                                                                                       |
| ---------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `b = a'`                                 | is transpose of matrix a.                                                                                                                                                     |
| `b = @a`                                 | evaluate content of a string variable a as a MATC statement.                                                                                                                  |
| `t = ~l`                                 | elementwise logical not of  if x is not zero.                                                                                                                                 |
| `b = a ^ s`                              | if a is a square matrix and s is integral, a matrix power is computed, otherwise an elementwise power.                                                                        |
| `c = a * b`                              | if a and b are compatible for matrix product, that is computed, otherwise if they are of the same size or at least one of them is scalar, an elementwise product is computed. |
| `c = a # b`                              | elementwise multiplication of a and b.                                                                                                                                        |
| `c = a / b`                              | is fraction of a and b computed elementwise.                                                                                                                                  |
| `c = a + b`                              | is sum of matrices a and b computed elementwise.                                                                                                                              |
| `c = a - b`                              | is difference of matrices a and b computed elementwise.                                                                                                                       |
| `l = a == b`                             | equality of matrices a and b elementwise.                                                                                                                                     |
| `l = a <> b`                             | inequality of matrices a and b elementwise.                                                                                                                                   |
| `l = a < b`                              | true if a is less than b computed elementwise.                                                                                                                                |
| `l = a > b`                              | true if a is greater than b computed elementwise.                                                                                                                             |
| `l = a <= b`                             | true if a is less than or equal to b computed elementwise.                                                                                                                    |
| `l = a >= b`                             | true if a is greater than or equal to b computed elementwise.                                                                                                                 |
| `a = n : m`                              | return a vector of values starting from n and ending to m by increment of (plus-minus) one.                                                                                   |
| `r = l & t`                              | elementwise logical and of a and b.                                                                                                                                           |
| `l = a \| b`                             | elementwise logical or of a and b.                                                                                                                                            |
| `c = a ? b`                              | reduction: set values of a where b is zero to zero.                                                                                                                           |
| `b = n m % a`                            | resize a to matrix of size n by m.                                                                                                                                            |
| `b = a`                                  | assigning a to b.                                                                                                                                                             |

## Function definitions

## Built-in functions