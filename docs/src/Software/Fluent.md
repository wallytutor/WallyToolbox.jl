# Ansys Fluent

## Exporting data

| Format                   | Data   | Status |
| ------------------------ | ------ | ------ |
| CGNS ADF                 | Center | Failed |
| CGNS HFD5                | Center | Failed |
| CGNS HFD5                | Node   | Passed |
| Tecplot                  | N/A    | Failed |
| EnSight Case Gold binary | Node   | Passed |

Data can be exported to #CGNS #HDF5 format (readable by #ParaView); so far I have not tried to export data from multiple regions at once (after a crash in a first trial). Same procedure applies to the other formats reported as passing in the table above.

- In #Fluent `File > Export > Solution Data...` (Node values only!)
- In #ParaView read data and select `CGNS Series Reader`

Please notice that several problems arise when handling large datasets (slowness, crashes, ...).

## General purpose

| Macro          | Notes                                                                                                                               |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `Data_Valid_P` | Test if parameters required by UDF have been initialized. It is a good practice to use this macro on top of UDF's to avoid crashes. |
| `Message`      | Displays a message, to be used from host.                                                                                           |
| `Error`        | Display and throw an error message. **Compiled only**.                                                                              |

## Macro parallelization

| Macro                     | Notes                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `PRINCIPAL_FACE_P`        | When looping across faces in a thread using `begin_f_loop` (or another equivalent macro) in a parallel setting, we might access elements that actually belong to other nodes (because of how MPI works). This macro allows us to check the current face is part of the chunk belonging to current node, what allows us to avoid computing a quantity multiple times, leading to wrong results. **Compiled only**. |
| `RP_HOST`                 | Used in `#if` directives to tell code must be evaluated only in host.                                                                                                                                                                                                                                                                                                                                             |
| `RP_NODE`                 | Used in `#if` directives to tell code must be evaluated only in nodes.                                                                                                                                                                                                                                                                                                                                            |
| `PRF_GRSUM1`              | Performs aggregation of real `R` values through sum `SUM1`. This function is called in nodes and there are other *cousins* for different aggregations.                                                                                                                                                                                                                                                            |
| `node_to_host_{type}_{n}` | Pass `n` values of `type` from node to host. It is called after, *e.g.* aggregations such as `PRF_GRSUM1` are used in node. There is also an equivalent `host_to_node_{type}_{n}`.                                                                                                                                                                                                                                |
