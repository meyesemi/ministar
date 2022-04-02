#!/bin/csh -f
vcs -sverilog -R -full64 -fsdb    \
-v prim_sim.v       \
../../tb/tb.v     \
../../project/src/ddr3_syn_top.v       \
../../project/src/DDR3_test_rst.v    \
../../project/src/key_debounce.v      \
../../project/src/ddr3_memory_interface/ddr3_memory_interface.vo  \
../../tb/sim_model/ddr3_model.v   \
+incdir+../../project/src/ \
+incdir+../../project/src/ddr3_memory_interface/   \
+incdir+../../tb/sim_model/  \
+incdir+../../tb/  | tee log
