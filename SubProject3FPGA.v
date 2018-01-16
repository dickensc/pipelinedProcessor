// EE 361L
// Subproject 3 FPGA Device
//  
// 
module FPGADevice(seg, clk, sw, btnC, an);


output [6:0] seg;
output [3:0] an; //anodes for 7segment display
input clk;
input [1:0] sw;
input btnC;

wire [15:0] iaddr; 	// Instruction memory addr
wire [15:0] draddr;	// Data memory addr
wire [15:0] dwdata;	// Data memory write-data
wire dwrite;	// Data memory write enable
wire dread;	// Data memory read enable
wire [15:0] alu_out;		// Output from the ALUOut register:  for debugging
wire [15:0] idata;	// Instruction memory read data
wire [15:0] drdata;	
wire [15:0] sign_extended_sig;
wire [15:0] ALUin1;
wire [15:0] rdata2;
wire [15:0] wdata;
wire [15:0] rdata1;
wire [2:0] raddr2;
 
assign an = 7;
	
LEGLiteSingle comp(
	iaddr,		// Program memory address.  This is the program counter
    draddr,        // Data memory address
    dwrite,        // Data memory write enable
    dread,        // Data memory read enable
    dwdata,        // Data memory write output
    alu_out,    // Output of alu for debugging purposes
    clk,
    idata,        // Program memory output, which is the current instruction
    drdata,        // Data memory output
    wdataWB,
    waddrWB,
    btnC
	);

// Instantiation of Instruction Memory (program)

IM instrmem(idata,iaddr);

// Instantiation of Data Memory

DMemory_IO datamemdevice(
		drdata,  // read data
        seg,    // IO port connected to 7 segment display
        clk,  // clock
        draddr,   // address
        dwdata,  // write data
        dwrite,  // write enable
        dread,   // read enable
        sw[0], // IO port connected to sliding switch 0
        sw[1]  // IO port connected to sliding switch 1
		);
endmodule
