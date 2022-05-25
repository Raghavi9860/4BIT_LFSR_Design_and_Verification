import random 
import cocotb
from cocotb.triggers import timer,RisingEdge

@cocotb.cocoroutine
def RST_N(dut,value):
    
    yield RisingEdge(dut.RST_N)
    dut.RST_N.value=1
    
@cocotb.cocoroutine
def CLK(dut,vlaue):
    
    yield RisingEdge(dut.CLK)
    dut.CLK.value=1
    
@coctbtb.test()
def scrambler_test(dut):
    
    cocotb.start_soon(RST_N(dut.RST_N,100,units="ns").start())
    
    dut.log.info("Start if test!")            
    
    yield Timer(10, units="ns")
    dut.log.info("Drive 0 to RST_N!")
    dut.RST_N=0
                
    yield Timer(10, units="ns")
    dut.log.info("Drive 1 to RST_N!")
    dut.RST_N=1
    
    for cycle in range (100):
        yield timer(5,units="ns")
        clk=~clk
    
    dut.log.info("Test is Done!")
