**📡 UART Protocol with Assertions**
This project implements a parameterized UART Transmitter and Receiver and verifies it using a Cocotb-based Python testbench.
The design is portable, reproducible, and runs entirely on open-source tools: Cocotb, Python, Icarus Verilog, and GTKWave.


**📝 Project Overview**
This project verifies a UART TX/RX communication system using:
✔ UART TX/RX modules in SystemVerilog
✔ Loopback architecture (TX → RX)
✔ Cocotb testbench with assertions
✔ Timing verification for start, data, parity, and stop bits
✔ Test patterns for corner-case validation
✔ Waveform inspection through GTKWave

All tests passed successfully with 100% correct data reception 

**📂 Repository Structure**
uart-protocol-with-assertions/
│
├── rtl/
│   ├── uart_params.sv                    # Global UART configuration
│   ├── uart_tx.sv                        # Transmitter module
│   ├── uart_rx.sv                        # Receiver module
│   └── uart_top.sv                       # Loopback integration
│
├── cocotb_testbench/
│   ├── test_uart.py                      # SystemVerilog + Cocotb test
│   └── test_coco_uart.py                 # Basic cocotb UART test
│
├── corrected_code/
│   ├── uart_tx_corrected.sv              # Corrected TX (LLM errors fixed)
│   └── uart_rx_corrected.sv              # Corrected RX 
│
├── simulations/
│   ├── uart_simulation.vcd               # Waveform output 
│   └── run instructions / Makefile
│
└── README.md

**⚙️ UART Configuration**
Parameter	  | Value	 | Description
DATA_BITS	    6	       Configurable data width
PARITY_EN	    1	       Parity enabled
PARITY_TYPE   0	       Even parity
STOP_DUR	    1	       One stop bit
BAUD_RATE	   9600	     Standard UART baud rate
CLK_FREQ	   100 MHz	 System clock

Defined in uart_params.sv 
.

**🔧 How to Run SystemVerilog Simulation**
This repository uses only two commands for full verification.

 **1️⃣ Run Cocotb Simulation**
python -m pytest test_uart.py --log-cli-level=INFO -s

This will:
>Run Cocotb testbench
>Apply test patterns
>Perform assertion checks
>Generate waveform: uart_simulation.vcd
>Print TX/RX verification results

 **2️⃣ Open the Waveform in GTKWave**
gtkwave uart_simulation.vcd

**🧵 Test Patterns Used**
Pattern	   Binary	    Purpose   	   Result
0	         000000	    All zeros	      PASS
63	       111111	    All ones        PASS
42	       101010	    Alternating 1	  PASS
21         010101	    Alternating 2	  PASS
51	       110011   	Mixed pattern 1	PASS
12	       001100   	Mixed pattern 2	PASS

Pass Rate: 100%
Zero corrupted data bits and zero timing violations. 

**🛠️ LLM-Generated Coding Errors Identified & Fixed**
The project includes five categories of real-world coding bugs, auto-generated and debugged:
  Error Type	                                   Issue
 Logical Operator Error                     && instead of `
 Missing MSB Initialization                 Highest bit never loaded
 Skip-by-2 Bit Counter	                    bit_cnt += 2 causing missing bits
 Off-by-One Frame Boundary	                Last frame byte ignored
 Repeated Transmissions	                    Missing deassertion handling

**📈 Key Achievements**
✔ Complete UART transmitter/receiver architecture
✔ Fully automated cocotb verification
✔ Portable, reproducible open-source workflow
✔ 100% data integrity and protocol correctness
✔ Detailed error analysis + corrected HDL implementations
✔ Clean documentation with timing diagrams & block diagrams

🔮 Future Enhancements
✔Multi-protocol verification (SPI, I²C, CAN)
✔Integration with GitHub Actions for CI
✔Hardware implementation on FPGA
✔Coverage-driven verification
✔AI-assisted waveform anomaly detection


