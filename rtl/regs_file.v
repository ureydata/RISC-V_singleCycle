`include "define.v"
module regs_file(
    clk_i,
    rstn_i,
    reg_wen_i,
    reg_waddr_i,
    reg_wdata_i,
    reg1_raddr_i,
    reg2_raddr_i,
    reg1_rdata_o,
    reg2_rdata_o
);
    //input signal
    input  wire                                           clk_i;
    input  wire                                           rstn_i;    
    input  wire                                           reg_wen_i; 
    input  wire  [`RegAddrWidth - 1:0]                    reg_waddr_i;
    input  wire  [`CpuWidth-1:0]                         reg_wdata_i;
    input  wire  [`RegAddrWidth - 1:0]                    reg1_raddr_i;
    input  wire  [`RegAddrWidth - 1:0]                    reg2_raddr_i;

    //output signal
    output reg   [`CpuWidth-1:0]                         reg1_rdata_o;
    output reg   [`CpuWidth-1:0]                         reg2_rdata_o;
 
    //register files
    reg          [`CpuWidth - 1:0]                       regs[0:31];

    integer i;

    //write data to register files
    always @(posedge clk_i or negedge rstn_i ) begin
        if(!rstn_i) begin
            for(i = 0;i < 32; i = i + 1)
                regs[i] <= `CpuWidth'b0;
        end 
        else if(reg_wen_i && (reg_waddr_i != `ZeroReg)) begin
            regs[reg_waddr_i] <= reg_wdata_i;
        end         
    end

    // read data from register 1
    always @ (*) begin
        if (reg1_raddr_i == `ZeroReg) begin
            reg1_rdata_o = `ZeroWord;
        end 
        else begin
            reg1_rdata_o = regs[reg1_raddr_i];
        end
    end

    // read data from register 2
    always @ (*) begin
        if (reg2_raddr_i == `ZeroReg) begin
            reg2_rdata_o = `ZeroWord;
        end 
        else begin
            reg2_rdata_o = regs[reg2_raddr_i];
        end
    end

endmodule
