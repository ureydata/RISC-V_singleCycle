`include "define.v"
module decode(
    instr_i,
    instr_addr_i,
    reg1_rdata_i,
    reg2_rdata_i,
    reg_wen_o,
    reg_waddr_o,
    reg1_raddr_o,
    reg2_raddr_o,
    op1_o,
    op2_o,
    op1_jump_o,
    op2_jump_o
);

    //input signal
    input wire  [`InstrWidth - 1:0]               instr_i;
    input wire  [`CpuWidth - 1:0]                 instr_addr_i;    
    input wire  [`CpuWidth - 1:0]                 reg1_rdata_i;
    input wire  [`CpuWidth - 1:0]                 reg2_rdata_i;

    //output signal  
    output reg                                     reg_wen_o; 
    output reg  [`RegAddrWidth - 1:0]              reg_waddr_o;
    output reg  [`RegAddrWidth - 1:0]              reg1_raddr_o;
    output reg  [`RegAddrWidth - 1:0]              reg2_raddr_o;
    output reg  [`CpuWidth-1:0]                   op1_o;
    output reg  [`CpuWidth-1:0]                   op2_o;
    output reg  [`CpuWidth-1:0]                   op1_jump_o;
    output reg  [`CpuWidth-1:0]                   op2_jump_o;      

	wire[6:0] opcode; 
	wire[4:0] rd; 
	wire[2:0] func3; 
	wire[4:0] rs1;
	wire[4:0] rs2;
	wire[6:0] func7;
	
	assign opcode = instr_i[6:0];
	assign rd 	  = instr_i[11:7];
	assign func3  = instr_i[14:12];
	assign rs1 	  = instr_i[19:15];
	assign rs2 	  = instr_i[24:20];
	assign func7  = instr_i[31:25];

    always @(*) begin
        reg_wen_o       = `WriteDisable;
        reg_waddr_o     = `ZeroReg;
        reg1_raddr_o    = `ZeroReg;
        reg2_raddr_o    = `ZeroReg;
        op1_o           = `ZeroWord;
        op2_o           = `ZeroWord;
        op1_jump_o      = `ZeroWord;
        op2_jump_o      = `ZeroWord;
        
        case (opcode)
            `INST_TYPE_R: begin
                case(func3) 
                    `INST_ADD_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
                        reg_wen_o       = `WriteEnable;
                        reg_waddr_o     = rd;
                        reg1_raddr_o    = rs1; 
                        reg2_raddr_o    = rs2;
                        op1_o           = reg1_rdata_i;
                        op2_o           = reg2_rdata_i;
                    end 
                    default: begin
                        reg_wen_o       = `WriteDisable;
                        reg_waddr_o     = `ZeroReg;
                        reg1_raddr_o    = `ZeroReg;
                        reg2_raddr_o    = `ZeroReg;
                    end
                endcase
            end
            `INST_TYPE_I: begin
                case(func3)
                    `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI, `INST_SLLI, `INST_SRI: begin
                        reg_wen_o       = `WriteEnable;
                        reg_waddr_o     = rd;
                        reg1_raddr_o    = rs1; 
                        reg2_raddr_o    = `ZeroReg;
                        op1_o           = reg1_rdata_i;
                        op2_o           = {{20{instr_i[31]}},instr_i[31:20]};        
                    end 
                    default: begin
                        reg_wen_o       = `WriteDisable;
                        reg_waddr_o     = `ZeroReg;
                        reg1_raddr_o    = `ZeroReg;
                        reg2_raddr_o    = `ZeroReg;
                    end 
                endcase
            end 
            `INST_TYPE_L: begin
                case (func3)
                    `INST_LB, `INST_LH, `INST_LW, `INST_LBU, `INST_LHU: begin
                        reg_wen_o       = `WriteEnable;
                        reg_waddr_o     = rd;
                        reg1_raddr_o    = rs1;
                        reg2_raddr_o    = `ZeroReg;                        
                        op1_o           = reg1_rdata_i;
                        op2_o           = {{20{instr_i[31]}}, instr_i[31:20]};
                    end
                    default: begin
                        reg_wen_o       = `WriteDisable;
                        reg_waddr_o     = `ZeroReg;
                        reg1_raddr_o    = `ZeroReg;
                        reg2_raddr_o    = `ZeroReg;
                    end
                endcase
            end 
            `INST_TYPE_S: begin
                case (func3)
                    `INST_SB, `INST_SW, `INST_SH: begin
                        reg_wen_o       = `WriteDisable;
                        reg1_raddr_o    = rs1;
                        reg2_raddr_o    = rs2;
                        op1_o           = reg1_rdata_i;
                        op2_o           = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
                    end
                    default: begin
                        reg_wen_o       = `WriteDisable;
                        reg_waddr_o     = `ZeroReg;
                        reg1_raddr_o    = `ZeroReg;
                        reg2_raddr_o    = `ZeroReg;
                    end
                endcase
            end            
            `INST_TYPE_B: begin
                case(func3)
                    `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin
                        reg1_raddr_o    = rs1;
                        reg2_raddr_o    = rs2;
                        op1_o           = reg1_rdata_i;
                        op2_o           = reg2_rdata_i;
                        op1_jump_o      = instr_addr_i;
                        op2_jump_o      = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
                    end 
                    default: begin
                        reg_wen_o       = `WriteDisable;
                        reg_waddr_o     = `ZeroReg;
                        reg1_raddr_o    = `ZeroReg;
                        reg2_raddr_o    = `ZeroReg;
                    end 

                endcase
            end 
            `INST_JAL: begin
                 reg_wen_o       = `WriteEnable;
                 reg_waddr_o     = rd;
                 reg1_raddr_o    = `ZeroReg;
                 reg2_raddr_o    = `ZeroReg;
                 op1_o           = instr_addr_i;
                 op2_o           = 32'h4;
                 op1_jump_o      = instr_addr_i;
                 op2_jump_o      = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
            end
            `INST_JALR:begin
                 reg_wen_o       = `WriteEnable;
                 reg_waddr_o     = rd;
                 reg1_raddr_o    = rs1;
                 reg2_raddr_o    = `ZeroReg;
                 op1_o           = instr_addr_i;
                 op2_o           = 32'h4;
                 op1_jump_o      = reg1_rdata_i;
                 op2_jump_o      = {{20{instr_i[31]}}, instr_i[31:20]};                 
            end 
            `INST_LUI: begin
                 reg_wen_o       = `WriteEnable;
                 reg_waddr_o     = rd;
                 reg1_raddr_o    = `ZeroReg;
                 reg2_raddr_o    = `ZeroReg;
                 op1_o           = {instr_i[31:12], 12'b0};
                 op2_o           = `ZeroWord;
             end
            
             `INST_AUIPC: begin
                 reg_wen_o       = `WriteEnable;
                 reg_waddr_o     = rd;
                 reg1_raddr_o    = `ZeroReg;
                 reg2_raddr_o    = `ZeroReg;
                 op1_o           = instr_addr_i;                 
                 op2_o           = {instr_i[31:12], 12'b0};                 
            end             
            default: begin 
                 reg_wen_o       = `WriteDisable;
                 reg_waddr_o     = `ZeroReg;
                 reg1_raddr_o    = `ZeroReg;
                 reg2_raddr_o    = `ZeroReg;   
            end 
       endcase        
    end


endmodule
