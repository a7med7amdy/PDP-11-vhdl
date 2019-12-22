add wave  \
sim:/branchingcirc/PCin \
sim:/branchingcirc/IR \
sim:/branchingcirc/FlagReg \
sim:/branchingcirc/PCout \
sim:/branchingcirc/Carry \
sim:/branchingcirc/Zero \
sim:/branchingcirc/condition \
sim:/branchingcirc/uselessC \
sim:/branchingcirc/uselessV \
sim:/branchingcirc/selector \
sim:/branchingcirc/helpWithSign \
sim:/branchingcirc/OP2 \
sim:/branchingcirc/offset
force -freeze sim:/branchingcirc/IR 1100000011111110 0
force -freeze sim:/branchingcirc/PCin 0001011010011010 0
force -freeze sim:/branchingcirc/FlagReg 0000000000000000 0
run
force -freeze sim:/branchingcirc/IR 1100000000000100 0
run
force -freeze sim:/branchingcirc/IR 1100100000000100 0
run
force -freeze sim:/branchingcirc/IR 1110100000000100 0
run