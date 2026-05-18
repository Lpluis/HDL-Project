// Execution Engine
// Written By Luis Leon Pineda
// Execution engine for the project. 

module Execution (Clk,DataBus, address, nRead,nWrite, nReset);
    
    `include "params.vh" 
    
    input logic Clk, nReset;
    output logic [31:0] address;
    output logic nRead, nWrite;
    inout logic [255:0] DataBus;

    //Internal Registers
    
    logic ItsMe;
    logic [31:0]     InternalInstruction;
    logic [255:0]    InternalReg[3:0] ;
    logic [255:0]    DataOut;
    logic [15:0]     InstructionCounter;
    logic [7:0]     OpCode;
    enum    {Reset, GetInstruction, SaveInstr, // Instruction Related Steps
            Src1ToMem, Src1ToALU, AluWriteSrc1,PassiveSet1, // Source1 Related Steps
            Src2ToMem, Src2ToALU, AluWriteSrc2, PassiveSet2, //Source2 Related Steps
            OpCodetoAlu, AluStart,ResultToExecution, AluWait, ExecToMem, 
            TestState, ResultPassiveSet} state, nextstate;
    
    
    always_comb begin 
        case (state)
            Reset: begin
                DataOut = 256'hz;
                ItsMe = 0;
                InternalReg[0] = 'h0; 
                InternalReg[1] = 'h0;
                InternalReg[2] = 'h0;
                InternalReg[3] = 'h0;
                InternalInstruction = 'h0;
                nRead = 1;
                nWrite = 1; 
                InstructionCounter = 0;
                address = 'h0;
                OpCode = 'h00;
                nextstate = GetInstruction;
            end
            
            GetInstruction: begin
                address[15:12] = InstrMemEn;
                address[11:0] = InstructionCounter[11:0];
                nRead = 0;
                nextstate = SaveInstr;
            end
            
            SaveInstr: begin
                nRead = 1; 
                InternalInstruction = DataBus[31:0];
                InstructionCounter = InstructionCounter +1;
                if (InternalInstruction[31:24] == 'hFF) $stop;
                else nextstate = Src1ToMem;
            end
            
            Src1ToMem: begin
                OpCode = InternalInstruction[31:24];
                nextstate = Src1ToALU;
                if (InternalInstruction[15:12] == 'h1) begin
                    address[15:12] = ExecuteEn;
                    address[11:0] = InternalInstruction[11:8];
                    DataOut = InternalReg[InternalInstruction[11:8]]; 
                end 
                else begin
                    address[15:12] = InternalInstruction[15:12];
                    address[11:0] = InternalInstruction[11:8];
                    nRead =0 ;
                end
            end
            
            Src1ToALU: begin
                
                nextstate = AluWriteSrc1;
                nWrite = 0;
                ItsMe = 1;
                if (InternalInstruction [15:12] != 'h1)
                    DataOut = DataBus;
            end
            
            AluWriteSrc1: begin
                nRead = 1;
                nextstate = PassiveSet1;
                if (InternalInstruction[31:28] == 'h1) begin
                    address [15:12] = IntAlu;
                    address [11:0] = ALU_Source1;     
                end
                else
                    address[15:12] = AluEn;
                    address [11:0] = ALU_Source1;                    
                end
            
            PassiveSet1: begin
                ItsMe = 0;
                nWrite = 1;
                nextstate = Src2ToMem;
            end
                
            Src2ToMem: begin
                ItsMe = 0;
                nextstate = Src2ToALU;
                if (OpCode[3:0] ==  MScaleImm) begin
                    DataOut = InternalInstruction[3:0];
                    nextstate = Src2ToALU;
                    
                end
                else if (InternalInstruction[7:4] == 'h1) begin
                    DataOut = InternalReg[InternalInstruction[3:0]]; 
                end 
                else begin
                    address[15:12] = InternalInstruction[7:4];
                    address[11:0] = InternalInstruction[3:0];
                    nRead =0 ;
                end
            end
            
            Src2ToALU: begin 
                nextstate = AluWriteSrc2;
                nWrite = 0;
                ItsMe = 1;
                if (OpCode[3:0] != MScaleImm)
                    DataOut = DataBus;
                    
            end
            
            AluWriteSrc2: begin
                nRead = 1;
                nextstate = PassiveSet2;
                if (InternalInstruction[31:28] == 'h1) begin
                    address [15:12] = IntAlu;
                    address [11:0] = ALU_Source2;     
                end
                else
                    address[15:12] = AluEn;
                    address [11:0] = ALU_Source2;                     
            end
            
            PassiveSet2:begin
                ItsMe = 0;
                nWrite = 1;
                nextstate = OpCodetoAlu;
            end
            
            OpCodetoAlu: begin
                ItsMe = 1; 
                DataOut = OpCode; 
                nWrite = 0;
                address [11:0] = AluStatusIn;
                nextstate = AluStart; 
                if (InternalInstruction[31:28] == 'h1) 
                    address [15:12] = IntAlu;
                else
                    address [15:12] = AluEn; 
            end
            
            AluStart: begin
                nextstate = AluWait;
                ItsMe = 0;
                nWrite = 1; 
                address[11:0] = AluStatusOut;
                if (InternalInstruction[31:28] == 'h1) 
                    address [15:12] = IntAlu;
                else
                    address [15:12] = AluEn;  
            end
            
            AluWait: nextstate = ResultToExecution; // needed to kill one clock cycle... AKA 13 Cycles total. Looking into how to remove it. 

            ResultToExecution: begin
                address[15:12] = InternalInstruction[23:20];
                address[11:0] = InternalInstruction[19:16];
                if (InternalInstruction[23:20] == 'h1) begin
                    //address [15:12] = ExecuteEn;
                    //address [11:0] = InternalInstruction[19:16];
                    InternalReg[InternalInstruction[19:16]] = DataBus; 
                    nextstate = ExecToMem;  /// Change this to the correct step after saving stuff to Data.
                     
                end
                else    
                    DataOut = DataBus;
                    //address[15:12] = InternalInstruction[23:20];
                    //address[11:0] = InternalInstruction[19:16];
                    nextstate = ExecToMem; 
            end
            
            ExecToMem: begin
                nWrite = 0;
                ItsMe = 1;
                nextstate = ResultPassiveSet; 
            end
    
            ResultPassiveSet: begin
                nWrite = 1;
                ItsMe = 0; 
                nextstate = GetInstruction; 
            end
                 
            TestState: $stop;
        endcase    
    end
        
    always_ff @(posedge Clk, negedge nReset) // Sets the Case statements to switch with asynchronous reset. 
        if (~nReset) begin
            state <= Reset;
            end
        else begin
            state <= nextstate;
        end

    assign DataBus = ItsMe? DataOut : 256'bz;  
    
endmodule 