
## part 1: new lib
vlib work
vmap work work

## part 2: load design
vlog -sv -f compile.f 


## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave /tb/u_top/init_calib_complete
add wave /tb/u_top/app_en
add wave /tb/u_top/app_cmd
add wave /tb/u_top/app_addr
add wave /tb/u_top/app_wdf_rdy
add wave /tb/u_top/app_wdf_data
add wave /tb/u_top/app_wdf_wren
add wave /tb/u_top/app_rd_data
add wave /tb/u_top/app_rd_data_valid
add wave /tb/u_top/app_rd_data_end
add wave /tb/u_top/u_ddr3/rd_data
add wave /tb/u_top/u_ddr3/IO_ddr_dq
add wave /tb/u_top/u_ddr3/IO_ddr_dqs
add wave /tb/u_top/u_ddr3/O_ddr_dqm
add wave /tb/u_top/u_ddr3/O_ddr_clk
add wave /tb/u_top/u_ddr3/O_ddr_cke
add wave /tb/u_top/u_ddr3/O_ddr_odt


## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
run 6000000ns