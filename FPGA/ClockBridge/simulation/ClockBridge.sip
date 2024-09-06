set_global_assignment -entity "ClockBridge" -library "lib_ClockBridge" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "ClockBridge" -library "lib_ClockBridge" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "ClockBridge" -library "lib_ClockBridge" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_ClockBridge" -name SPD_FILE [file join $::quartus(sip_path) "../ClockBridge.spd"]
set_global_assignment -library "lib_ClockBridge" -name MISC_FILE [file join $::quartus(sip_path) "../../ClockBridge.qsys"]

set_global_assignment -library "lib_ClockBridge" -name MISC_FILE [file join $::quartus(sip_path) "ClockBridge.v"]
set_global_assignment -library "lib_ClockBridge" -name MISC_FILE [file join $::quartus(sip_path) "submodules/ClockBridge_pll_0.vo"]
