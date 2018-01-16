// EE 361
// LEGLite Single Cycle
// 
// Obviously, it's incomplete.  Just the ports are defined.
//

module LEGLiteSingle(
	iaddr,		// Program memory address.  This is the program counter
	draddrmem,		// Data memory address
	dwriteMem,		// Data memory write enable
	dreadMem,		// Data memory read enable
	dwdatamem,		// Data memory write output
	alu_out,	// Output of alu for debugging purposes
//	sign_extended_sig,
//	ALUin1,
//	rdata2,
//	wdata,
//	raddr2,
//	rdata1,
	clock,
	idataIF,		// Program memory output, which is the current instruction
	drdatamem,		// Data memory output
	wdataWB,
	waddrWB,
	reset
	);

output [15:0] iaddr;
output [15:0] alu_out;	
output dwriteMem;
output dreadMem;
output [15:0] draddrmem;
output [15:0] dwdatamem;
output [15:0] wdataWB;
output [2:0] waddrWB;
//output [15:0] sign_extended_sig;
//output [15:0] ALUin1;
//output [15:0] rdata2;
//output [15:0] wdata;
//output [2:0] raddr2;
//output [15:0] rdata1;
input clock;
input [15:0] idataIF; // Instructions 
input [15:0] drdatamem;	
input reset;

//wire branch; //pc logic wires
//wire reg2loc, dread, memtoreg, dwrite, alusrc, regwrite; //controller wires
//wire [2:0] alu_select;
//wire [2:0] raddr2; //raddr2Mux wires
//wire [15:0] wdata; 
//wire [15:0] rdata1ID;
//wire [15:0] dwdata;
//wire [15:0] rdata2ID; //register wires
//wire [15:0] sign_extended_sig; //sign extend immediate from idata
//wire [15:0] ALUin1; //ALUin2Mux wires
//wire [15:0] alu_out;
//wire zero_result; //alu wires
//wire [15:0] drdata;
//wire io_sw0, io_sw1;
//wire [6:0] io_display;
//wire [15:0] draddr;
//wire [15:0] iaddr;

//if regs
//if wires
wire NOP;
wire [15:0] idataIF;
wire [15:0] iaddr;

//id regs
reg [15:0] idataID;
reg [15:0] PCID;
//idwires
wire [15:0] rdata1ID;
wire [15:0] rdata2ID;
wire [15:0] sign_extended_sigID;
wire [2:0] raddr2;
wire reg2locID;
wire branchID;
wire dreadID;
wire memtoregID;
wire [2:0] alu_selectID;
wire dwriteID;
wire alusrcID;
wire regwriteID;

//EX regs
reg [15:0] PCEx;
reg branchEx;
reg dreadEx;
reg memtoregEx;
reg [2:0] alu_selectEx;
reg dwriteEx;
reg alusrcEx;
reg regwriteEx;
reg [15:0] rdata2Ex;
reg [15:0] rdata1Ex;
reg [2:0] waddrEx;
reg [15:0] sign_extended_sigEx;
//Ex wire
wire [15:0] ALUin1Ex;
wire [15:0] alu_out;
wire zero_result;

//Mem regs
reg [15:0] targetMem;
reg PCsrcMem;
reg dreadMem;
reg memtoregMem;
reg dwriteMem;
reg regwriteMem;
reg [15:0] draddrmem;
reg [15:0] dwdatamem;
reg [2:0] waddrmem;
//Mem wire
wire [15:0] drdatamem;

//WB regs
reg [15:0] alu_outWB;
reg [15:0] drdataWB;
reg memtoregWB;
reg regwriteWB;
reg [2:0] waddrWB;
//WB wire
wire [15:0] wdataWB;


//assign draddr = alu_out;
//assign dwdata = rdata2;
//assign PCsrc = BranchMem and ALUZeromem;

//update registers every clock cycle
always @(posedge clock)
begin
    //update ID regs
    PCID <= iaddr;
    idataID <= idataIF;
    
    //update EX regs
    PCEx <= PCID;
    regwriteEx <= regwriteID;
    memtoregEx <= memtoregID;
    branchEx <= branchID;
    dreadEx <= dreadID;
    dwriteEx <=  dwriteID;
    alu_selectEx <= alu_selectID;
    alusrcEx <= alusrcID;
    sign_extended_sigEx <= sign_extended_sigID;
    rdata1Ex <= rdata1ID;
    rdata2Ex <= rdata2ID;
    waddrEx <= idataID[2:0];
    
    //update Mem regs
    targetMem <= ((sign_extended_sigEx * 2) + PCEx);
    regwriteMem <= regwriteEx;
    memtoregMem <= memtoregEx;
    PCsrcMem <= (branchEx * zero_result);
    dreadMem <= dreadEx;
    dwriteMem <= dwriteEx;
    draddrmem <= alu_out;
    dwdatamem <= rdata2Ex;
    waddrmem <= waddrEx;
    
    //update WB regs
    regwriteWB <= regwriteMem;
    memtoregWB <= memtoregMem;
    drdataWB <= drdatamem;
    alu_outWB <= draddrmem;
    waddrWB <= waddrmem; 
    
end

//Ifetch
PCLogic PC_Circuit(
				// Outputs
		iaddr,	// Program counter (pc)
				// Inputs
		clock,
		targetMem,	//   sign extension from 7 bit constant
		PCsrcMem,	//   CBZ instruction
		NOP,
		reset		//   reset input
		);
		
//IDecode
		
Control Cntrl(
		reg2locID,
        branchID,
        dreadID,
        memtoregID,
        alu_selectID,
        dwriteID,
        alusrcID,
        regwriteID,
        idataID[15:13],
        NOP
        );

MUX2 raddr2Mux (
	raddr2,   // Output of multiplexer
	idataID[12:10],  // Input 0
	idataID[2:0],  // Input 1
	reg2locID    // 1-bit select
	);	

RegFile Register(
	rdata1ID,  // read data output 1
	rdata2ID,  // read data output 2
	clock,		
	wdataWB,   // write data input
	waddrWB,   // write address
	idataID[5:3],  // read address 1
	raddr2,  // read address 2
	regwriteWB    // write enable
	);	
	
SignExt Ext(
    sign_extended_sigID,
    idataID[12:6]
    );
    
//EX
    
MUX2 ALUin2Mux(
        ALUin1Ex,   // Output of multiplexer
        rdata2Ex,  // Input 0
        sign_extended_sigEx,  // Input 1
        alusrcEx    // 1-bit select
        );

ALU arithLogUnit(
	alu_out,      // 16-bit output from the ALU
	zero_result, // equals 1 if the result is 0, and 0 otherwise
	rdata1Ex,     // data input
	ALUin1Ex,     // data input
	alu_selectEx       // 3-bit select
	);


//mem
//update target
//update pcscrc

//DMemory_IO dmem(
//		drdatamem,  // read data
//		io_display,	// IO port connected to 7 segment display
//		clock,  // clock
//		draddrmem,   // address
//		dwdatamem,  // write data
//		dwriteMem,  // write enable
//		dreadMem,   // read enable
//		io_sw0, // IO port connected to sliding switch 0
//		io_sw1  // IO port connected to sliding switch 1
//		);
		
//write back
		
MUX2 RegWriteMux(
                wdataWB,   // Output of multiplexer
                alu_outWB,  // Input 0
                drdataWB,  // Input 1
                memtoregWB    // 1-bit select
                );
	
endmodule
