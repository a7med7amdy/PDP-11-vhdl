add wave sim:/processor/*
force -freeze sim:/processor/Clock 0 0, 1 {50 ps} -r 100
force -freeze sim:/processor/Rst 1 0
run
noforce sim:/processor/Rst
run