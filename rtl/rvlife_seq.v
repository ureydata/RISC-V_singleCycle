`include "define.v"
module rvlife_seq(
    clk,
    rstn,
);

    //input from top_cpu to all
    input wire                         clk;
    input wire                         rstn;
    
    //from execute to pc_reg
    wire                                           jump_en;
    wire        [`CpuWidth - 1:0]                 jump_addr; 

    //from pc_reg to fetch
    wire        [`CpuWidth - 1:0]                 pc;

    //from fetch to decode and execute
    wire        [`CpuWidth - 1:0]                 instr_addr;
    wire        [`InstrWidth - 1:0]               instr;        
 
    //from decode to regs_file
    wire                                           reg_wen; 
    wire        [`RegAddrWidth - 1:0]              reg_waddr;
    wire        [`RegAddrWidth - 1:0]              reg1_raddr;
    wire        [`RegAddrWidth - 1:0]              reg2_raddr;

    //from regs_file to decode
    wire        [`CpuWidth - 1:0]                 reg1_rdata;
    wire        [`CpuWidth - 1:0]                 reg2_rdata;    

    //from decode to execute
    wire        [`CpuWidth-1:0]                   op1;
    wire        [`CpuWidth-1:0]                   op2;
    wire        [`CpuWidth-1:0]                   op1_jump;
    wire        [`CpuWidth-1:0]                   op2_jump;

    //from ram to execute
    wire        [`MemWidth - 1:0]                 mem_rdata;

    //from execute to ram
    wire                                           mem_wen; 
    wire        [`MemWidth - 1:0]                  mem_wdata;
    wire        [`MemWidth - 1:0]                  mem_waddr;
    wire        [`MemWidth - 1:0]                  mem_raddr;    


  

    //from execute to regs_file
    wire        [`CpuWidth-1:0]                    reg_wdata;
    
pc_reg u_pc_reg(
    .clk_i(clk),
    .rstn_i(rstn),
    .jump_en_i(jump_en),
    .jump_addr_i(jump_addr),
    .pc_o(pc)    
);

fetch u_fetch(
    .instr_addr_i(pc),
    .instr_o(instr),
    .instr_addr_o(instr_addr)
);

decode u_decode(
    .instr_i(instr),
    .instr_addr_i(instr_addr),
    .reg1_rdata_i(reg1_rdata),
    .reg2_rdata_i(reg2_rdata),
    .reg_wen_o(reg_wen),
    .reg_waddr_o(reg_waddr),
    .reg1_raddr_o(reg1_raddr),
    .reg2_raddr_o(reg2_raddr),
    .op1_o(op1),
    .op2_o(op2),
    .op1_jump_o(op1_jump),
    .op2_jump_o(op2_jump)
);

regs_file u_regs_file(
    .clk_i(clk),
    .rstn_i(rstn),
    .reg_wen_i(reg_wen),
    .reg_waddr_i(reg_waddr),
    .reg_wdata_i(reg_wdata),
    .reg1_raddr_i(reg1_raddr),
    .reg2_raddr_i(reg2_raddr),
    .reg1_rdata_o(reg1_rdata),
    .reg2_rdata_o(reg2_rdata)
);

execute u_execute(
    .instr_i(instr),
    .op1_i(op1),
    .op2_i(op2),
    .op1_jump_i(op1_jump),
    .op2_jump_i(op2_jump),
    .reg1_rdata_i(reg1_rdata),
    .reg2_rdata_i(reg2_rdata),
    .mem_rdata_i(mem_rdata),
    .reg_waddr_o(reg_waddr),
    .reg_wdata_o(reg_wdata),   
    .mem_raddr_o(mem_raddr),
    .mem_wdata_o(mem_wdata),
    .mem_waddr_o(mem_waddr),
    .mem_we_o(mem_we),
    .jump_addr_o(jump_addr),
    .jump_en_o(jump_en)
);

ram mem_access(
    .clk_i(clk),
    .rstn_i(rstn),
    .mem_wen_i(mem_wen),
    .mem_wdata_i(mem_wdata),    
    .mem_waddr_i(mem_waddr),
    .mem_raddr_i(mem_raddr),
    .mem_rdata_o(mem_rdata)
);

endmodule
