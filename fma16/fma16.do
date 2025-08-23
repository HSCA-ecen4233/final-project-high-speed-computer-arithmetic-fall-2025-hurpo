# Copyright 1991-2024 Mentor Graphics Corporation
# 
# Modification by Oklahoma State University
# Use with Testbench 
# James Stine, 2008
# Go Cowboys!!!!!!
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile source files
vlog -lint fma16.sv testbench.sv

# start and run simulation
vsim -voptargs=+acc work.tb_fma16

# Diplays All Signals recursively
# add wave -hex -r /stimulus/*
add wave -noupdate -divider -height 32 "fma16"
add wave -color gold -hex /tb_fma16/clk
add wave -hex /tb_fma16/reset
add wave -hex /tb_fma16/x
add wave -hex /tb_fma16/y
add wave -hex /tb_fma16/z
add wave -hex /tb_fma16/result
add wave -hex /tb_fma16/rexpected

run -all
quit

