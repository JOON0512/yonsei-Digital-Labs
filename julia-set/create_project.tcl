# Vivado 2020.2; generated build output stays in build/.
set root [file dirname [file normalize [info script]]]
create_project julia_set [file join $root build] -part xc7z020clg400-1
add_files [glob [file join $root rtl *.v]]
add_files -fileset constrs_1 [file join $root constraints pynq-z2.xdc]
import_ip [file join $root ip blk_mem_gen_0.xci]
generate_target all [get_ips blk_mem_gen_0]
set_property top HDMI_TOP [current_fileset]
update_compile_order -fileset sources_1
