@echo off
REM ****************************************************************************
REM Vivado (TM) v2018.1 (64-bit)
REM
REM Filename    : compile.bat
REM Simulator   : Mentor Graphics ModelSim Simulator
REM Description : Script for compiling the simulation design source files
REM
REM Generated by Vivado on Fri Sep 25 10:28:04 +0800 2020
REM SW Build 2188600 on Wed Apr  4 18:40:38 MDT 2018
REM
REM Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
REM
REM usage: compile.bat
REM
REM ****************************************************************************
set bin_path=F:\\modelsim64_10.1c\\win64
call %bin_path%/vsim  -c -do "do {decrypt_top_tb_compile.do}" -l compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
