import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock

@cocotb.test()
async def uart_basic_test(dut):
    """Basic UART test"""
    dut._log.info("Starting UART test")
    
    # Create clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    dut.tx_start.value = 0
    dut.tx_data.value = 0
    
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    await Timer(100, units="ns")
    
    # Test simple pattern
    test_val = 0b101010
    dut._log.info(f"Testing value: {test_val:06b}")
    
    dut.tx_data.value = test_val
    dut.tx_start.value = 1
    await RisingEdge(dut.clk)
    dut.tx_start.value = 0
    
    # Wait for completion
    timeout = 1000
    for i in range(timeout):
        await RisingEdge(dut.clk)
        if dut.rx_done.value == 1:
            break
    else:
        assert False, "Timeout"
    
    assert dut.rx_data.value == test_val, f"Data mismatch: {dut.rx_data.value} != {test_val}"
    
    dut._log.info("Test passed!")
