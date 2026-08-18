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

    reg [31:0]  i_bitbash_data_reg;
    reg [5:0]   i_bitbash_count_reg;
    reg         i_bitbash_count_reg_updated;

    reg         i_performing_bitbash;
    reg [31:0]  i_bitbash_data;
    reg [5:0]   i_bitbash_count;
    reg         i_bitbash_clk;
    reg         i_bitbash_bit;

    reg         i_busy;


    //  ------- Functions -------


    //  -------I/O Mapping -------

    assign m_iobus_wrdata[0]    = i_bitbash_clk;
    assign m_iobus_wrdata[1]    = i_bitbash_bit;

    assign m_iobus_tuser        = 0;


    //  ------- Implementation -------

    assign i_busy = i_bitbash_count_reg_updated | i_performing_bitbash;


    // NOTE: Registers

    always @(posedge clk) begin
        // defaults
        s_ready                     <= 1'b0;

        i_bitbash_count_reg_updated <= 1'b0;

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
                        i_bitbash_data_reg <= s_wrdata;
                    end else if (s_addr == 4) begin
                        // NOTE: this integer address one,
                        // byte address four.
                        i_bitbash_count_reg         <= s_wrdata[5:0];
                        i_bitbash_count_reg_updated <= 1'b1;
                    end
                end
            end else begin
                if (i_busy == 1'b0) begin
                    s_ready <= 1'b1;
                end
            end
        end

        if (srst == 1'b1) begin
            s_ready <= 1'b0;
        end
    end


    // NOTE: Bit-bash

    always @(posedge clk) begin
        if (i_performing_bitbash == 1'b0) begin
            i_performing_bitbash    <= i_bitbash_count_reg_updated;

            i_bitbash_data          <= i_bitbash_data_reg;
            i_bitbash_count         <= i_bitbash_count_reg;

            i_bitbash_clk           <= 1'b0;
        end else begin
            i_bitbash_clk <= ~i_bitbash_clk;

            if (i_bitbash_clk == 1'b1) begin
                i_bitbash_data  <= { 1'b0, i_bitbash_data[31:1] };
                i_bitbash_count <= i_bitbash_count - 1;

                if (i_bitbash_count == 1) begin
                    i_performing_bitbash <= 1'b0;
                end
            end
        end

        if (srst == 1'b1) begin
            i_performing_bitbash <= 1'b0;
        end
    end

    assign i_bitbash_bit = i_bitbash_data[0];

endmodule
