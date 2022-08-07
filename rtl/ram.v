`include "define.v"
module ram(
    clk_i,
    rstn_i,
    mem_wen_i,
    mem_wdata_i,    
    mem_waddr_i,
    mem_raddr_i,
    mem_rdata_o,
);
    //input signal
    input  wire                                           clk_i;
    input  wire                                           rstn_i;    
    input  wire                                           mem_wen_i; 
    input  wire  [`MemWidth - 1:0]                        mem_wdata_i;
    input  wire  [`MemWidth - 1:0]                        mem_waddr_i;
    input  wire  [`MemWidth - 1:0]                        mem_raddr_i;


    //output signal
    output reg   [`MemWidth - 1:0]                        mem_rdata_o;
 
    //memory
    reg          [`MemWidth - 1:0]                        data_ram[0:4095];

    always @ (posedge clk_i) begin
        if (mem_wen_i == `WriteEnable) begin
            data_ram[mem_waddr_i[31:2]] <= mem_wdata_i;
        end
    end

    always @ (*) begin
        if (!rstn_i) begin
            mem_rdata_o = `ZeroWord;
        end else begin
            mem_rdata_o = data_ram[mem_raddr_i[31:2]];
        end
    end

endmodule
