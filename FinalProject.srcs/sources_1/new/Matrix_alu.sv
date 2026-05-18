// Matrix ALU


module Matrix_alu (Clk,DataBus, address, nRead,nWrite, nReset);

    `include "params.vh" 
    
    input logic Clk, nRead, nWrite, nReset;
    input logic [31:0] address;
 
    inout [255:0] DataBus;
    
    logic [255:0] Result;
    logic [7:0] OpCode;
    logic [255:0] DataOut;
    logic [3:0][3:0][15:0] Matrix1;
    logic [3:0][3:0][15:0] Matrix2;
    logic ItsMe;
    
    enum {Reset, Source1Data, Source2Data, GetOpCode, DecodeOpCode, Mmult1, Mmult2, Mmult3, Madd, Msub, Mtranspose, Mscale, MscaleIm, ResultToBus, ResultAddress, StopDriving, StopWriting} state, nextstate;
    
    always_comb begin   
        case (state)
            
            Reset: begin
                Result = 0;
                OpCode = 'h00;
                ItsMe = 0;
                nextstate = Source1Data;
                //Matrix1
                Matrix1[0][0] = 0;
                Matrix1[0][1] = 0;
                Matrix1[0][2] = 0;
                Matrix1[0][3] = 0;
                //Row2
                Matrix1[1][0] = 0;
                Matrix1[1][1] = 0;
                Matrix1[1][2] = 0;
                Matrix1[1][3] = 0;
                //Row3
                Matrix1[2][0] = 0;
                Matrix1[2][1] = 0;
                Matrix1[2][2] = 0;
                Matrix1[2][3] = 0;
                //Row4
                Matrix1[3][0] = 0;
                Matrix1[3][1] = 0;
                Matrix1[3][2] = 0;
                Matrix1[3][3] = 0;                
                //Matrix2
                Matrix2[0][0] = 0;
                Matrix2[0][1] = 0;
                Matrix2[0][2] = 0;
                Matrix2[0][3] = 0;
                //Row 2
                Matrix2[1][0] = 0;
                Matrix2[1][1] = 0;
                Matrix2[1][2] = 0;
                Matrix2[1][3] = 0;
                //Row 3
                Matrix2[2][0] = 0;
                Matrix2[2][1] = 0;
                Matrix2[2][2] = 0;
                Matrix2[2][3] = 0;
                //Row4
                Matrix2[3][0] = 0;
                Matrix2[3][1] = 0;
                Matrix2[3][2] = 0;
                Matrix2[3][3] = 0;
                nextstate = Source1Data; 
            end
            Source1Data: begin
                if (address[15:12] ==  AluEn && address[3:0] == ALU_Source1 && ~nWrite)begin
                    //Row 1
                    Matrix1[0][0] = DataBus[15:0];
                    Matrix1[0][1] = DataBus[31:16];
                    Matrix1[0][2] = DataBus[47:32];
                    Matrix1[0][3] = DataBus[63:48];
                    //Row2
                    Matrix1[1][0] = DataBus[79:64];
                    Matrix1[1][1] = DataBus[95:80];
                    Matrix1[1][2] = DataBus[111:96];
                    Matrix1[1][3] = DataBus[127:112];
                    //Row3
                    Matrix1[2][0] = DataBus[143:128];
                    Matrix1[2][1] = DataBus[159:144];
                    Matrix1[2][2] = DataBus[175:160];
                    Matrix1[2][3] = DataBus[191:176];
                    //Row4
                    Matrix1[3][0] = DataBus[207:192];
                    Matrix1[3][1] = DataBus[223:208];
                    Matrix1[3][2] = DataBus[239:224];
                    Matrix1[3][3] = DataBus[255:240];
                    nextstate = Source2Data;
                end
                else begin
                    nextstate = Source1Data;              
                end
            end
            
            Source2Data: begin 
                if (address[15:12] ==  AluEn && address[3:0] == ALU_Source2 && ~nWrite) begin
                    //Row 1
                    Matrix2[0][0] = DataBus[15:0];
                    Matrix2[0][1] = DataBus[31:16];
                    Matrix2[0][2] = DataBus[47:32];
                    Matrix2[0][3] = DataBus[63:48];
                    //Row 2
                    Matrix2[1][0] = DataBus[79:64];
                    Matrix2[1][1] = DataBus[95:80];
                    Matrix2[1][2] = DataBus[111:96];
                    Matrix2[1][3] = DataBus[127:112];
                    //Row 3
                    Matrix2[2][0] = DataBus[143:128];
                    Matrix2[2][1] = DataBus[159:144];
                    Matrix2[2][2] = DataBus[175:160];
                    Matrix2[2][3] = DataBus[191:176];
                    //Row4
                    Matrix2[3][0] = DataBus[207:192];
                    Matrix2[3][1] = DataBus[223:208];
                    Matrix2[3][2] = DataBus[239:224];
                    Matrix2[3][3] = DataBus[255:240];
                    nextstate = GetOpCode;
                end
                else begin
                    nextstate = Source2Data;
                end
            end
            
            GetOpCode: begin
                if (address[15:12] ==  AluEn && address[3:0] == AluStatusIn && ~nWrite)begin
                    OpCode = DataBus; 
                    if (OpCode == MAdd) begin
                        nextstate = Madd;
                    end
                    else if (OpCode == MSub) begin
                        nextstate = Msub;
                    end    
                    else if (OpCode == MMult1) begin
                        nextstate = Mmult1;
                    end
                    else if (OpCode == MMult2) begin
                        nextstate = Mmult2;
                    end
                    else if (OpCode == MMult3) begin
                        nextstate = Mmult3;
                    end
                    else if (OpCode == MTranspose) begin
                        nextstate = Mtranspose;
                    end
                    else if (OpCode == MScale) begin
                        nextstate = Mscale;
                    end 
                    else if (OpCode == MScaleImm) begin
                        nextstate = MscaleIm;
                    end
                    else begin
                        nextstate = GetOpCode;
                    end
                end
            end
// Initial design option removed that step to make it faster in previous state                
/*            DecodeOpCode: begin
                if (OpCode == MAdd) begin
                    nextstate = Madd;
                end
                else if (OpCode == MSub) begin
                    nextstate = Msub;
                end    
                else if (OpCode == MMult1) begin
                    nextstate = Mmult1;
                end
                else if (OpCode == MMult2) begin
                    nextstate = Mmult2;
                end
                else if (OpCode == MMult3) begin
                    nextstate = Mmult3;
                end
                else if (OpCode == MTranspose) begin
                    nextstate = Mtranspose;
                end
                else if (OpCode == MScale) begin
                    nextstate = Mscale;
                end 
                else if (OpCode == MScaleImm) begin
                    nextstate = MscaleIm;
                end
                else begin
                    nextstate = DecodeOpCode;
                end
            end
 */   
            Madd: begin
                //Row1
                Result[15:0]    = Matrix1[0][0] + Matrix2[0][0];
                Result[31:16]   = Matrix1[0][1] + Matrix2[0][1];
                Result[47:32]   = Matrix1[0][2] + Matrix2[0][2]; 
                Result[63:48]   = Matrix1[0][3] + Matrix2[0][3];
                //Row2
                Result[79:64]   = Matrix1[1][0] + Matrix2[1][0];
                Result[95:80]   = Matrix1[1][1] + Matrix2[1][1];
                Result[111:96]  = Matrix1[1][2] + Matrix2[1][2];
                Result[127:112] = Matrix1[1][3] + Matrix2[1][3];
                //Row3
                Result[143:128] = Matrix1[2][0] + Matrix2[2][0];
                Result[159:144] = Matrix1[2][1] + Matrix2[2][1];
                Result[175:160] = Matrix1[2][2] + Matrix2[2][2];
                Result[191:176] = Matrix1[2][3] + Matrix2[2][3];
                //Row4
                Result[207:192] = Matrix1[3][0] + Matrix2[3][0];
                Result[223:208] = Matrix1[3][1] + Matrix2[3][1];
                Result[239:224] = Matrix1[3][2] + Matrix2[3][2];
                Result[255:240] = Matrix1[3][3] + Matrix2[3][3];
                nextstate = ResultToBus;
            end
            
            Msub: begin
                //Row1
                Result[15:0]    = Matrix1[0][0] - Matrix2[0][0];
                Result[31:16]   = Matrix1[0][1] - Matrix2[0][1];
                Result[47:32]   = Matrix1[0][2] - Matrix2[0][2]; 
                Result[63:48]   = Matrix1[0][3] - Matrix2[0][3];
                //Row2
                Result[79:64]   = Matrix1[1][0] - Matrix2[1][0];
                Result[95:80]   = Matrix1[1][1] - Matrix2[1][1];
                Result[111:96]  = Matrix1[1][2] - Matrix2[1][2];
                Result[127:112] = Matrix1[1][3] - Matrix2[1][3];
                //Row3
                Result[143:128] = Matrix1[2][0] - Matrix2[2][0];
                Result[159:144] = Matrix1[2][1] - Matrix2[2][1];
                Result[175:160] = Matrix1[2][2] - Matrix2[2][2];
                Result[191:176] = Matrix1[2][3] - Matrix2[2][3];
                //Row4
                Result[207:192] = Matrix1[3][0] - Matrix2[3][0];
                Result[223:208] = Matrix1[3][1] - Matrix2[3][1];
                Result[239:224] = Matrix1[3][2] - Matrix2[3][2];
                Result[255:240] = Matrix1[3][3] - Matrix2[3][3];                
                nextstate = ResultToBus;
            end
            
            Mmult1: begin
                Result[15:0]    = Matrix1[0][0]*Matrix2[0][0] + Matrix1[0][1]*Matrix2[1][0] + Matrix1[0][2]*Matrix2[2][0] + Matrix1[0][3]*Matrix2[3][0];
                Result[31:16]   = Matrix1[0][0]*Matrix2[0][1] + Matrix1[0][1]*Matrix2[1][1] + Matrix1[0][2]*Matrix2[2][1] + Matrix1[0][3]*Matrix2[3][1];
                Result[47:32]   = Matrix1[0][0]*Matrix2[0][2] + Matrix1[0][1]*Matrix2[1][2] + Matrix1[0][2]*Matrix2[2][2] + Matrix1[0][3]*Matrix2[3][2]; 
                Result[63:48]   = Matrix1[0][0]*Matrix2[0][3] + Matrix1[0][1]*Matrix2[1][3] + Matrix1[0][2]*Matrix2[2][3] + Matrix1[0][3]*Matrix2[3][3];
                //Row1
                Result[79:64]   = Matrix1[1][0]*Matrix2[0][0] + Matrix1[1][1]*Matrix2[1][0] + Matrix1[1][2]*Matrix2[2][0] + Matrix1[1][3]*Matrix2[3][0];
                Result[95:80]   = Matrix1[1][0]*Matrix2[0][1] + Matrix1[1][1]*Matrix2[1][1] + Matrix1[1][2]*Matrix2[2][1] + Matrix1[1][3]*Matrix2[3][1];
                Result[111:96]  = Matrix1[1][0]*Matrix2[0][2] + Matrix1[1][1]*Matrix2[1][2] + Matrix1[1][2]*Matrix2[2][2] + Matrix1[1][3]*Matrix2[3][2];
                Result[127:112] = Matrix1[1][0]*Matrix2[0][3] + Matrix1[1][1]*Matrix2[1][3] + Matrix1[1][2]*Matrix2[2][3] + Matrix1[1][3]*Matrix2[3][3];
                //Row2
                Result[143:128] = Matrix1[2][0]*Matrix2[0][0] + Matrix1[2][1]*Matrix2[1][0] + Matrix1[2][2]*Matrix2[2][0] + Matrix1[2][3]*Matrix2[3][0];
                Result[159:144] = Matrix1[2][0]*Matrix2[0][1] + Matrix1[2][1]*Matrix2[1][1] + Matrix1[2][2]*Matrix2[2][1] + Matrix1[2][3]*Matrix2[3][1];
                Result[175:160] = Matrix1[2][0]*Matrix2[0][2] + Matrix1[2][1]*Matrix2[1][2] + Matrix1[2][2]*Matrix2[2][2] + Matrix1[2][3]*Matrix2[3][2];
                Result[191:176] = Matrix1[2][0]*Matrix2[0][3] + Matrix1[2][1]*Matrix2[1][3] + Matrix1[2][2]*Matrix2[2][3] + Matrix1[2][3]*Matrix2[3][3];
                
                //Row3
                Result[207:192] = Matrix1[3][0]*Matrix2[0][0] + Matrix1[3][1]*Matrix2[1][0] + Matrix1[3][2]*Matrix2[2][0] + Matrix1[3][3]*Matrix2[3][0];
                Result[223:208] = Matrix1[3][0]*Matrix2[0][1] + Matrix1[3][1]*Matrix2[1][1] + Matrix1[3][2]*Matrix2[2][1] + Matrix1[3][3]*Matrix2[3][1];
                Result[239:224] = Matrix1[3][0]*Matrix2[0][2] + Matrix1[3][1]*Matrix2[1][2] + Matrix1[3][2]*Matrix2[2][2] + Matrix1[3][3]*Matrix2[3][2];
                Result[255:240] = Matrix1[3][0]*Matrix2[0][3] + Matrix1[3][1]*Matrix2[1][3] + Matrix1[3][2]*Matrix2[2][3] + Matrix1[3][3]*Matrix2[3][3];                
                nextstate = ResultToBus;            
            end
            
            Mmult2: begin
                
                nextstate = ResultToBus;
            end
            Mmult3: begin
            
                nextstate = ResultToBus;
            end
            Mtranspose: begin
                //Row1
                Result[15:0]    = Matrix1[0][0];
                Result[31:16]   = Matrix1[1][0];
                Result[47:32]   = Matrix1[2][0]; 
                Result[63:48]   = Matrix1[3][0];
                //Row2
                Result[79:64]   = Matrix1[0][1];
                Result[95:80]   = Matrix1[1][1];
                Result[111:96]  = Matrix1[2][1];
                Result[127:112] = Matrix1[3][1];
                //Row3
                Result[143:128] = Matrix1[0][2];
                Result[159:144] = Matrix1[1][2];
                Result[175:160] = Matrix1[2][2];
                Result[191:176] = Matrix1[3][2];
                //Row4
                Result[207:192] = Matrix1[0][3];
                Result[223:208] = Matrix1[1][3];
                Result[239:224] = Matrix1[2][3];
                Result[255:240] = Matrix1[3][3];                
                
                nextstate = ResultToBus;
            end
            Mscale , MscaleIm: begin
                //Row1
                Result[15:0]    = Matrix1[0][0] * Matrix2[0][0];
                Result[31:16]   = Matrix1[0][1] * Matrix2[0][0];
                Result[47:32]   = Matrix1[0][2] * Matrix2[0][0]; 
                Result[63:48]   = Matrix1[0][3] * Matrix2[0][0];
                //Row2
                Result[79:64]   = Matrix1[1][0] * Matrix2[0][0];
                Result[95:80]   = Matrix1[1][1] * Matrix2[0][0];
                Result[111:96]  = Matrix1[1][2] * Matrix2[0][0];
                Result[127:112] = Matrix1[1][3] * Matrix2[0][0];
                //Row3
                Result[143:128] = Matrix1[2][0] * Matrix2[0][0];
                Result[159:144] = Matrix1[2][1] * Matrix2[0][0];
                Result[175:160] = Matrix1[2][2] * Matrix2[0][0];
                Result[191:176] = Matrix1[2][3] * Matrix2[0][0];
                //Row4
                Result[207:192] = Matrix1[3][0] * Matrix2[0][0];
                Result[223:208] = Matrix1[3][1] * Matrix2[0][0];
                Result[239:224] = Matrix1[3][2] * Matrix2[0][0];
                Result[255:240] = Matrix1[3][3] * Matrix2[0][0];                
                nextstate = ResultToBus;
            end

            
            
            ResultToBus: begin
                ItsMe = 1;
                DataOut = Result;
                if (address[15:12] == AluEn & address[11:0] == AluStatusOut)
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
