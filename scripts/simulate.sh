ghdl -a src/*.vhd
ghdl -a tb/tb_top.vhd
ghdl -e tb_top
ghdl -r tb_top --vcd=out.vcd
gtkwave out.vcd

