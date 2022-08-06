`include "define.v"
module pc_reg(
    clk_i,
    rstn_i,
    jump_en_i,
    jump_addr_i,
    pc_o    
);
    //input signal
    input  wire                         clk_i;
    input  wire                         rstn_i;
    input  wire                         jump_en_i;
    input  wire [`CpuWidth - 1:0]      jump_addr_i;
   
    //output signal
    output reg  [`CpuWidth - 1:0]      pc_o;  

    //pc register
    always@(posedge clk_i or negedge rstn_i)begin
        if(!rstn_i)begin
            pc_o <= `CpuWidth'b0;
        end

        else if(jump_en_i) begin
            pc_o <= jump_addr_i;
        end
         
        else begin
            pc_o <= pc_o + `CpuWidth'h4;
        end
    end

endmodule
