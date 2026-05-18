// Luis Leon Pineda
// Top Module 
// EE4321
// Top Module Written by Mark W. Welker for TXST EE4321 
// Mark W. Welker
// HDL 4321 Spring 2023
// Matrix addition assignment top module



module top ();

wire [255:0] DataBus;
logic nRead,nWrite,nReset,Clk;
logic [15:0] address;

logic Fail;

InstructionMemory  U1(Clk,DataBus, address, nRead,nReset);

MainMemory  U2(Clk,DataBus, address, nRead,nWrite, nReset);

Execution U3(Clk,DataBus, address, nRead, nWrite, nReset);

Matrix_alu  U4(Clk,DataBus, address, nRead,nWrite, nReset);

Integer_alu  U5(Clk,DataBus, address, nRead,nWrite, nReset);

TestMem  UTest(Clk,nReset);

  initial begin //. setup to allow waveforms for edaplayground
   $dumpfile("dump.vcd");
   $dumpvars(1);
    Fail = 0; // SETUP TO PASS TO START 
 end

always @(DataBus) begin // this block checks to make certain the proper data is in the memory.
		if (DataBus[31:0] == 32'hff000000)
// we are about to execute the stop
begin 
// Print out the entire contents of main memory so I can copy and paste.
			$display ( "memory location 0 = %h", U2.MainMemory[0]);
			$display ( "memory location 1 = %h", U2.MainMemory[1]);
			$display ( "memory location 2 = %h", U2.MainMemory[2]);
			$display ( "memory location 3 = %h", U2.MainMemory[3]);
			$display ( "memory location 4 = %h", U2.MainMemory[4]);
			$display ( "memory location 5 = %h", U2.MainMemory[5]);
			$display ( "memory location 6 = %h", U2.MainMemory[6]);
			$display ( "memory location 7 = %h", U2.MainMemory[7]);
			$display ( "memory location 8 = %h", U2.MainMemory[8]);
			$display ( "memory location 9 = %h", U2.MainMemory[9]);
			$display ( "memory location 10 = %h", U2.MainMemory[10]);
			$display ( "memory location 11 = %h", U2.MainMemory[11]);
			$display ( "memory location 12 = %h", U2.MainMemory[12]);
			$display ( "memory location 13 = %h", U2.MainMemory[13]);

			$display ( "Imternal Reg location 0 = %h", U3.InternalReg[0]);
			$display ( "Internal reg location 1 = %h", U3.InternalReg[1]);
			$display ( "Internal reg location 2 = %h", U3.InternalReg[2]);
			$display ( "Internal reg location 3 = %h", U3.InternalReg[3]);
			
		if (U2.MainMemory[0] == 256'h000900060008000d0008000300050009000b000900100007000c0005000e0006)
			$display ( "memory location 0 is Correct");
		else begin Fail = 1; $display ( "memory location 0 is Wrong"); end
		if (U2.MainMemory[1] == 256'h0007000500070009000c0008000e000700100009000f0008000c000700090006)
			$display ( "memory location 1 is Correct");
		else begin Fail = 1;$display ( "memory location 1 is Wrong"); end
		if (U2.MainMemory[2] == 256'h0010_000b_000f_0016_0014_000b_0013_0010_001b_0012_001f_000f_0018_000c_0017_000c)
			$display ( "memory location 2 is Correct");
		else begin Fail = 1;$display ( "memory location 2 is Wrong"); end
		if (U2.MainMemory[3] == 256'h003f002a0038005b003800150023003f004d003f00700031005400230062002a)
			$display ( "memory location 3 is Correct");
		else begin Fail = 1;$display ( "memory location 3 is Wrong"); end
		if (U2.MainMemory[4] == 256'h003600240030004e00300012001e0036004200360060002a0048001e00540024)
			$display ( "memory location 4 is Correct");
		else begin Fail = 1;$display ( "memory location 4 is Wrong"); end
		if (U2.MainMemory[5] == 256'h00100014001b0018000b000b0012000c000f0013001f001700160010000f000c)
			$display ( "memory location 5 is Correct");
		else begin Fail = 1;$display ( "memory location 5 is Wrong"); end
		if (U2.MainMemory[6] == 256'h0e700e34129c0eb80a2c0a200d200a920fae113a18d813500dce0f6615fc1164)
			$display ( "memory location 6 is Correct");
		else begin Fail = 1;$display ( "memory location 6 is Wrong"); end
		if (U2.MainMemory[7] == 256'h0000000000000000000000000000000000000000000000000000000000000000)
			$display ( "memory location 7 is Correct");
		else begin Fail = 1;$display ( "memory location 7 is Wrong"); end
		if (U2.MainMemory[8] == 256'h0000000000000000000000000000000000000000000000000000000000000000)
			$display ( "memory location 8 is Correct");
		else begin Fail = 1;$display ( "memory location 8 is Wrong"); end
		if (U2.MainMemory[9] == 256'h0000000000000000000000000000000000000000000000000000000000000000)
			$display ( "memory location 9 is Correct");
		else begin Fail = 1;$display ( "memory location 9 is Wrong"); end
		if (U2.MainMemory[10][15:0] == 16'h0024)
			$display ( "memory location 10 is Correct");
		else begin Fail = 1;$display ( "memory location 10 is Wrong"); end
		if (U2.MainMemory[11][15:0] == 16'h000c)
			$display ( "memory location 11 is Correct");
		else begin Fail = 1;$display ( "memory location 11 is Wrong"); end
		if (U2.MainMemory[12][15:0] == 16'h0000)
			$display ( "memory location 12 is Correct");
		else begin Fail = 1;$display ( "memory location 12 is Wrong"); end


		if (U3.InternalReg[0][15:0] == 16'h0013)
			$display ( "Interal reg location 0 is Correct");
		else begin Fail = 1; $display ( "Internal Register 0 is Wrong"); end
		if (U3.InternalReg[1] == 256'h01f8015001c002d801c000a8011801f8026801f80380018802a0011803100150)
			$display ( "Internal Reg location 1 is Correct");
		else begin Fail = 1; $display ( "Internal Register 1 is Wrong"); end
		if (U3.InternalReg[2][15:0] == 16'h001e)
			$display ( "Internal Reg location 2 is Correct");
		else begin Fail = 1; $display ( "Internal Register 2 is Wrong"); end

        if (Fail) begin
        $display("********************************************");
        $display(" Project did not return the proper values");
        $display("********************************************");
        end
        else begin
        $display("********************************************");
        $display(" Project PASSED memory check");
        $display("********************************************");
        end
        
        end

end


endmodule

