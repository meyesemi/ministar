## part 1: new lib
vlib work
vmap work work

## part 2: load design
vlog -novopt -incr -work work "../../tb/MIPI_tb.v"
vlog -novopt -incr -work work "../../MIPI_RefDesign/src/DPHY_TOP.v"
vlog -novopt -incr -work work "../../MIPI_RefDesign/src/gw_pll.v"
vlog -novopt -incr -work work "../../MIPI_RefDesign/src/ROM549X17.v"
vlog -novopt -incr -work work "../../MIPI_RefDesign/src/DPHY_TX_TOP/DPHY_TX_TOP.vo"
vlog -novopt -incr -work work "../../MIPI_RefDesign/src/DPHY_RX_TOP/DPHY_RX_TOP.vo"
vlog -novopt -incr -work work "prim_sim.v"

## part 3: sim design
vsim -novopt work.MIPI_tb

## part 4: add signals
#add wave *
add wave -noupdate -expand -group tb /MIPI_tb/*
add wave -noupdate -expand -group dphy_top /MIPI_tb/u_DPHY_TOP/*


## part 5: show ui 
#view wave
#view structure
#view signals

## part 6: run 
run 2ms