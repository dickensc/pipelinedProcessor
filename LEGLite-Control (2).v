// EE 361
// LEGLite 
// 
// The control module for LEGLite
//   The control will input the opcode value (3 bits)
//   then determine what the control signals should be
//   in the datapath
// 
//---------------------------------------------------------------
module Control(
		reg2loc,
		branch,
		memread,
		memtoreg,
		alu_select,
		memwrite,
		alusrc,
		regwrite,
		opcode,
		NOP
		);

output reg2loc;
output branch;
output memread;
output memtoreg;
output [2:0] alu_select; // Select to the ALU
output memwrite;
output alusrc;
output regwrite;
input  [2:0] opcode;
input NOP;

reg reg2loc;
reg branch;
reg memread;
reg memtoreg;
reg [2:0] alu_select;
reg memwrite;
reg alusrc;
reg regwrite;
wire NOP;

always @(opcode or NOP)
    if (NOP == 1)
    begin
            reg2loc = 0;   // Pick 2nd reg field
            branch = 0;    // Disable branch
            memread = 0;   // Disable memory
            memtoreg = 0;  // ALU to reg
            alu_select = 0; // Have ALU do an ADD
            memwrite = 0;  // Disable memory
            alusrc = 0;    // Select register for input to ALU
            regwrite = 0;  // Dont Write result back to register file
    end
    
    else 
    begin
	case(opcode)
	0:			// ADD instruction
		begin
		reg2loc = 0;   // Pick 2nd reg field
		branch = 0;    // Disable branch
		memread = 0;   // Disable memory
		memtoreg = 0;  // ALU to reg
		alu_select = 0; // Have ALU do an ADD
		memwrite = 0;  // Disable memory
		alusrc = 0;    // Select register for input to ALU
		regwrite = 1;  // Write result back to register file
		end
	1:			// SUB instruction
            begin
            reg2loc = 0;   // Pick 2nd reg field
            branch = 0;    // Disable branch
            memread = 0;   // Disable memory
            memtoreg = 0;  // ALU to reg
            alu_select = 1; // Have ALU do an sub
            memwrite = 0;  // Disable memory
            alusrc = 0;    // Select register for input to ALU
            regwrite = 1;  // Write result back to register file
            end
	3:			// LD instruction
                begin
                reg2loc = 0;   // Pick 2nd reg field
                branch = 0;    // Disable branch
                memread = 1;   // enable memory
                memtoreg = 1;  // Dmem to reg
                alu_select = 0; // Have ALU do an ADD
                memwrite = 0;  // Disable memory
                alusrc = 1;    // Select signextend for input to ALU
                regwrite = 1;  // Write result back to register file
                end
	4:			// ST instruction
                    begin
                    reg2loc = 1;   // Pick 2nd reg field
                    branch = 0;    // Disable branch
                    memread = 0;   // Disable memory read
                    memtoreg = 0;  // Select Data Mem to write to memory
                    alu_select = 0; // Have ALU do an ADD
                    memwrite = 1;  // Enable dmem write
                    alusrc = 1;    // Select signextend for input to ALU
                    regwrite = 0;  // Write result back to register file
                    end                
	5:			// CBZ instruction
                        begin
                        reg2loc = 1;   // Pick 2nd reg field
                        branch = 1;    // Disable branch
                        memread = 0;   // Disable memory read
                        memtoreg = 0;  // Select ALU to write to memory
                        alu_select = 2; // Have ALU pass through input1
                        memwrite = 0;  // Disable memory
                        alusrc = 0;    // Select register for input to ALU
                        regwrite = 0;  // Write result back to register file
                        end
 	6:			// ADDI instruction
                            begin
                            reg2loc = 0;   // Pick 2nd reg field
                            branch = 0;    // Disable branch
                            memread = 0;   // Disable memory read
                            memtoreg = 0;  // Select ALU to write to memory
                            alu_select = 0; // Have ALU do an ADD
                            memwrite = 0;  // Disable D memory write
                            alusrc = 1;    // Select signext for input to ALU
                            regwrite = 1;  // Write result back to register file
                            end
	7:			// ANDI instruction
                                begin
                                reg2loc = 0;   // Pick 2nd reg field
                                branch = 0;    // Disable branch
                                memread = 0;   // Disable memory read
                                memtoreg = 0;  // Select ALU to write to memory
                                alu_select = 4; // Have ALU do an AND
                                memwrite = 0;  // Disable D memory write
                                alusrc = 1;    // Select sign ext for input to ALU
                                regwrite = 1;  // Write result back to register file
                                end                                                                                    
	endcase
	end

endmodule