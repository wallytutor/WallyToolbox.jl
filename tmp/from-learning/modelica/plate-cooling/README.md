# Plate cooling model

This sample model implements a simple plate cooling in time with different forced inputs.

To run the model simply call `omc app.mos` and all C-generated code will be dumped in working directory.

Consider the following script for running and cleaning directory under Linux.

```bash
#!/usr/bin/env bash
omc app.mos;

rm -rf *.c *.h *.o *.makefile;
rm -rf ApcTowerModelImplemented.TowerModel;
```
