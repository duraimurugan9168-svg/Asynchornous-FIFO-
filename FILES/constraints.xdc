############################################
# CLOCK (100 MHz PL Clock)
############################################
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

############################################
# RESET (BTNU push button)
############################################
set_property PACKAGE_PIN T18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

############################################
# START/STOP (BTNC push button)
############################################
set_property PACKAGE_PIN P16 [get_ports sw_wr]
set_property IOSTANDARD LVCMOS33 [get_ports sw_wr]

############################################
# UNUSED (BTNR push button)
############################################
set_property PACKAGE_PIN R18 [get_ports sw_rd]
set_property IOSTANDARD LVCMOS33 [get_ports sw_rd]

############################################
# DATA INPUT SWITCHES (SW0-SW7)
############################################
set_property PACKAGE_PIN F22 [get_ports {sw_data[0]}] ;# SW0
set_property PACKAGE_PIN G22 [get_ports {sw_data[1]}] ;# SW1
set_property PACKAGE_PIN H22 [get_ports {sw_data[2]}] ;# SW2
set_property PACKAGE_PIN F21 [get_ports {sw_data[3]}] ;# SW3
set_property PACKAGE_PIN H19 [get_ports {sw_data[4]}] ;# SW4
set_property PACKAGE_PIN H18 [get_ports {sw_data[5]}] ;# SW5
set_property PACKAGE_PIN H17 [get_ports {sw_data[6]}] ;# SW6
set_property PACKAGE_PIN M15 [get_ports {sw_data[7]}] ;# SW7
set_property IOSTANDARD LVCMOS33 [get_ports sw_data[*]]

############################################
# FIFO DATA OUTPUT - PMOD JB
############################################
set_property PACKAGE_PIN W12 [get_ports {fifo_dout[0]}] ;# JB1
set_property PACKAGE_PIN W11 [get_ports {fifo_dout[1]}] ;# JB2
set_property PACKAGE_PIN V10 [get_ports {fifo_dout[2]}] ;# JB3
set_property PACKAGE_PIN W8  [get_ports {fifo_dout[3]}] ;# JB4
set_property PACKAGE_PIN V12 [get_ports {fifo_dout[4]}] ;# JB7
set_property PACKAGE_PIN W10 [get_ports {fifo_dout[5]}] ;# JB8
set_property PACKAGE_PIN V9  [get_ports {fifo_dout[6]}] ;# JB9
set_property PACKAGE_PIN V8  [get_ports {fifo_dout[7]}] ;# JB10
set_property IOSTANDARD LVCMOS33 [get_ports fifo_dout[*]]

############################################
# STATUS LEDs (LD0-LD7)
############################################
set_property PACKAGE_PIN T22 [get_ports {led[0]}] ;# LD0
set_property PACKAGE_PIN T21 [get_ports {led[1]}] ;# LD1
set_property PACKAGE_PIN U22 [get_ports {led[2]}] ;# LD2
set_property PACKAGE_PIN U21 [get_ports {led[3]}] ;# LD3
set_property PACKAGE_PIN V22 [get_ports {led[4]}] ;# LD4
set_property PACKAGE_PIN W22 [get_ports {led[5]}] ;# LD5
set_property PACKAGE_PIN U19 [get_ports {led[6]}] ;# LD6
set_property PACKAGE_PIN U14 [get_ports {led[7]}] ;# LD7
set_property IOSTANDARD LVCMOS33 [get_ports led[*]]

############################################
# CDC SYNCHRONIZER FALSE PATHS (OPTIONAL)
############################################
set_false_path -through [get_cells -hierarchical *sync*]

