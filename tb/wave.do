onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rvlife_seq_tb/clk_sys
add wave -noupdate /rvlife_seq_tb/rstn_sys
add wave -noupdate /rvlife_seq_tb/u_rvlife_seq/pc
add wave -noupdate /rvlife_seq_tb/u_rvlife_seq/instr
add wave -noupdate /rvlife_seq_tb/u_rvlife_seq/u_regs_file/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10891 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {61586 ps}
