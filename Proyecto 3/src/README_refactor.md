# Refactor summary (ES → EN)

Identifiers translated to English; functionality preserved.

## Module rename patterns
- `\bmodule_top_general\b` → `top_general`
- `\bmodule_teclado\b` → `keypad`
- `\bmodule_anti_rebote\b` → `debounce`
- `\bmodule_detector\b` → `edge_detector`
- `\bmodule_prio\b` → `priority_mux`
- `\bmodule_seg\b` → `sevenseg_driver`
- `\bmodule_BCD\b` → `bin_to_bcd`
- `\bmodule_BCDBin\b` → `bcd_to_bin`
- `\bMultiplicadorBooth\b` → `booth_multiplier`
- `\bUnidadControl\b` → `control_unit`
- `\bALUMult\b` → `booth_alu`
- `\bShiftReg\b` → `shift_reg`
- `\bmodule_clkdiv\b` → `clk_divider`
- `\bmodule_TopMult\b` → `mult_top`

## Signal rename patterns
- `\blisto_1\b` → `ready_1`
- `\blisto_2\b` → `ready_2`
- `\blisto0\b` → `ready0`
- `\blisto\b` → `ready`
- `\bresultado\b` → `result`
- `\bmillares\b` → `thousands`
- `\bcentenas\b` → `hundreds`
- `\bdecenas\b` → `tens`
- `\bunidades\b` → `ones`
- `\btransis\b` → `digit_sel`
- `\bseg\b` → `segments`

## File renames (old → new)
- `design/module_top_general.sv` → `design/top_general.sv`
- `design/module_teclado.sv` → `design/keypad.sv`
- `design/module_detector.sv` → `design/edge_detector.sv`
- `design/module_prio.sv` → `design/priority_mux.sv`
- `design/module_seg.sv` → `design/sevenseg_driver.sv`
- `design/module_BCD.sv` → `design/bin_to_bcd.sv`
- `design/module_BCDBin.sv` → `design/bcd_to_bin.sv`
- `design/module_clkdiv.sv` → `design/clk_divider.sv`
- `design/module_TopMult.sv` → `design/mult_top.sv`
- `sim/module_top_general_tb.sv` → `sim/top_general_tb.sv`

## Edited SV files
- `design/module_AluMult.sv`
- `design/module_antirebote.sv`
- `design/module_BCD.sv`
- `design/module_BCDBin.sv`
- `design/module_clkdiv.sv`
- `design/module_ControlMult.sv`
- `design/module_detector.sv`
- `design/module_prio.sv`
- `design/module_regMult.sv`
- `design/module_seg.sv`
- `design/module_teclado.sv`
- `design/module_TopMult.sv`
- `design/module_top_general.sv`
- `sim/module_AluMult_tb.sv`
- `sim/module_antirebote_tb.sv`
- `sim/module_BCDBin_tb.sv`
- `sim/module_BCD_tb.sv`
- `sim/module_ControlMult_tb.sv`
- `sim/module_detector_tb.sv`
- `sim/module_mult_top_tb.sv`
- `sim/module_prio_tb.sv`
- `sim/module_regMult_tb.sv`
- `sim/module_seg_tb.sv`
- `sim/module_teclado_tb.sv`
- `sim/module_top_general_tb.sv`

## Edited Makefiles
- `build/Makefile`

### VCD
The testbench keeps `$dumpfile("module_top_general_tb.vcd")` for compatibility.
