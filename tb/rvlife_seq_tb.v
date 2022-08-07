`timescale 1ns / 1ps
`include "define.v"
module rvlife_seq_tb;

parameter	clk_cyc = 10.0;

reg                          clk_sys;
reg                          rstn_sys;
 
rvlife_seq u_rvlife_seq(
    .clk(clk_sys),
    .rstn(rstn_sys)
);

always #(clk_cyc/2) clk_sys = ~clk_sys;


// register file
wire [`CpuWidth-1:0] zero_x0  = u_rvlife_seq. u_regs_file. regs[0];
wire [`CpuWidth-1:0] ra_x1    = u_rvlife_seq. u_regs_file. regs[1];
wire [`CpuWidth-1:0] sp_x2    = u_rvlife_seq. u_regs_file. regs[2];
wire [`CpuWidth-1:0] gp_x3    = u_rvlife_seq. u_regs_file. regs[3];
wire [`CpuWidth-1:0] tp_x4    = u_rvlife_seq. u_regs_file. regs[4];
wire [`CpuWidth-1:0] t0_x5    = u_rvlife_seq. u_regs_file. regs[5];
wire [`CpuWidth-1:0] t1_x6    = u_rvlife_seq. u_regs_file. regs[6];
wire [`CpuWidth-1:0] t2_x7    = u_rvlife_seq. u_regs_file. regs[7];
wire [`CpuWidth-1:0] s0_fp_x8 = u_rvlife_seq. u_regs_file. regs[8];
wire [`CpuWidth-1:0] s1_x9    = u_rvlife_seq. u_regs_file. regs[9];
wire [`CpuWidth-1:0] a0_x10   = u_rvlife_seq. u_regs_file. regs[10];
wire [`CpuWidth-1:0] a1_x11   = u_rvlife_seq. u_regs_file. regs[11];
wire [`CpuWidth-1:0] a2_x12   = u_rvlife_seq. u_regs_file. regs[12];
wire [`CpuWidth-1:0] a3_x13   = u_rvlife_seq. u_regs_file. regs[13];
wire [`CpuWidth-1:0] a4_x14   = u_rvlife_seq. u_regs_file. regs[14];
wire [`CpuWidth-1:0] a5_x15   = u_rvlife_seq. u_regs_file. regs[15];
wire [`CpuWidth-1:0] a6_x16   = u_rvlife_seq. u_regs_file. regs[16];
wire [`CpuWidth-1:0] a7_x17   = u_rvlife_seq. u_regs_file. regs[17];
wire [`CpuWidth-1:0] s2_x18   = u_rvlife_seq. u_regs_file. regs[18];
wire [`CpuWidth-1:0] s3_x19   = u_rvlife_seq. u_regs_file. regs[19];
wire [`CpuWidth-1:0] s4_x20   = u_rvlife_seq. u_regs_file. regs[20];
wire [`CpuWidth-1:0] s5_x21   = u_rvlife_seq. u_regs_file. regs[21];
wire [`CpuWidth-1:0] s6_x22   = u_rvlife_seq. u_regs_file. regs[22];
wire [`CpuWidth-1:0] s7_x23   = u_rvlife_seq. u_regs_file. regs[23];
wire [`CpuWidth-1:0] s8_x24   = u_rvlife_seq. u_regs_file. regs[24];
wire [`CpuWidth-1:0] s9_x25   = u_rvlife_seq. u_regs_file. regs[25];
wire [`CpuWidth-1:0] s10_x26  = u_rvlife_seq. u_regs_file. regs[26];
wire [`CpuWidth-1:0] s11_x27  = u_rvlife_seq. u_regs_file. regs[27];
wire [`CpuWidth-1:0] t3_x28   = u_rvlife_seq. u_regs_file. regs[28];
wire [`CpuWidth-1:0] t4_x29   = u_rvlife_seq. u_regs_file. regs[29];
wire [`CpuWidth-1:0] t5_x30   = u_rvlife_seq. u_regs_file. regs[30];
wire [`CpuWidth-1:0] t6_x31   = u_rvlife_seq. u_regs_file. regs[31];



//data instruction initial
initial begin
	$readmemh("./generated/inst_data.txt",u_rvlife_seq.u_fetch.u_rom.instr_rom);
end

//获取波形
//initial begin
    // $dumpfile("tb.vcd");
    // $dumpvars(0, tb);
//end

initial begin
	clk_sys = 0;
    rstn_sys = 1;
	repeat(1) @(posedge clk_sys); #1 rstn_sys = 0; // reset 1 clock
	repeat(1) @(posedge clk_sys); #1 rstn_sys = 1;
    repeat(5000) @(posedge clk_sys);
end
         

integer r;

initial begin
    wait(s10_x26 == 32'b1)   // wait sim end, when x26 == 1
        repeat(1) @(posedge clk_sys);
        #1; 
        if (s11_x27 == 32'b1) begin
			$display("############################");
			$display("########  pass  !!!#########");
			$display("############################");
            repeat(1) @(posedge clk_sys);
        end 
        else begin
			$display("############################");
			$display("########  fail  !!!#########");
			$display("############################");
            $display("fail testnum = %2d", gp_x3);
            repeat(1) @(posedge clk_sys);
            for (r = 0; r < 32; r = r + 1)
                $display("x%2d = 0x%x", r, u_rvlife_seq. u_regs_file. regs[r]);
        end 
       
        $finish; 
        
end 

endmodule

