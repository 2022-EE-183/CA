vlog ./*.sv  
vsim -c tb_processor -voptargs=+acc -do "run -all"
gtkwave processor.vcd -o wave.gtkw
