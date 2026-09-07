# Parameterized Synchronous FIFO in Verilog

A highly optimized, synthesizable, and parameterized Synchronous First-In, First-Out (FIFO) memory buffer implemented in Verilog. This design utilizes the **Pointer Wrap-Around (Extra-Bit)** approach to maximize hardware efficiency across area, power, and clock performance ($F_{max}$).

## 🚀 Architectural Highlights

Unlike a naive counter-based FIFO which requires a dedicated tracking register and introduces long combinational critical paths, this design optimizes performance by expanding the pointers by a single extra tracking bit:

* **No Occupancy Counter:** Eliminates centralized counter registers, significantly dropping dynamic power consumption during simultaneous read/write cycles.
* **Optimized Timing ($F_{max}$):** The status flags (`full` and `empty`) are derived via shallow, bitwise operations rather than conditional arithmetic, making it ideal for high-speed ASIC/FPGA designs.
* **Natural Binary Overflow:** Relies on structural bit-width sizing to automatically handle pointer wrapping without complex conditional boundaries.
* **Fully Parameterized:** Easily customize `addr` (Data Width) and `depth` (Memory Depth, must be a power of 2) via top-level parameters.

---

## 📐 Status Flag Logic Explained

For a FIFO of depth $2^N$, memory addresses require exactly $N$ bits. By declaring pointers with $N+1$ bits (`count = $clog2(depth)`), the MSB acts as a "wrap-around" tracking bit to isolate states cleanly:

* **Empty Condition:** Both pointers are identical across all bits.
  ```verilog
  assign empty = (wr_ptr == rd_ptr);
  ```
* **Full Condition:** The Most Significant Bits (MSBs) mismatch (indicating the write pointer has lapped the read pointer), while all lower index bits match.
  ```verilog
  assign full  = (wr_ptr[count] != rd_ptr[count]) && 
                 (wr_ptr[count-1:0] == rd_ptr[count-1:0]);
  ```

---

## 🛠️ Verification & Testbench Cases

The repository includes a comprehensive, self-checking behavioral testbench (`tb/sync_fifo_tb.v`) validating the following structural corner cases:
1. **Reset Verification:** Ensures flags drop into a safe initialized state (`empty = 1`, `full = 0`).
2. **Burst Write to Full:** Sequentially fills the memory array to check proper enforcement of the `full` flag.
3. **Overflow Protection:** Attempts to write to a completely full FIFO to ensure boundary data is safely protected.
4. **Burst Read to Empty:** Empties the FIFO sequentially while validating First-In, First-Out data ordering.
5. **Underflow Protection:** Tests boundary logic when reading from an empty buffer.
6. **Simultaneous Read/Write:** Validates concurrent operations without clock-slippage or state machine locking.

---

## 💻 How to Simulate

### Prerequisites
You can run this design using any standard HDL simulator (ModelSim, QuestaSim, Vivado XSIM, Icarus Verilog, or [EDA Playground](https://edaplayground.com)).

### Example via Icarus Verilog (iVerilog)
```bash
# Compile the RTL and Testbench
iverilog -o fifo_sim rtl/sync_fifo.v tb/sync_fifo_tb.v

# Run the simulation
vvp fifo_sim
```

---

## 📂 Code Highlights

### RTL Status Assignments
```verilog
// Automatic calculation of pointer bit widths based on Depth parameter
localparam count = \$clog2(depth);
reg [count:0] wr_ptr, rd_ptr;

assign empty = (wr_ptr == rd_ptr);
assign full  = (wr_ptr[count] != rd_ptr[count]) && 
               (wr_ptr[count-1:0] == rd_ptr[count-1:0]);
```
