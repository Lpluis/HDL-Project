// Integer ALU


module Integer_alu (Clk,DataBus, address, nRead,nWrite, nReset);

    `include "params.vh" 
    
    input logic Clk, nRead, nWrite, nReset;
    input logic [31:0] address;
    
    inout [255:0] DataBus;
    
    logic [255:0] Result;
    logic [255:0] Source1;
    logic [255:0] Source2;
    logic [7:0] OpCode;
    logic [255:0] DataOut;
    logic ItsMe;
    
    enum {Reset, SelectSource, Source1Data, Source2Data, GetOpCode, DecodeOpCode, IAdd, ISub, IMult, IDiv, ResultToBus, ResultAddress, StopDriving, StopWriting} state, nextstate;
    
    always_comb begin   
        case (state)
            
            Reset: begin
                Result = 0;
                Source1 = 0;
                Source2 = 0;
                OpCode = 'h00;    
                ItsMe = 0;
                nextstate = Source1Data;
                
            end         
                   
            SelectSource:begin
                if (address[15:12] ==  IntAlu && address[3:0] == ALU_Source1) begin
                    nextstate = Source1Data;
                end 
                else if (address[15:12] ==  IntAlu && address[3:0] == ALU_Source2) begin
                    nextstate = Source2Data;
                end
                else begin
                    nextstate = SelectSource;
                end
            end
            
            Source1Data: begin
                if (address[15:12] ==  IntAlu && address[3:0] == ALU_Source1 && ~nWrite)begin
                    Source1 = DataBus;
                    nextstate = Source2Data;
                end
                else begin
                    nextstate = Source1Data;              
                end
            end
            
            Source2Data: begin 
                if (address[15:12] ==  IntAlu && address[3:0] == ALU_Source2 && ~nWrite) begin
                    Source2 = DataBus;
                    nextstate = GetOpCode;
                end
                else begin
                    nextstate = Source2Data;
                end
            end
            
            GetOpCode: begin
                if (address[15:12] ==  IntAlu && address[3:0] == AluStatusIn && ~nWrite)begin
                    OpCode = DataBus;
                    if (OpCode == Iadd) begin
                        nextstate = IAdd;
                    end
                    else if (OpCode == Isub) begin
                        nextstate = ISub;
                    end    
                    else if (OpCode == Imult) begin
                        nextstate = IMult;
                    end
                    else if (OpCode == Idiv) begin
                        nextstate = IDiv;
                    end
                    else begin
                        nextstate = GetOpCode;
                    end
                    
                end
            end
                
            DecodeOpCode: begin
                if (OpCode == Iadd) begin
                    nextstate = IAdd;
                end
                else if (OpCode == Isub) begin
                    nextstate = ISub;
                end    
                else if (OpCode == Imult) begin
                    nextstate = IMult;
                end
                else if (OpCode == Idiv) begin
                    nextstate = IDiv;
                end
                else begin
                    nextstate = DecodeOpCode;
                end
            end
            
            IAdd: begin
                Result = Source1 + Source2;
                nextstate = ResultToBus;
            end
            
            ISub: begin
                Result = Source1 - Source2;
                nextstate = ResultToBus;
            end
            
            IMult: begin
                Result = Source1 * Source2;
                nextstate = ResultToBus;
            end
            
            IDiv: begin
                Result = Source1 / Source2;
                nextstate = ResultToBus;
            end
            
            ResultToBus: begin
                ItsMe = 1;
                DataOut = Result;
                if (address[15:12] == IntAlu & address[11:0] == AluStatusOut)
                    nextstate = ResultAddress;
                else 
                    nextstate = ResultToBus;                           
            end
            
            ResultAddress: begin
               
                    nextstate = StopDriving;
            end

            StopWriting: begin
                nextstate = StopDriving;
            end
            
            StopDriving: begin
                ItsMe = 0;
                nextstate = Source1Data;
            end
            default nextstate = Reset; 
        endcase 
    end
    
    always_ff @(posedge Clk, negedge nReset)
        if (~nReset) begin
            state <= Reset;
            end
        else begin
            state <= nextstate;
        end
     
    assign DataBus = ItsMe? DataOut : 256'bz; 
        
endmodule
