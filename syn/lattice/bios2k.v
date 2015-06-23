/* Verilog netlist generated by SCUBA Diamond_2.2_Production (99) */
/* Module Version: 7.2 */
/* /usr/local/diamond/2.2_x64/ispfpga/bin/lin64/scuba -w -n bios2k -lang verilog -synth synplify -bus_exp 7 -bb -arch xo2c00 -type bram -wp 11 -rp 1010 -data_width 8 -rdata_width 8 -num_rows 2048 -cascade -1 -memfile /home/pacito/02_Elektronik/020_V6809/6809/opencores/trunk/syn/lattice/test1.mem -memformat orca -writemodeA NORMAL -writemodeB NORMAL -e  */
/* Thu Feb  6 15:31:10 2014 */


`timescale 1 ns / 1 ps
module bios2k (DataInA, DataInB, AddressA, AddressB, ClockA, ClockB, 
    ClockEnA, ClockEnB, WrA, WrB, ResetA, ResetB, QA, QB)/* synthesis NGD_DRC_MASK=1 */;
    input wire [7:0] DataInA;
    input wire [7:0] DataInB;
    input wire [10:0] AddressA;
    input wire [10:0] AddressB;
    input wire ClockA;
    input wire ClockB;
    input wire ClockEnA;
    input wire ClockEnB;
    input wire WrA;
    input wire WrB;
    input wire ResetA;
    input wire ResetB;
    output wire [7:0] QA;
    output wire [7:0] QB;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    defparam bios2k_0_0_1.INIT_DATA = "STATIC" ;
    defparam bios2k_0_0_1.ASYNC_RESET_RELEASE = "SYNC" ;
    defparam bios2k_0_0_1.INITVAL_1F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_0_1.INITVAL_00 = "0x0000000000000000000000000000000000000000000000000A01E6003A6C18E60038560AE011880E" ;
    defparam bios2k_0_0_1.CSDECODE_B = "0b000" ;
    defparam bios2k_0_0_1.CSDECODE_A = "0b000" ;
    defparam bios2k_0_0_1.WRITEMODE_B = "NORMAL" ;
    defparam bios2k_0_0_1.WRITEMODE_A = "NORMAL" ;
    defparam bios2k_0_0_1.GSR = "ENABLED" ;
    defparam bios2k_0_0_1.RESETMODE = "ASYNC" ;
    defparam bios2k_0_0_1.REGMODE_B = "NOREG" ;
    defparam bios2k_0_0_1.REGMODE_A = "NOREG" ;
    defparam bios2k_0_0_1.DATA_WIDTH_B = 4 ;
    defparam bios2k_0_0_1.DATA_WIDTH_A = 4 ;
    DP8KC bios2k_0_0_1 (.DIA8(scuba_vlo), .DIA7(scuba_vlo), .DIA6(scuba_vlo), 
        .DIA5(scuba_vlo), .DIA4(scuba_vlo), .DIA3(DataInA[3]), .DIA2(DataInA[2]), 
        .DIA1(DataInA[1]), .DIA0(DataInA[0]), .ADA12(AddressA[10]), .ADA11(AddressA[9]), 
        .ADA10(AddressA[8]), .ADA9(AddressA[7]), .ADA8(AddressA[6]), .ADA7(AddressA[5]), 
        .ADA6(AddressA[4]), .ADA5(AddressA[3]), .ADA4(AddressA[2]), .ADA3(AddressA[1]), 
        .ADA2(AddressA[0]), .ADA1(scuba_vlo), .ADA0(scuba_vlo), .CEA(ClockEnA), 
        .OCEA(ClockEnA), .CLKA(ClockA), .WEA(WrA), .CSA2(scuba_vlo), .CSA1(scuba_vlo), 
        .CSA0(scuba_vlo), .RSTA(ResetA), .DIB8(scuba_vlo), .DIB7(scuba_vlo), 
        .DIB6(scuba_vlo), .DIB5(scuba_vlo), .DIB4(scuba_vlo), .DIB3(DataInB[3]), 
        .DIB2(DataInB[2]), .DIB1(DataInB[1]), .DIB0(DataInB[0]), .ADB12(AddressB[10]), 
        .ADB11(AddressB[9]), .ADB10(AddressB[8]), .ADB9(AddressB[7]), .ADB8(AddressB[6]), 
        .ADB7(AddressB[5]), .ADB6(AddressB[4]), .ADB5(AddressB[3]), .ADB4(AddressB[2]), 
        .ADB3(AddressB[1]), .ADB2(AddressB[0]), .ADB1(scuba_vlo), .ADB0(scuba_vlo), 
        .CEB(ClockEnB), .OCEB(ClockEnB), .CLKB(ClockB), .WEB(WrB), .CSB2(scuba_vlo), 
        .CSB1(scuba_vlo), .CSB0(scuba_vlo), .RSTB(ResetB), .DOA8(), .DOA7(), 
        .DOA6(), .DOA5(), .DOA4(), .DOA3(QA[3]), .DOA2(QA[2]), .DOA1(QA[1]), 
        .DOA0(QA[0]), .DOB8(), .DOB7(), .DOB6(), .DOB5(), .DOB4(), .DOB3(QB[3]), 
        .DOB2(QB[2]), .DOB1(QB[1]), .DOB0(QB[0]))
             /* synthesis MEM_LPC_FILE="bios2k.lpc" */
             /* synthesis MEM_INIT_FILE="test1.mem" */;

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    defparam bios2k_0_1_0.INIT_DATA = "STATIC" ;
    defparam bios2k_0_1_0.ASYNC_RESET_RELEASE = "SYNC" ;
    defparam bios2k_0_1_0.INITVAL_1F = "0x01E00000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam bios2k_0_1_0.INITVAL_00 = "0x0000000000000000000000000000000000000000000000000E05C2811E2509E2118A8A1140418CE8" ;
    defparam bios2k_0_1_0.CSDECODE_B = "0b000" ;
    defparam bios2k_0_1_0.CSDECODE_A = "0b000" ;
    defparam bios2k_0_1_0.WRITEMODE_B = "NORMAL" ;
    defparam bios2k_0_1_0.WRITEMODE_A = "NORMAL" ;
    defparam bios2k_0_1_0.GSR = "ENABLED" ;
    defparam bios2k_0_1_0.RESETMODE = "ASYNC" ;
    defparam bios2k_0_1_0.REGMODE_B = "NOREG" ;
    defparam bios2k_0_1_0.REGMODE_A = "NOREG" ;
    defparam bios2k_0_1_0.DATA_WIDTH_B = 4 ;
    defparam bios2k_0_1_0.DATA_WIDTH_A = 4 ;
    DP8KC bios2k_0_1_0 (.DIA8(scuba_vlo), .DIA7(scuba_vlo), .DIA6(scuba_vlo), 
        .DIA5(scuba_vlo), .DIA4(scuba_vlo), .DIA3(DataInA[7]), .DIA2(DataInA[6]), 
        .DIA1(DataInA[5]), .DIA0(DataInA[4]), .ADA12(AddressA[10]), .ADA11(AddressA[9]), 
        .ADA10(AddressA[8]), .ADA9(AddressA[7]), .ADA8(AddressA[6]), .ADA7(AddressA[5]), 
        .ADA6(AddressA[4]), .ADA5(AddressA[3]), .ADA4(AddressA[2]), .ADA3(AddressA[1]), 
        .ADA2(AddressA[0]), .ADA1(scuba_vlo), .ADA0(scuba_vlo), .CEA(ClockEnA), 
        .OCEA(ClockEnA), .CLKA(ClockA), .WEA(WrA), .CSA2(scuba_vlo), .CSA1(scuba_vlo), 
        .CSA0(scuba_vlo), .RSTA(ResetA), .DIB8(scuba_vlo), .DIB7(scuba_vlo), 
        .DIB6(scuba_vlo), .DIB5(scuba_vlo), .DIB4(scuba_vlo), .DIB3(DataInB[7]), 
        .DIB2(DataInB[6]), .DIB1(DataInB[5]), .DIB0(DataInB[4]), .ADB12(AddressB[10]), 
        .ADB11(AddressB[9]), .ADB10(AddressB[8]), .ADB9(AddressB[7]), .ADB8(AddressB[6]), 
        .ADB7(AddressB[5]), .ADB6(AddressB[4]), .ADB5(AddressB[3]), .ADB4(AddressB[2]), 
        .ADB3(AddressB[1]), .ADB2(AddressB[0]), .ADB1(scuba_vlo), .ADB0(scuba_vlo), 
        .CEB(ClockEnB), .OCEB(ClockEnB), .CLKB(ClockB), .WEB(WrB), .CSB2(scuba_vlo), 
        .CSB1(scuba_vlo), .CSB0(scuba_vlo), .RSTB(ResetB), .DOA8(), .DOA7(), 
        .DOA6(), .DOA5(), .DOA4(), .DOA3(QA[7]), .DOA2(QA[6]), .DOA1(QA[5]), 
        .DOA0(QA[4]), .DOB8(), .DOB7(), .DOB6(), .DOB5(), .DOB4(), .DOB3(QB[7]), 
        .DOB2(QB[6]), .DOB1(QB[5]), .DOB0(QB[4]))
             /* synthesis MEM_LPC_FILE="bios2k.lpc" */
             /* synthesis MEM_INIT_FILE="test1.mem" */;



    // exemplar begin
    // exemplar attribute bios2k_0_0_1 MEM_LPC_FILE bios2k.lpc
    // exemplar attribute bios2k_0_0_1 MEM_INIT_FILE test1.mem
    // exemplar attribute bios2k_0_1_0 MEM_LPC_FILE bios2k.lpc
    // exemplar attribute bios2k_0_1_0 MEM_INIT_FILE test1.mem
    // exemplar end

endmodule
