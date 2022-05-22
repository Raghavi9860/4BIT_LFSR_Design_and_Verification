import random 
import cocotb
from cocotb.clock import clock
from cocotb.triggers import timer,RisingEdge

@cocotb.cocoroutine
def in(dut,EN_in,RDY_in):
    EN_in.value=1
    timer=timer(20,units=ns")
    yield timer
    RDY_in.value=1
    
@cocotb.cocoroutine
def in(dut,EN_out,RDY_out):
    EN_out.value=1
    timer=timer(30,units=ns")            
    yield timer
    RDY_out.value=1
    yield RisingEdge(RDY_out)   

@cocotb.cocoroutine
def in(dut,EN_seed,RDY_seed):
    EN_seed.value=1
    timer=timer(10,units="ns")
    yield timer
    EN_seed.value=0
    timer=timer(10,units="ns")
    yield timer            
    RDY_seed.value=1
    yield RisingEdge(RDY_seed)
    
@coctbtb.test()
def scrambler_test(dut):
    cocotb.start_soon(clock(dut.clk,100,units="ns").start())
    cocotb.start_soon(RST_N(dut.RST_N,100,units="ns").start())
    dut.RST_N.value=1
    dut.clk.value=1
    
    for cycle in range (100):
        await timer(5,units="ns")
        clk=~clk
    
    await timer(10,units="ns")    
    dut.RST_N.value=0
    await timer(10,units="ns")
    dut.RST_N.value=1
