----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/09/2025 05:23:31 PM
-- Design Name: 
-- Module Name: uart_top - rtl
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
-- 8 bits of serial data per receive
-- clks per bit = freq_of_i_clk / freq_of_uart
-- ex: 100 MHz Clock / 19200 baud = 100e6/19200 =  5208.33 = 5208 
-- would using this clock/baud rate cause an issue if it's not a whole number?
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

library utils_lib;
    use utils_lib.button_debounce;
    
entity uart_top is
    generic ( 
        G_CLKS_PER_BIT      : integer := 5208;
        G_UART_PACK_BITWIDTH: integer := 8
    ); 
    port ( 
        top_clk_100mhz  : in std_logic;
        top_rst         : in std_logic;
        -- UART ports
        uart_txd_in     : in std_logic;
        uart_rxd_out    : out std_logic
--        uart_cts        : out std_logic; -- optional flow control signals
--        uart_rts        : in std_logic    
    );
end uart_top;

architecture rtl of uart_top is

    signal sys_rst : std_logic := '0';
    
    signal reg0_uart_serial_in : std_logic;
    signal reg1_uart_serial_in : std_logic; 
    signal reg_uart_data_packed: std_logic_vector(G_UART_PACK_BITWIDTH-1 downto 0);
    signal reg_uart_rx_done_flag : std_logic := '0';  
    
    type type_uart_fsm_state is (ST_uart_idle, ST_uart_rx_start, ST_uart_rxing_bits, ST_uart_stop_bit, ST_uart_clear);
        signal PS_uart : type_uart_fsm_state := ST_uart_idle;
    
    signal ctr_clk_count    : integer := 0;
    signal uart_bit_index   : integer := 0;
     
    
begin

    GEN_RST_BTN_DEBOUNCE: entity utils_lib.button_debounce(rtl)
        generic map(
            debounce_time =>  1048576 -- .1 ms @ 100MHz
        )
        port map(
            clk         => top_clk_100mhz,
            rst         => '0',
            i_button    => top_rst,
            o_debounced => sys_rst
        ); 
        
                
    PROC_CLK_SYNC_SERIAL_DIN: process(top_clk_100mhz, sys_rst) begin
        if(rising_edge(top_clk_100mhz)) then
            if(sys_rst = '1') then
                reg0_uart_serial_in <= '0';
                reg1_uart_serial_in <= '0'; 
            else
                reg0_uart_serial_in <= uart_txd_in;
                reg1_uart_serial_in <= reg0_uart_serial_in;
            end if;
        end if;             
    end process;
    
    
    PROC_UART_FSM: process(top_clk_100mhz, sys_rst) begin
        if(rising_edge(top_clk_100mhz)) then
            if(sys_rst = '1') then                
                ctr_clk_count   <= 0;
                uart_bit_index  <= 0;
                reg_uart_rx_done_flag <= '0';
                PS_uart <= ST_uart_idle;
            else
                case PS_uart is 
                
                    when ST_uart_idle =>   
                        ctr_clk_count   <= 0;
                        uart_bit_index  <= 0;
                        reg_uart_rx_done_flag <= '0';
                                                                               
                        if(reg1_uart_serial_in = '0') then
                            PS_uart <= ST_uart_rx_start;
                        end if;
                        
                    when ST_uart_rx_start =>
                        -- checking the middle of start bit to verify still low, helps avoid noise trigger falling edge
                        if(ctr_clk_count >= (G_CLKS_PER_BIT/2)-1) then
                            if(reg1_uart_serial_in = '0') then
                                PS_uart         <= ST_uart_rxing_bits;
                                ctr_clk_count   <= 0;
                            else
                                PS_uart         <= ST_uart_idle;
                            end if;                                                                
                        else
                            ctr_clk_count <= ctr_clk_count + 1; 
                        end if;
                        
                    when ST_uart_rxing_bits =>
                        if(ctr_clk_count < G_CLKS_PER_BIT-1) then
                            ctr_clk_count <= ctr_clk_count + 1;
                        else                                                                        
                            ctr_clk_count <= 0;                                                            
                            
                            if(uart_bit_index < G_UART_PACK_BITWIDTH-1) then                                
                                reg_uart_data_packed(uart_bit_index) <= reg1_uart_serial_in;
                                uart_bit_index <= uart_bit_index + 1;    
                            else
                                uart_bit_index <= 0;                                
                                PS_uart <= ST_uart_stop_bit;                                
                            end if;
                        end if;                                                                                                                           
                                                        
                    when ST_uart_stop_bit =>
                        if(ctr_clk_count < G_CLKS_PER_BIT-1) then
                            ctr_clk_count <= ctr_clk_count + 1;
                        else
                            reg_uart_rx_done_flag <= '1';      
                            -- ADD SOMETHING TO MOVE THIS TO ANOTHER REG AND PUSH TO FIFO HERE, EXPAND ON IT SOMEHOW                      
                        end if;
                        
                    when ST_uart_clear => 
                        ctr_clk_count           <= 0;
                        reg_uart_rx_done_flag   <= '0';                        
                        PS_uart <= ST_uart_idle;  
                                                  
                    when others =>                        
                        
                end case;                        
            end if; 
        end if;                                                                                           
    end process;            

end rtl;