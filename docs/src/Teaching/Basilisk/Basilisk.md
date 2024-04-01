The goal of this material is to provide support to teaching introductory computational fluid mechanics with aid of [Basilisk](http://basilisk.fr/). The studies are based on commented [tutorials](Tutorials.md) and a documentation [guide](Documentation.md) extending what is already provided with the package.

## First steps

The source code for the studies is provided [here](https://github.com/wallytutor/Basilisk). The repository keeps a copy of Basilisk at a version that will work with all modified tutorials. It may be eventually updated, but in that case functioning of tutorials will be tested. You will need to clone it then following the steps to [compile Basilisk](http://basilisk.fr/src/INSTALL) before starting. After building Basilisk, instead of adding variables to your environment, consider sourcing them temporarily with help of `source activate.sh` using the provided script.

All tutorials are found under [src](https://github.com/wallytutor/Basilisk/tree/main/src). Just enter the tutorials you want to follow using the command line and run `make`. This not only will compile, but will also run and post-process results.

## Project management

Although Basilisk is a very interesting dialect of C, its documentation is still old-fashioned and lack some structuration. Also sample programs are not written to be easily managed and extended for use in variant cases. Here we propose a structure for creating better projects with Basilisk:

- A Basilisk project lives in its own folder: one executable means one directory.

- A simpler `Makefile` than Basilisk's default one is used for project building.

- The main file is called `app.c` and contains a very simple structure as provided in the dummy listing bellow. All the logic of a project, *i.e. the events*, is implemented in separate header files that are included after Basilisk includes.

```c
// Definitions
#define LEVEL 7
#define ...

// Basilisk includes.
#include "grid/multigrid.h"
#include "run.h"
#include ...  

// Project includes.
#include "project-base.h"
#include "project-init.h"
#include "project-post.h"
#include "project-exec.h"

int main() {
	init_grid(1 << LEVEL);
	...
	run();
}
```

