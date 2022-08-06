`include "define.v"
module fetch(
    instr_addr_i,
    instr_o,
    instr_addr_o
);

    //input signal
    input  wire  [`CpuWidth - 1:0]     instr_addr_i;    
      
    //output signal
    output wire  [`InstrWidth - 1:0]   instr_o;
    output wire  [`CpuWidth - 1:0]     instr_addr_o;
 
    assign instr_addr_o = instr_addr_i;

    rom  u_rom(
        .rdaddr_i(instr_addr_i),
        .rddata_o(instr_o)
    );


endmodule
