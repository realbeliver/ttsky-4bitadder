# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test 4-Bit Adder Behavior")

    # Define a helper to set A and B easily
    def set_inputs(a, b):
        # A is lower 4 bits, B is upper 4 bits
        # Formula: (B << 4) | A
        return (b << 4) | a

    # Case 1: 2 + 3 = 5
    dut.ui_in.value = set_inputs(2, 3)
    await ClockCycles(dut.clk, 1)
    dut._log.info(f"Input: A=2, B=3 | Output: {int(dut.uo_out.value)}")
    assert int(dut.uo_out.value) == 5

    # Case 2: 10 + 5 = 15 (Max sum without carry)
    dut.ui_in.value = set_inputs(10, 5)
    await ClockCycles(dut.clk, 1)
    dut._log.info(f"Input: A=10, B=5 | Output: {int(dut.uo_out.value)}")
    assert int(dut.uo_out.value) == 15

    # Case 3: 8 + 8 = 16 (Result: Sum=0, Carry=1)
    # uo_out[4] is the Carry bit, so value should be 16 (binary 0001 0000)
    dut.ui_in.value = set_inputs(8, 8)
    await ClockCycles(dut.clk, 1)
    dut._log.info(f"Input: A=8, B=8 | Output: {int(dut.uo_out.value)}")
    assert int(dut.uo_out.value) == 16 

    dut._log.info("All tests passed!")
