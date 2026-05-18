// Test Bench 
// Generates Clock and reset signal for the execution machine. 

module TestMem  (Clk, nReset);

    `include "params.vh"
    
    
    output logic Clk,  nReset; 
    //output logic [15:0] address; nRead, nWrite,,nRead,nWrite ,address,DataBus
    //inout [255:0] DataBus;
    
    logic [255:0] counter = 256'b0;
    //logic [255:0] InitInstruction [1:0];  
    //logic ItsMe;
    
    initial begin 
        nReset = 1;
        #5 nReset = 0;
        #5 nReset = 1;
        
    end
    
    always begin // create a clock signal 
        Clk = 0;
        forever #5 Clk = ~Clk;
    end
    
    always_ff @(posedge Clk) begin
        counter <= counter +1;
    end
    
    /*
    always_ff @(negedge Clk) begin //counter for case statements 
        counter <= counter +1;
    end 
    
    always_comb begin
        case (counter) 
            1:  begin nReset = 1; nRead = 1; nWrite = 1; address [15:0] = 16'h0; ItsMe = 0;end //Initialize all the values
            2:  begin nReset = 0; end // Perform Reset 
            3:  begin nReset = 1;end  // Finish Reset
            4:  begin address[15:11] = InstrMemEn; // Set address to instruction memory
                address [10:0] = 0; // Lower address for Instruct1
                nRead = 0; end // Start the read process 
            5:  begin address[15:11] = MainMemEn;  // Address for Main Memory
                address [10:0] = 0; // Lower address for MainMem[0]
                nWrite = 0;  // Start Write Process
                nRead = 1; // End Read process 
                end 
            6:  begin nWrite = 1;   // End write process
                nRead = 0; // Start Read Process
                if (counter == 6) begin
                    InitInstruction[0] = DataBus;
                    end
                end
            7:  begin address[15:11] = InstrMemEn; // Address for Instruction Memory
                address[10:0] = 2; // Lower address for Instrct2
                nWrite = 0;  // Start Write Proces
                if (counter == 7) begin 
                    InitInstruction[1] = DataBus;
                    end
                end
            8:  begin nWrite = 1; InitInstruction[0] = InitInstruction[1] + InitInstruction[0]; end // End Write Process
            //10: begin address[15:11] = MainMemEn;
            //    address [10:0] = 1; 
            //    nWrite = 0; end
            9: begin nWrite = 1 ; nRead = 1; end
            10: begin address[15:11] = MainMemEn ; address[10:0] = 1 ; end
            11: begin nWrite = 0; ItsMe = 1; end
            12: begin ItsMe = 0; nWrite = 1; end
            15: $stop;                   
            
            default : nReset = 1;
          
        
        endcase 
    end
assign DataBus = ItsMe? InitInstruction[0] : 256'bz;  // Drives the bus after the addition is performed
    */
endmodule 