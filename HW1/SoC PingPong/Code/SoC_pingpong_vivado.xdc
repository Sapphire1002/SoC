set_property PACKAGE_PIN Y9 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]

# button
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {reset}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports {PL1}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {PL2}]

# led
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {led[7]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {led[6]}] 
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {led[5]}] 
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {led[3]}]  
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports {led[2]}] 
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports {led[1]}] 
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports {led[0]}] 
