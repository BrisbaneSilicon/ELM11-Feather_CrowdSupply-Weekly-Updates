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

    reg [31:0]  i_bitbash_data;
    reg [5:0]   i_bitbash_count;


    //  ------- Functions -------


    //  -------I/O Mapping -------


    //  ------- Implementation -------

    // NOTE: Registers

    always @(posedge clk) begin
        // defaults
        s_ready <= 1'b0;

        if (s_valid == 1'b1) begin
            if (s_ready == 1'b1) begin
                // NOTE: register access

                if (s_wstrb == 0) begin
                    // NOTE: read operation

                end else begin
                    // NOTE: write operation

                    if (s_addr == 0) begin
                        // NOTE: this integer address one,
                        // byte address four.
                        i_bitbash_data <= s_wrdata;
                    end else if (s_addr == 4) begin
                        // NOTE: this integer address one,
                        // byte address four.
                        i_bitbash_count <= s_wrdata[5:0];
                    end
                end
            end else begin
                s_ready <= 1'b1;
            end
        end

        if (srst == 1'b1) begin
            s_ready <= 1'b0;
        end
    end

endmodule
