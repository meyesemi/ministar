#!/bin/csh
verdi -sverilog -v prim_sim.v  \
../../tb/tb.v               \
../../project/src/ddr3_syn_top.v       \
../../project/src/DDR3_test_rst.v    \
../../project/src/key_debounce.v      \
../../project/src/ddr3_memory_interface/ddr3_memory_interface.vo  \
../../tb/sim_model/ddr3_model.v   \
+incdir+../../project/src/ \
+incdir+../../project/src/ddr3_memory_interface/   \
+incdir+../../tb/sim_model/  \
-ssf ddr3.fsdb                \
+incdir+../../tb/               &