//******************************************************************************************************//

Note:

//******************************************************************************************************//
1.About the document:

This file is the Reference Design of MIPI DPHY TX to RX. MIPI TX sends data and MIPI RX receives data. 
This design is for reference only, to help users to be familiar with the relevant contents of MIPI DPHY.
It can't replace the normal MIPI DPHY design.

//******************************************************************************************************//
2.About the file:

The file contains:
(1) Gowin IDE project:"MIPI_RefDesign";
(2) The simulation script of the IDE project: "cmd.do";
(3) The the simulation TB file of the IDE project: "MIPI_tb.v".
Users can view the contents of relevant documents in each folder.

//******************************************************************************************************//
3.About the IDE Project:

The IDE project can download development board for testing after running. Users can use Gao to observe the data of MIPI DPHY interface.


The .cst file provided in the project is based on the Gowin 9K development board, which is only for users' reference.


Users need to configure reasonable constraint location information according to their own development board.

//******************************************************************************************************//
4.Aboyt the define option:

In the project, users can modify " `define " in "DPHY_TOP.v/MIPI_tb.v" to match the different configuration options of MIPI DPHY IP for simulation or P&R.
In "DPHY_TOP.v/MIPI_tb.v", the meaning of each define has been explained in the note. Please refer to it carefully.




Note that define needs to correspond to the generated MIPI DPHY IP correctly.

//******************************************************************************************************//
5.About the simulation:
 
cmd.do: Modelsim simulation script. For reference only.
If the user wants to use the script for simulation directly, some contents still need to be modified.

//******************************************************************************************************//
6.About the cmd.do:

(1) In part 2 of "cmd.do", the "prim_sim.v" file and the path should be modified or added by the Users. 
(2) "prim_sim.v" is a primitive library. Users need to add appropriate primitives according to the Device which be used.
(3) The "prim_sim.v" can be obtained from the Software installation directory. Its reference path is like "Gowin_v1.9.*\IDE\simlib"
(4) Users can also create simulation library files of Modelsim by themselves, and connect the work to the simulation library.

