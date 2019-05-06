transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/altera/91sp2/quartus/MICRAN/FSM_frame {C:/altera/91sp2/quartus/MICRAN/FSM_frame/FSM_frame.v}

vlog -vlog01compat -work work +incdir+C:/altera/91sp2/quartus/MICRAN/FSM_frame/simulation/modelsim {C:/altera/91sp2/quartus/MICRAN/FSM_frame/simulation/modelsim/FSM_frame.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L stratixii_ver -L rtl_work -L work -voptargs="+acc" FSM_frame_vlg_tst

add wave *
view structure
view signals
run -all
