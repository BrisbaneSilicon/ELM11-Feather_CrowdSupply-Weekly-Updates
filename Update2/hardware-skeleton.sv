`timescale 1ns/1ps

module user
(
    input                   clk,
    input                   srst,
        // NOTE: Clocking

    input                   s_valid,
    output reg              s_ready,
    input       [31:0]      s_wrdata,
    output reg  [31:0]      s_rddata,
    input       [23:0]      s_addr,
    input       [3:0]       s_wstrb,
        // NOTE: upstream interface,
        // i.e. to/from Lua API

    output  reg             m_iobus_valid,
    input                   m_iobus_ready,
    output  reg             m_iobus_wren,
    output  reg [15:0]      m_iobus_wrdata,
    input       [15:0]      m_iobus_rddata,
    output  reg [15:0]      m_iobus_tuser
        // NOTE: downstream interface,
        // i.e. to/from physical pins
);

    //  ------- Constants -------


    //  ------- Internal signals -------


    //  ------- Functions -------


    //  -------I/O Mapping -------


    //  ------- Implementation -------

    always @(posedge clk) begin

    end

endmodule
