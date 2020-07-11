`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2020 21:09:55
// Design Name: 
// Module Name: dataPath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dataPath(
		// Control Signals
		//Main control signals
		input regDest, regWrite, extOp, ALUSrc, Beq, Bne, J, memRead, memWrite, mem2Reg, 
		//ALU control signal
		input  [3:0] ALUOpr,
		output [5:0] opCode,
		output [5:0] funct, 
		input reset,//INPUT TO PC REGISTER
		input clk ,
		output [29:0] PC, //output of pc register
		output [31:0] instr,//output of instMem
		output [31:0]destRegData//output of WB mux 
    );

	

	    
    	wire [29:0] pcNext, incPC, targetAddress;
    	wire [31:0] extImmediate, aluResult ;
    	 
    	wire [31:0] outRs, outRt,aluOprd2, dataOut;
    	wire [4:0] destReg;
    		
    		/* *************************************************************************
    			R-Type : opCode, Rs, Rt, Rd, shamt, funct
    		 
    			I-Type : opCode, Rs, Rt, immediate 
    			
    			J-Type : opCode, jump address
    			
    			*************************************************************************
    		*/ 
    		 
    	 // ************ All types
    	 assign opCode 	= instr[31:26];  	// 6-bit opcode
    	 // ************ R and I types
    	 wire [4:0] rs 		= instr[25:21];    	 // 5-bit source register
    	 wire [4:0] rt 		= instr[20:16];      // 5-bit target register	 
    	 // ************ R-Type
    	 wire [4:0] rd 	= instr[15:11];   	     // 5-bit destination register
    	 wire [4:0] shamt = instr[10:6];   		 // 5-bit shift amount
    	 assign funct = instr[5:0]; 			 // 6-bit function
    	 // ************ I-Type
    	 wire [15:0] immediate = instr[15:0];   // 16-bit immediate
    	 // ************ J-Type
          wire [25:0] jumpAddress = instr[25:0]; // 26-bit target address    	
           
    	 assign incPC = PC + 1;
    	 
    	mux2     #(30) muxTarget (incPC, targetAddress, PCSrc, pcNext); 
    	register #(30) pcReg(pcNext, PC, clk, reset);
    	
    	
    	instMem  #(32,6) IMEM(PC[5:0], instr); // use the lower 6-bit to address IRAM
    	
    	mux2     #(5)   muxDest(rt, rd, regDest, destReg);
    	
    	regFile RF(rs, rt, destReg, regWrite, outRs, outRt, destRegData, clk);
    
    	extension #(16, 32) E(immediate, extImmediate, extOp);
    	
    	mux2 #(32) aluSrc2(outRt, extImmediate, ALUSrc, aluOprd2);
    	
    	ALU  aluUnit(outRs, aluOprd2, ALUOpr, aluResult, zero);
    
    	dataMem #(32, 6) DMEM(aluResult[5:0], outRt, dataOut, memRead, memWrite, clk);
    
    	mux2 #(32) WB(aluResult, dataOut, mem2Reg, destRegData);
    	
    	
    	nextPC  nextPCb(incPC, jumpAddress, targetAddress, Beq, Bne, J, zero, PCSrc); 
    
    endmodule