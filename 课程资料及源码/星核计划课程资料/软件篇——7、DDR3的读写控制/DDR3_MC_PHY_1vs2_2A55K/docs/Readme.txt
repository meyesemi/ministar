________________________________________________________________________
	  Example DDR3 Design Read Me
-------------------------------------------------------------------------
Object device:GW2A-55-PBGA484
---------------------------------------------------------------------------
File List:
---------------------------------------------------------------------------
.
|-- doc
|   `-- Readme.txt                              -->  Read Me file (this file)
|-- tb 
|   `-- tb.v                                    -->  TestBench for Example DDR3 design
|-- project
|   `-- ddr3_ref_design.gprj          	               -->  GowinYunYuan Project File for Example Design
|   `-- ddr3_ref_design.gprj.user                      -->  GowinYunYuan Project File for Example Design
|   |-- impl
|   |   `-- dualpin_config.ini
|   |   `-- commonsyn_config.ini
|   |   |-- config
|   |   |-- pnr
|   |   `-- pnr_config.ini                      -->  GowinYunYuan Place & Route Config File for Example Design
|   |   `-- synthesis_config.ini                -->  Synplify_Pro Config File for Example Design
|   |   |-- synthesize
|   |-- src                          
|       |-- ddr3_syn_top.v                      -->  File for GowinYunYuan Project
|       |-- ddr3.cst                            -->  File for GowinYunYuan Project
|       |-- DDR3_test_rst.v                     -->  File for GowinYunYuan Project
|       |-- key_debounce.v                      -->  File for GowinYunYuan Project
|       |-- gao.v                               -->  File for GowinYunYuan Project
|       |-- ddr3.sdc                            -->  File for GowinYunYuan Project
|       |-- ddr3.gao                            -->  File for GowinYunYuan Project 
|       `-- ddr3_memory_interface          
|           |-- ddr3_memory_interface.v         -->  File for GowinYunYuan Project(Encrypted)
|           |-- ddr3_memory_interface.vo        -->  File for GowinYunYuan Project
|           `-- ddr3_memory_interface.ipc       -->  File for GowinYunYuan Project
|           |-- temp                            -->  File for GowinYunYuan Project
|-- simulation                                  -->  Simulation Environment

---------------------------------------------------------------------------------------------------------------
HOW TO OPEN A PROJECT IN GowinYunYuan:
---------------------------------------------------------------------------------------------------------------
1. Unzip the respective design files.
2. Launch GowinYunYuan and select "File -> Open -> Project"
3. In the Open Project dialog, enter the Project location -- "project",select the project"ddr3_ref_design.gprj".
4. Click Finish. Now the project is successfully loaded. 

---------------------------------------------------------------------------------------------------------------
HOW TO RUN SYNTHESIZE, PLACE AND ROUTE, IP CORE GENERATION, AND TIMING ANALYSIS IN GowinYunYuan:
---------------------------------------------------------------------------------------------------------------

1. Click the Process tab in the process panel of the GowinYunYuan dashboard. 
   Double click on Synthsize(Synplify Pro). This will bring the design through synthesis.
2. Click the Process tab in the process panel of the GowinYunYuan dashboard. 
   Double click on Place & Route. This will bring the design through mapping, place and route.
3. Once Place & Route is done, user can double click on Timing Analysis Report to get 
   the timing analysis result.
4. Click on "Project -> Configuration -> Place & Route" to configurate the Post-Place File 
   and SDF File of the design.
----------------------------------------------------------------------------------------------------------------

HOW TO RUN SIMULATION
1. User can run functional simulation by software VCS. 
2. User can check waveform by software Verdi.
----------------------------------------------------------------------------------------------------------------

HOW TO  GENERATE IP CORE
1. Click the IP Core Generator tab in the Window panel of the GowinYunYuan dashboard.
   Double click on "DDR3 Memory Interface". This will generate the IP Core for the design.
--------------------------------------------------------------------------------------------------------------

