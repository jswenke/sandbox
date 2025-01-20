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
        
entity tb_uart_tx is
    Generic ( STIM_ARR_LENGTH : integer := 4 );
    --Port ( );
end tb_uart_tx;

architecture uut of tb_uart_tx is

    constant clk_period : time := 10ns;
    
    constant G_TB_CLKS_PER_BIT          : integer := 5208;
    constant G_TB_UART_PACK_BITWIDTH    : integer := 8;

    type stimulus_arr_dword_type is array (0 to STIM_ARR_LENGTH-1) of std_logic_vector(7 downto 0);        
        signal tx_dword_stimulus_array : stimulus_arr_dword_type := ("10000001", "11000001", "11100001", "11110001");
        
    type stimulus_arr_dword_dv_type is array (0 to STIM_ARR_LENGTH-1) of std_logic;
        signal tx_dword_dv_stimulus_array : stimulus_arr_dword_dv_type := ('1', '0', '1', '0');         
    
    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '0';
    
    signal tb_i_uart_rx_serial  : std_logic := '0';
    signal tb_o_uart_rx_dword   : std_logic_vector(7 downto 0) := (others=>'0');
    signal tb_o_uart_rx_dword_dv: std_logic := '0';
    
    signal tb_i_uart_tx_dword   : std_logic_vector(7 downto 0) := (others=>'0');
    signal tb_i_uart_tx_dword_dv: std_logic := '0';
    signal tb_o_uart_tx_serial  : std_logic := '0';
    signal tb_o_uart_tx_inflow_err : std_logic := '0';    

--    signal rx_stimulus_bit_index    : integer := 0;         
--    signal rx_stimulus_array_index    : integer := 0;         

    signal tx_stim_dword_index  : integer := 0;         
    signal tx_stim_dvalid_index : integer := 0;    

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

STIMULUS_TB: process
    begin
   
    tb_i_uart_tx_dword      <= (others=>'0');
    tb_i_uart_tx_dword_dv   <= '0';
    
    wait for 10*clk_period;
    
--      TX STIMULUS PROCESS
--      Need to wait long enough for all bits of the vector to be sent over serial
--      G_TB_CLKS_PER_BIT*CLK_PERIOD is the amount of time that it takes for one bit to be sent, and we need to send 8 + start bit, adding some buffer too       
    for tx_stim_dword_index in 0 to STIM_ARR_LENGTH-1 loop
        tb_i_uart_tx_dword      <= tx_dword_stimulus_array(tx_stim_dword_index);
        tb_i_uart_tx_dword_dv   <= tx_dword_dv_stimulus_array(tx_stim_dword_index);
        wait for (G_TB_CLKS_PER_BIT * clk_period) * 11;
    end loop;        
    
    wait for 10*clk_period;

    wait;
end process;            

end uut;