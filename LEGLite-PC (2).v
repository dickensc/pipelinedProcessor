// EE 361
// LEGLite
// 
// * PC and PC Control:  Program Counter and
//         the PC control logic

//--------------------------------------------------------------
// PC and PC Control
module PCLogic(
		pc,		// current pc value
		clock,	// clock input
		target,	// from sign extend circuit
		PCsrc,
		NOP,
		reset		// reset input
		);


output [15:0] pc;
output NOP;
input clock;
input reset;
input PCsrc;
input [15:0] target;

reg [15:0] pc; 
reg [1:0] state;
wire [15:0] target;
reg NOP;
wire PCsrc;

												    
// Program counter pc is updated
//   * if reset = 0 then pc = 0
//   * otherwise pc = pc +2
// What's missing is how pc is updated when a branch occurs

always @(posedge clock)
	begin
	if (reset==1) 
        begin
           pc <= 0;
           state <= 1;
           NOP <= 1;
        end
	else if (PCsrc == 1) 
        begin 
           pc <= target;
           state <= 1;
           NOP <= 1;
        end
	else if (state == 0) 
        begin 
            pc <= pc+2;
            state <= 1;
            NOP <= 1;
        end
    else if (state == 1)
        begin
            pc <= pc;
            NOP <= 0;
            state <= 2;
        end
    else
        begin
            pc <= pc;
            NOP <= 1;
            state <= state + 1;
        end
	end
		
endmodule