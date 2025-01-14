----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2025 10:44:37 PM
-- Design Name: 
-- Module Name: tb_uart_100mhz - uut
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

library utils_lib;
    use utils_lib.uart_100mhz;
        
entity tb_uart_100mhz is
--  Port ( );
end tb_uart_100mhz;

architecture uut of tb_uart_100mhz is

    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '0';
    
    signal tb_i_uart_rx_serial  : std_logic := '0';
    signal tb_o_uart_rx_dword   : std_logic_vector(7 downto 0) := (others=>'0');
    signal tb_o_uart_rx_dword_dv: std_logic := '0';
    
    signal tb_i_uart_tx_dword   : std_logic_vector(7 downto 0) := (others=>'0');
    signal tb_i_uart_tx_dword_dv: std_logic := '0';
    signal tb_o_uart_tx_serial  : std_logic := '0';
    signal tb_o_uart_tx_inflow_err : std_logic := '0';    

    constant clk_period : time := 10ns;

begin

tb_clk <= not(tb_clk) after clk_period/2;

UUT_UART_100MHZ: entity utils_lib.uart_100mhz(rtl)
    generic map( 
        G_CLKS_PER_BIT      => 5208,
        G_UART_PACK_BITWIDTH=> 8
    ) 
    port map( 
        sys_clk         => tb_clk,
        sys_rst         => tb_rst,
        
        -- RX (packetizing serial UART data in)
        i_uart_rx_serial  => tb_i_uart_rx_serial,
        o_uart_rx_dword   => tb_o_uart_rx_dword,
        o_uart_rx_dword_dv=> tb_o_uart_rx_dword_dv,
        
        --TX (serializing input data word to output with UART)
        i_uart_tx_dword     => tb_i_uart_tx_dword,
        i_uart_tx_dword_dv  => tb_i_uart_tx_dword_dv,
        o_uart_tx_serial    => tb_o_uart_tx_serial,
        o_uart_tx_inflow_err=> tb_o_uart_tx_inflow_err  
    );

STIMULUS: process
    begin
        -- do stimulus proc tmrw
    wait;
end process;            

end uut;