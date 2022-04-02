Attention:
	1. if you reconfig the ip parameters,which reload the ddr_memory_interface.ipc and re-generator. 
	   please attention bits width of the ddr3_syn_top.v and tb.v file. for example, in the tb.v:
	   	ddr_dq, ddr_dqs, ddr_addr......

	   int the ddr3_syn_top.v file:
		ddr_addr, ddr_ba,ddr_dqm,ddr_dq,ddr_dqs,ddr_dqs_n,app_wdf_mask,
		app_wdf_data,app_raw_not_ecc,app_addr,app_rd_data,app_ecc_multiple_err,mc_ras_n,
		mc_cas_n,mc_we_n,mc_address,mc_bank,mc_cs_n,mc_cke,mc_wrdata,mc_wrdata_mask,phy_rd_data

	2. for simulation, please in the../../project/src/ddr3_syn_top.v file,open below:
	   `define SIM
	   for board test, please in the../../project/src/ddr3_syn_top.v file,close below:
	   `define SIM

../project/src/*.v : 
                        test design for DDR3 ip
../project/src/ddr3_memory_interface/ddr3_memory_interface.vo :
                        DDR3 IP
../tb/tb.v :
                        testbench for simulation
prim_sim.v:             simulation library, get from installation path of Gowin YunYuan software 
