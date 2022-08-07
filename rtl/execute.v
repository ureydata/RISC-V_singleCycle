`include "define.v"
module execute(
    instr_i,
    op1_i,
    op2_i,
    op1_jump_i,
    op2_jump_i,
    reg1_rdata_i,
    reg2_rdata_i,
    mem_rdata_i,
    reg_waddr_o,
    reg_wdata_o,
    mem_raddr_o,
    mem_wdata_o,
    mem_waddr_o,
    mem_we_o,
    jump_addr_o,
    jump_en_o
);

    //from fetch
    input wire  [`InstrWidth - 1:0]                    instr_i;

    //from decode
    input wire  [`CpuWidth - 1:0]                      op1_i;
    input wire  [`CpuWidth - 1:0]                      op2_i;
    input wire  [`CpuWidth - 1:0]                      op1_jump_i;
    input wire  [`CpuWidth - 1:0]                      op2_jump_i; 
    input wire  [`CpuWidth-1:0]                        reg1_rdata_i;
    input wire  [`CpuWidth-1:0]                        reg2_rdata_i;      

    //from data memory
    input wire  [`MemWidth - 1:0]                      mem_rdata_i;

 

   //to data memory   
    output reg  [`MemWidth - 1:0]                      mem_raddr_o;    
    output reg  [`MemWidth - 1:0]                      mem_waddr_o; 
    output reg  [`MemWidth - 1:0]                      mem_wdata_o;     
    output reg                                         mem_we_o;                   
 

    //to register files
    output reg  [`RegAddrWidth - 1:0]                  reg_waddr_o;
    output reg  [`CpuWidth-1:0]                        reg_wdata_o;

    //to PC register    
    output reg                                         jump_en_o;   
    output reg  [`CpuWidth-1:0]                        jump_addr_o;



    wire        [`CpuWidth - 1:0]                      op1_add_op2_res;
    wire                                               op1_eq_op2;
    wire                                               op1_ge_op2_signed;
    wire                                               op1_ge_op2_unsigned;
    wire        [31:0]                                 sr_shift;
    wire        [31:0]                                 sri_shift;
    wire        [31:0]                                 sr_shift_mask;
    wire        [31:0]                                 sri_shift_mask;    
    wire        [`CpuWidth - 1:0]                      op1_jump_add_op2_jump_res;
    wire        [1:0]                                  mem_raddr_index;
    wire        [1:0]                                  mem_waddr_index;


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

    // 有符号数比较
    assign op1_ge_op2_signed         = $signed(op1_i) >= $signed(op2_i);
    // 无符号数比较
    assign op1_ge_op2_unsigned       = op1_i >= op2_i;

    assign op1_add_op2_res           = op1_i + op2_i;
    assign op1_eq_op2                = (op1_i == op2_i);
    assign op1_jump_add_op2_jump_res = op1_jump_i + op2_jump_i;

    assign sr_shift                  = reg1_rdata_i >> reg2_rdata_i[4:0];
    assign sri_shift                 = reg1_rdata_i >> instr_i[24:20];
    assign sr_shift_mask             = 32'hffffffff >> reg2_rdata_i[4:0];
    assign sri_shift_mask            = 32'hffffffff >> instr_i[24:20];    


    assign mem_raddr_index           = (reg1_rdata_i + {{20{instr_i[31]}}, instr_i[31:20]}) & 2'b11;
    assign mem_waddr_index           = (reg1_rdata_i + {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]}) & 2'b11;

    always @(*) begin
        reg_waddr_o     = `ZeroReg;
        reg_wdata_o     = `ZeroWord;
        jump_en_o       = `JumpDisable;
        jump_addr_o     = `ZeroWord;
        mem_we_o        = `WriteDisable;
        mem_wdata_o     = `ZeroWord;
        mem_raddr_o     = `ZeroWord;
        mem_waddr_o     = `ZeroWord;
        case (opcode)
            `INST_TYPE_R: begin
                 case(func3)
                    `INST_ADD_SUB: begin
                        reg_waddr_o     = rd;
                        if(instr_i[30] == 1'b0) begin
                            reg_wdata_o = op1_add_op2_res;
                        end 
                        else begin
                            reg_wdata_o = op1_i - op2_i;
                        end       
                    end 
                    `INST_SLL: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i << op2_i[4:0];
                    end 
                    `INST_SLT: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = {32{(~op1_ge_op2_signed)}} & 32'h1;                       
                    end 
                    `INST_SLTU: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = {32{(~op1_ge_op2_unsigned)}} & 32'h1;   
                    end 
                    `INST_XOR: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i ^ op2_i;
                    end 
                    `INST_SR: begin
                        reg_waddr_o    = rd;
                        if(instr_i[30] == 1'b1) begin
                            reg_wdata_o = (sr_shift & sr_shift_mask) | ({32{reg1_rdata_i[31]}} & (~sr_shift_mask));
                        end 
                        else begin
                            reg_wdata_o = reg1_rdata_i >> reg2_rdata_i[4:0];
                        end       
                    end
                    `INST_OR: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i | op2_i;
                    end 
                    `INST_AND: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i & op2_i;                        
                    end 
                    default: begin
                        reg_wdata_o    = `ZeroWord;
                        reg_waddr_o    = `ZeroReg;
                    end  
                 endcase  
             end
            `INST_TYPE_I: begin
                case(func3)                  
                   `INST_ADDI: begin
                        reg_waddr_o     = rd;
                        reg_wdata_o     = op1_add_op2_res;      
                    end 
                   `INST_SLTI: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = {32{(~op1_ge_op2_signed)}} & 32'h1; 
                   end 

                   `INST_SLTIU: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = {32{(~op1_ge_op2_unsigned)}} & 32'h1;
                   end  
                   `INST_XORI: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i ^ op2_i;
                   end 
                   `INST_ORI: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i | op2_i;                       
                   end 
                   `INST_ANDI: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i & op2_i;
                   end 
                   `INST_SLLI: begin
                        reg_waddr_o    = rd;
                        reg_wdata_o    = op1_i << instr_i[24:20];
                   end 
                   `INST_SRI: begin
                        reg_waddr_o    = rd;
                        if(instr_i[30] == 1'b1) begin
                            reg_wdata_o = (sri_shift & sri_shift_mask) | ({32{reg1_rdata_i[31]}} & (~sri_shift_mask));
                        end 
                        else begin
                            reg_wdata_o = reg1_rdata_i >> instr_i[24:20];
                        end       
                   end 
                   default: begin
                       reg_waddr_o    =  `ZeroReg;
                       reg_wdata_o    =  `ZeroWord;
                   end 
                endcase
            end 
            `INST_TYPE_L: begin
                case(func3)
                    `INST_LB: begin
                        mem_raddr_o     = op1_add_op2_res;
                        case (mem_raddr_index)
                            2'b00: begin
                                reg_wdata_o = {{24{mem_rdata_i[7]}}, mem_rdata_i[7:0]};
                            end
                            2'b01: begin
                                reg_wdata_o = {{24{mem_rdata_i[15]}}, mem_rdata_i[15:8]};
                            end
                            2'b10: begin
                                reg_wdata_o = {{24{mem_rdata_i[23]}}, mem_rdata_i[23:16]};
                            end
                            default: begin
                                reg_wdata_o = {{24{mem_rdata_i[31]}}, mem_rdata_i[31:24]};
                            end
                        endcase                        
                    end
                    `INST_LH: begin
                        mem_raddr_o = op1_add_op2_res;
                        if (mem_raddr_index == 2'b0) begin
                            reg_wdata_o = {{16{mem_rdata_i[15]}}, mem_rdata_i[15:0]};
                        end else begin
                            reg_wdata_o = {{16{mem_rdata_i[31]}}, mem_rdata_i[31:16]};
                        end
                    end
                    `INST_LW: begin
                        mem_raddr_o = op1_add_op2_res;
                        reg_wdata_o = mem_rdata_i;
                    end 
                    `INST_LBU: begin
                        mem_raddr_o = op1_add_op2_res;
                        case (mem_raddr_index)
                            2'b00: begin
                                reg_wdata_o = {24'h0, mem_rdata_i[7:0]};
                            end
                            2'b01: begin
                                reg_wdata_o = {24'h0, mem_rdata_i[15:8]};
                            end
                            2'b10: begin
                                reg_wdata_o = {24'h0, mem_rdata_i[23:16]};
                            end
                            default: begin
                                reg_wdata_o = {24'h0, mem_rdata_i[31:24]};
                            end
                        endcase
                    end
                    `INST_LHU: begin
                        mem_raddr_o = op1_add_op2_res;
                        if (mem_raddr_index == 2'b0) begin
                            reg_wdata_o = {16'h0, mem_rdata_i[15:0]};
                        end else begin
                            reg_wdata_o = {16'h0, mem_rdata_i[31:16]};
                        end
                    end
                    default: begin
                        reg_waddr_o    =  `ZeroReg;
                        reg_wdata_o    =  `ZeroWord;
                        mem_raddr_o    =  `ZeroWord; 
                    end 
                endcase
            end
            `INST_TYPE_S: begin
                case (func3)
                    `INST_SB: begin
                        mem_we_o = `WriteEnable;
                        mem_waddr_o = op1_add_op2_res;
                        mem_raddr_o = op1_add_op2_res;
                        case (mem_waddr_index)
                            2'b00: begin
                                mem_wdata_o = {mem_rdata_i[31:8], reg2_rdata_i[7:0]};
                            end
                            2'b01: begin
                                mem_wdata_o = {mem_rdata_i[31:16], reg2_rdata_i[7:0], mem_rdata_i[7:0]};
                            end
                            2'b10: begin
                                mem_wdata_o = {mem_rdata_i[31:24], reg2_rdata_i[7:0], mem_rdata_i[15:0]};
                            end
                            default: begin
                                mem_wdata_o = {reg2_rdata_i[7:0], mem_rdata_i[23:0]};
                            end
                        endcase
                    end
                    `INST_SH: begin
                        mem_waddr_o = op1_add_op2_res;
                        mem_raddr_o = op1_add_op2_res;
                        if (mem_waddr_index == 2'b00) begin
                            mem_wdata_o = {mem_rdata_i[31:16], reg2_rdata_i[15:0]};
                        end else begin
                            mem_wdata_o = {reg2_rdata_i[15:0], mem_rdata_i[15:0]};
                        end
                    end
                    `INST_SW: begin
                        mem_we_o    = `WriteEnable;
                        mem_waddr_o = op1_add_op2_res;
                        mem_wdata_o = reg2_rdata_i;
                    end
                    default: begin
                        mem_wdata_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_we_o    = `WriteDisable;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                case(func3)
                    `INST_BEQ: begin
                        jump_en_o       = (op1_eq_op2) & `JumpEnable;
                        jump_addr_o     = {32{(op1_eq_op2)}} & op1_jump_add_op2_jump_res;
                    end 
                    `INST_BNE: begin
                        jump_en_o       = (~op1_eq_op2) & `JumpEnable;
                        jump_addr_o     = {32{(~op1_eq_op2)}} & op1_jump_add_op2_jump_res;
                    end 
                    `INST_BLT: begin
                        jump_en_o       = (~op1_ge_op2_signed) & `JumpEnable;
                        jump_addr_o     = {32{(~op1_ge_op2_signed)}} & op1_jump_add_op2_jump_res;
                    end 
                   `INST_BGE: begin
                        jump_en_o       = (op1_ge_op2_signed) & `JumpEnable;
                        jump_addr_o     = {32{(op1_ge_op2_signed)}} & op1_jump_add_op2_jump_res;
                    end
                    `INST_BLTU: begin
                        jump_en_o       = (~op1_ge_op2_unsigned) & `JumpEnable;
                        jump_addr_o     = {32{(~op1_ge_op2_unsigned)}} & op1_jump_add_op2_jump_res;
                    end 
                   `INST_BGEU: begin
                        jump_en_o       = (op1_ge_op2_unsigned) & `JumpEnable;
                        jump_addr_o     = {32{(op1_ge_op2_unsigned)}} & op1_jump_add_op2_jump_res;
                    end                    
                    default: begin
                        jump_en_o       = `JumpDisable;
                        jump_addr_o     = `ZeroWord;
                    end 
                endcase
            end 
            `INST_JAL, `INST_JALR: begin
                 jump_en_o       = `JumpEnable;
                 jump_addr_o     =  op1_jump_add_op2_jump_res;
                 reg_waddr_o     = rd;
                 reg_wdata_o     = op1_add_op2_res;
            end 
            `INST_LUI, `INST_AUIPC: begin
                 reg_waddr_o     = rd;
                 reg_wdata_o     = op1_add_op2_res;              
            end 
            default: begin    
                 reg_waddr_o     = `ZeroReg;
                 reg_wdata_o     = `ZeroWord;
                 jump_en_o       = `JumpDisable;
                 jump_addr_o     = `ZeroWord;
            end 
       endcase        
    end


endmodule
