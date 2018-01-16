// EE 361L
// testbench for FPGA device
// 
module testbench;


reg [1:0] sw;
wire [6:0] io_display;
wire [2:0] an;

reg  clock;
reg  reset;		// Reset

// Clock
initial clock=0;
always #1 clock=~clock;


initial 
	begin
	$display("\nIO[display,switch0,switch1] Signals[clock,reset,time]");
	reset=1;
	sw[0]=1;
	sw[1]=0;
	#2
	reset=0;
	#100
	sw[0]=0;
	sw[1]=0;
	#200
	$finish;
	end


initial
	begin

	$monitor("IO[%b,%b,%b], an[%b] Signals[%b,%b,%0d]",
		io_display,
		sw[0],
		sw[1],
		an,
		clock,
		reset,
		$time
		);
	end
//

FPGADevice fpgadev1(io_display, clock, sw, reset, an);


endmodule