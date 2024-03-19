
Two Main directories: Junction and MD.

1)Junction has to do with determining the specifics of the gold junction. There are two sub-directories:

- lateral: calculations run to determine the right lateral size of each electrode layer (collectively). It was found from my calculations that 6x6 was the optimal compromise between accuracy and cost. Another read_me file can be found there.

- cell_opt: the full junction is optimized using the CELL_OPT run-type. This was done for both 4-atom and 5-atom wires as part of picking which is better for the model. This subdirectory is easy to understand.

- layers: slab thickness convergence, first thing you must do. This is to determine optimal number of electrode layers. 

2) MD: this is the fun and important directory and consists of several subdirectories. We have classical_NVT for both the junction and a junction without the wire, and the AIMD. There is also a directory in which the charge density difference, Bader chargers and PDOS were calculated for a single trajectory at around 8.72 ps. This analysis might not be replicable unless you have cubecruncher downloaded and added to your terminal pathway.
