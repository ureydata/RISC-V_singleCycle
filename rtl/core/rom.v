//=======================================================================
// Company            : 
// Filename           : .v
// Author             : Urey
// Created On         : 2022-07-17 00:17
// Last Modified      : 
// Description        : 
//                      
//                      
//=======================================================================
`include "define.v"
module rom(
    rdaddr_i,
    rddata_o
);
    //input signal
    input  wire [`CpuWidth - 1 : 0]       rdaddr_i;

    //output signal
    output reg  [`InstrWidth - 1:0]       rddata_o;

    //instruction memory
    reg    [`InstrWidth - 1:0]            instr_rom[0:1023];
    
    always@(*)begin
        rddata_o = instr_rom[rdaddr_i[31:2]];  // pc按字节取指，而一条指令有32位，所以需要连续取4次，即除以4取整。
    end

endmodule
