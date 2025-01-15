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
    Generic ( STIM_ARR_LENGTH : integer := 4 );
    --Port ( );
end tb_uart_100mhz;

architecture uut of tb_uart_100mhz is

    constant clk_period : time := 10ns;
    
    constant G_TB_CLKS_PER_BIT          : integer := 5208;
    constant G_TB_UART_PACK_BITWIDTH    : integer := 8;

    type rx_stimulus_arr_type is array (0 to STIM_ARR_LENGTH-1) of std_logic_vector(8 downto 0);        
        signal rx_stimulus_array : rx_stimulus_arr_type := ("110101010", "111000010", "111100100", "111111000");
    
    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '0';
    
    signal tb_i_uart_rx_serial  : std_logic := '0';
    signal tb_o_uart_rx_dword   : std_logic_vector(7 downto 0) := (others=>'0');
    signal tb_o_uart_rx_dword_dv: std_logic := '0';
    
    signal tb_i_uart_tx_dword   : std_logic_vector(7 downto 0) := (others=>'0');
    signal tb_i_uart_tx_dword_dv: std_logic := '0';
    signal tb_o_uart_tx_serial  : std_logic := '0';
    signal tb_o_uart_tx_inflow_err : std_logic := '0';    


    signal rx_stimulus_bit_index    : integer := 0;         
    signal rx_stimulus_array_index    : integer := 0;         

begin

tb_clk <= not(tb_clk) after clk_period/2;

UUT_UART_100MHZ: entity utils_lib.uart_100mhz(rtl)
    generic map( 
        G_CLKS_PER_BIT      => G_TB_CLKS_PER_BIT,
        G_UART_PACK_BITWIDTH=> G_TB_UART_PACK_BITWIDTH
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

    -- driving serial line high when nothing being rx/tx'd
    tb_i_uart_rx_serial <= '1';
    
    wait for 10*clk_period;

    for rx_stimulus_array_index in 0 to STIM_ARR_LENGTH-1 loop
        for rx_stimulus_bit_index in 0 to 8 loop
            tb_i_uart_rx_serial <= rx_stimulus_array(rx_stimulus_array_index)(rx_stimulus_bit_index);
            wait for G_TB_CLKS_PER_BIT * clk_period;
        end loop;
        -- driving serial line back high and waiting for a bit
        tb_i_uart_rx_serial <= '1';
        wait for (G_TB_CLKS_PER_BIT/4) * clk_period;        
    end loop;      
    
    wait for 10*clk_period;

    wait;
end process;            

end uut;