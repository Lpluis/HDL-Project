// This i s a header file that contains the parameters used in the entire project

// module adresses
parameter MainMemEn = 0;
parameter RegisterEn = 1;
parameter InstrMemEn = 2;
parameter AluEn = 3;
parameter ExecuteEn = 4;
parameter IntAlu = 5;

// Alu Register setup // same register sequence for both ALU's 
parameter AluStatusIn = 0;
parameter AluStatusOut = 1;
parameter ALU_Source1 = 2;
parameter ALU_Source2 = 3;
parameter ALU_Result = 4;
parameter Overflow_err = 5;

// opcodes
parameter MMult1 = 0;
parameter MMult2 = 1;
parameter MMult3 = 2;
parameter MAdd = 3;
parameter MSub = 4;
parameter MTranspose = 5;
parameter MScale = 6;
parameter MScaleImm = 7;
parameter Iadd = 8'h10;
parameter Isub = 8'h11;
parameter Imult = 8'h12;
parameter Idiv = 8'h13;

// Instructions
// add the data at location 0 to the data at location 1 and place result in location 2
//parameter Instruct1 = 32'h FF_02_00_01; // add first matrix to second matrix store in memory
//Execution Machine Instructions
//parameter Instruct1 = 32'h 10_02_00_01;
//parameter Instruct1 = 32'h FF_00_00_00;

parameter Instruct1 = 32'h 03_02_00_01; // add first matrix to second matrix store in memory
parameter Instruct2 = 32'h 06_03_00_0a; // scale matrix 1 by whats in location A store in memory
parameter Instruct3 = 32'h 10_10_0a_0b; // add 16 bit numbers in location a to b store in temp register
parameter Instruct4 = 32'h 04_04_03_00; //Subtract the first matrix from the result in step 2 and store the result somewhere else in memory. 
parameter Instruct5 = 32'h 05_05_02_00;//Transpose the result from step 1 store in memory
parameter Instruct6 = 32'h 07_11_03_08;//ScaleImm the result in step 2 by the result from step 3 store in a matrix register
parameter Instruct7 = 32'h 00_06_04_05; //Multiply the result from step 4 by the result in step 5, store in memory. 4x4 * 4x4
//parameter Instruct8 = 32'h 01_07_11_05; //Multiply the result from step 6 by the result in step 5, store in memory. 4x2 * 2x4
//parameter Instruct9 = 32'h 02_08_05_04; //Multiply the result from step 5 by the result in step 4, store in memory. 2x4 * 4x2

parameter Instruct8 = 32'h 12_0a_01_00;//Multiply the integer value in memory location 0 to location 1. Store it in memory location 0x0A
parameter Instruct9 = 32'h 11_12_0a_01;//Subtract the integer value in memory location 01 from memory location 0x0A and store it in a register
parameter Instruct10 = 32'h 13_0c_12_0a;//Divide the result from step 8 by the result in step 9  and store it in location 0x0B
parameter Instruct11 = 32'h FF_00_00_00; // stop

//MainMemory 

parameter    matrixMemory0 = 256'h0004_000c_0004_0022_0007_0006_000b_0009_0009_0002_0008_000d_0002_000f_0010_0003;
parameter    matrixMemory1 = 256'h0017_002d_0043_0016_0007_0006_0004_0001_0012_0038_000d_000c_0003_0005_0007_0009;

parameter   integerMemoryA = 256'h07;
parameter   integerMemoryB = 256'h0c;
