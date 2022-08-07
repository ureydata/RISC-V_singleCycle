//CPU register width
`define     CpuWidth                 32

//Instruction memory
`define     InstrWidth              32

//Ram width
`define     MemWidth                32

// register 
`define RegAddrWidth                 5 // 2^5 = 32

// R and M type inst
`define INST_TYPE_R 7'b0110011
// R type inst
`define INST_ADD_SUB 3'b000
`define INST_SLL    3'b001
`define INST_SLT    3'b010
`define INST_SLTU   3'b011
`define INST_XOR    3'b100
`define INST_SR     3'b101
`define INST_OR     3'b110
`define INST_AND    3'b111
// M type inst
`define INST_MUL    3'b000
`define INST_MULH   3'b001
`define INST_MULHSU 3'b010
`define INST_MULHU  3'b011
`define INST_DIV    3'b100
`define INST_DIVU   3'b101
`define INST_REM    3'b110
`define INST_REMU   3'b111


//I type inst 
`define INST_TYPE_I     7'b0010011
`define INST_ADDI       3'b000
`define INST_SLTI       3'b010
`define INST_SLTIU      3'b011
`define INST_XORI       3'b100
`define INST_ORI        3'b110
`define INST_ANDI       3'b111
`define INST_SLLI       3'b001
`define INST_SRI        3'b101


// L type inst
`define INST_TYPE_L     7'b0000011
`define INST_LB         3'b000
`define INST_LH         3'b001
`define INST_LW         3'b010
`define INST_LBU        3'b100
`define INST_LHU        3'b101
//S type inst 
`define INST_TYPE_S     7'b0100011 
`define INST_SB         3'b000
`define INST_SH         3'b001
`define INST_SW         3'b010

//B type inst 
`define INST_TYPE_B     7'b1100011
`define INST_BEQ        3'b000
`define INST_BNE        3'b001
`define INST_BLT        3'b100
`define INST_BGE        3'b101
`define INST_BLTU       3'b110
`define INST_BGEU       3'b111

//J type inst 
`define INST_JAL        7'b1101111
`define INST_JALR       7'b1100111

//U type inst 
`define INST_LUI        7'b0110111
`define INST_AUIPC      7'b0010111

`define ZeroWord        32'h0
`define ZeroReg         5'h0

`define WriteEnable     1'b1
`define WriteDisable    1'b0

`define JumpEnable      1'b1
`define JumpDisable     1'b0 

