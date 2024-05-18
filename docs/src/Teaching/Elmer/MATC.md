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

<table>
<tr>
  <th style="width:250px">Operation</th>
  <th>Meaning</th>
</tr>
<tr>
  <td>`funcdel(name)`</td><td>Delete given function definition from parser.</td>
</tr>
<tr>
  <td>`funclist(name)`</td><td>Give header of the function given by name.</td>
</tr>
<tr>
  <td>`env(name)`</td><td>Get value of environment variable of the operating system.</td>
</tr>
<tr>
  <td>`str = sprintf(fmt[,vec] )`</td><td>Return a string formatted using fmt and values from vec. A call to corresponding C-language function is made.</td>
</tr>
<tr>
  <td>`vec = sscanf(str,fmt)`</td><td>Return values from str using format fmt. A call to corresponding C-language function is made.</td>
</tr>
<tr>
  <td>`special = matcvt(matrix, type)`</td><td>Makes a type conversion from MATC matrix double precision array to given type, which can be one of the following: `"int"`, `"char"` or `"float"`.</td>
</tr>
<tr>
  <td>`r = cvtmat( special, type )`</td><td>Makes a type conversion from given type to MATC matrix. Type can be one of the following: `"int"`, `"char"` or `"float"`.</td>
</tr>
<tr>
  <td>`r = eval(str)`</td><td>Evaluate content of string str. Another form of this command is `@str`.</td>
</tr>
<tr>
  <td>`source(name)`</td><td>Execute commands from file given name.</td>
</tr>
<tr>
  <td>`help` or `help("symbol")`</td><td>First form of the command gives list of available commands. Second form gives help on specific routine.</td>
</tr>
<tr>
  <td>`str = fread(fp,n)`</td><td>Read `n` bytes from file given by `fp`. File pointer fp should have been obtained from a call to `fopen` or `freopen`, or be the standard input file stdin. Data is returned as function value.</td>
</tr>
<tr>
  <td>`vec = fscanf(fp,fmt)`</td><td>Read file `fp` as given in format. Format fmt is equal to C-language format. File pointer `fp` should have been obtained from a call to `fopen` or `freopen`, or be the standard input.</td>
</tr>
<tr>
  <td>`str = fgets(fp)`</td><td>Read next line from fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard input.</td>
</tr>
<tr>
  <td>`n = fwrite(fp,buf,n)`</td><td>Write n bytes from buf to file fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard output (stdout) or standard error (stderr). Return value is number of bytes actually written. Note that one matrix element reserves 8 bytes of space.</td>
</tr>
<tr>
  <td>`n = fprintf(fp,fmt[, vec])`</td><td>Write formatted string to file fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard output (stdout) or standard error (stderr). The format fmt is equal to C-language format.</td>
</tr>
<tr>
  <td>`fputs(fp,str)`</td><td>Write string str to file fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard input (stdin).</td>
</tr>
<tr>
  <td>`fp = fopen(name,mode)`</td><td>Reopen file given previous file pointer, name and access mode. The most usual modes are `"r"` for reading and `"w"` for writing. Return value fp is used in functions reading and writing the file.</td>
</tr>
<tr>
  <td>`fp = freopen(fp,name,mode)`</td><td>Reopen file given previous file pointer, name and access mode. The most usual modes are `"r"` for reading and `"w"` for writing. Return value fp is used in functions reading and writing the file.</td>
</tr>
<tr>
  <td>`fclose(fp) `</td><td>Close file previously opened with fopen or freopen.</td>
</tr>
<tr>
  <td>`save(name, a[,ascii_flag])`</td><td>Close file previously opened with `fopen` or `freopen`.</td>
</tr>
<tr>
  <td>`r = load(name)`</td><td>Load matrix from a file given name and in format used by `save` command.</td>
</tr>
<tr>
  <td>`r = min(matrix)`</td><td>Return value is a vector containing smallest element in columns of given matrix. r = min(min(matrix)) gives smallest element of the matrix.</td>
</tr>
<tr>
  <td>`r = max(matrix)`</td><td>Return value is a vector containing largest element in columns of given matrix. `r = max(max(matrix))` gives largest element of the matrix.</td>
</tr>
<tr>
  <td>`r = sum(matrix)`</td><td>Return vector is column sums of given matrix. `r = sum(sum(matrix))` gives the total sum of elements of the matrix.</td>
</tr>
<tr>
  <td>`r = trace(matrix)`</td><td>Return value is the sum of matrix diagonal elements.</td>
</tr>
<tr>
  <td>`r = det(matrix)`</td><td>Return value is determinant of given square matrix.</td>
</tr>
<tr>
  <td>`r = inv(matrix)`</td><td>Invert given square matrix. Computed also by operator $^{-1}$</td>
</tr>
<tr>
  <td>`r = tril(x)`</td><td>Return the lower triangle of the matrix x.</td>
</tr>
<tr>
  <td>`r = triu(x)`</td><td>Return the upper triangle of the matrix x.</td>
</tr>
<tr>
  <td>`r = eig(matrix)`</td><td>Return eigenvalues of given square matrix. The expression `r(n,0)` is real part of the n:th eigenvalue, `r(n,1)` is the imaginary part respectively.</td>
</tr>
<tr>
  <td>`r = jacob(a,b,eps)`</td><td>Solve symmetric positive definite eigenvalue problem by Jacob iteration. Return values are the eigenvalues. Also a variable eigv is created containing eigenvectors.</td>
</tr>
<tr>
  <td>`r = lud(matrix)`</td><td>Return value is LUD decomposition of given matrix. </td>
</tr>
<tr>
  <td>`r = hesse(matrix)`</td><td>Return the upper hessenberg form of given matrix.</td>
</tr>
<tr>
  <td>`r = eye(n)`</td><td>Return n by n identity matrix. </td>
</tr>
<tr>
  <td>`r = zeros(n,m)`</td><td>Return n by m matrix with elements initialized to zero.</td>
</tr>
<tr>
  <td>`r = ones(n,m)`</td><td>Return n by m matrix with elements initialized to one.</td>
</tr>
<tr>
  <td>`r = rand(n,m)`</td><td>Return n by m matrix with elements initialized with random numbers from zero to one.</td>
</tr>
<tr>
  <td>`r = diag(matrix) or r=diag(vector)`</td><td>Given matrix return diagonal entries as a vector. Given vector return matrix with diagonal elements from vector. r = diag(diag(a)) gives matrix with diagonal elements from matrix a, otherwise elements are zero.</td>
</tr>
<tr>
  <td>`r = vector(start,end,inc)`</td><td>Return vector of values going from start to end by inc.</td>
</tr>
<tr>
  <td>`r = size(matrix)`</td><td>Return size of given matrix.</td>
</tr>
<tr>
  <td>`r = resize(matrix,n,m)`</td><td>Make a matrix to look as a n by m matrix. This is the same as r = n m % matrix. </td>
</tr>
<tr>
  <td>`where(a)`</td><td>Return a row vector giving linear index to a where a is not zero. </td>
</tr>
<tr>
  <td>`exists(name)`</td><td>Return true (non-zero) if variable by given name exists otherwise return false </td>(=0). 
</tr>
<tr>
  <td>`who`</td><td>Give list of currently defined variables.</td>
</tr>
<tr>
  <td>`format(precision)`</td><td>Set number of digits used in printing values in MATC.</td>
</tr>
</table>
