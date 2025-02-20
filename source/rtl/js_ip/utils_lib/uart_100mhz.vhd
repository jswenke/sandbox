----------------------------------------------------------------------------------
-- Company: 
-- Engineer: JS
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
    
entity uart_100mhz is
    generic ( 
        G_CLKS_PER_BIT      : integer := 5208;
        G_UART_PACK_BITWIDTH: integer := 8
    ); 
    port ( 
        sys_clk         : in std_logic;
        sys_rst         : in std_logic;
        
        -- RX (packetizing serial UART data in)
        i_uart_rx_serial  : in std_logic;
        o_uart_rx_dword   : out std_logic_vector(7 downto 0);
        o_uart_rx_dword_dv: out std_logic;
        
        --TX (serializing input data word to output with UART)
        i_uart_tx_dword     : in std_logic_vector(7 downto 0);
        i_uart_tx_dword_dv  : in std_logic;
        o_uart_tx_serial    : out std_logic;
        o_uart_tx_inflow_err: out std_logic
--        uart_cts        : out std_logic; -- optional flow control signals
--        uart_rts        : in std_logic    
    );
end uart_100mhz;

architecture rtl of uart_100mhz is

    -- RX
    type type_uart_rx_fsm_state is (ST_uart_rx_idle, ST_uart_rx_start, ST_uart_rxing_bits, ST_uart_rx_stop_bit, ST_uart_rx_clear);
        signal PS_uart_rx : type_uart_rx_fsm_state := ST_uart_rx_idle;
        
    signal reg0_uart_serial_in : std_logic;
    signal reg1_uart_serial_in : std_logic; 
    signal reg_uart_data_packed: std_logic_vector(G_UART_PACK_BITWIDTH-1 downto 0) := (others=>'0');
    signal reg_uart_rx_done_flag : std_logic := '0';          
    
    signal ctr_clk_rxcount      : integer := 0;
    signal uart_rx_bit_index    : integer := 0;
    
    -- TX
    type type_uart_tx_fsm_state is (ST_uart_tx_idle, ST_uart_tx_start, ST_uart_tx_serializing); --, ST_uart_tx_stop);
        signal PS_uart_tx : type_uart_tx_fsm_state := ST_uart_tx_idle;
        
    signal reg0_uart_tx_dword_in : std_logic_vector(7 downto 0);     
    signal reg0_uart_tx_busy : std_logic := '0';
         
    signal ctr_clk_txcount      : integer := 0;
    signal uart_tx_bit_index    : integer := 0;         
    
    
begin

    -- TX                                                                       
 
    PROC_UART_TX_FSM: process(sys_clk, sys_rst) begin
        if(rising_edge(sys_clk)) then
            if(sys_rst = '1') then
                reg0_uart_tx_dword_in   <= (others=>'0');
                reg0_uart_tx_busy       <= '0';
                o_uart_tx_serial        <= '1';  
                ctr_clk_txcount         <= 0; 
                o_uart_tx_inflow_err    <= '0';
                
                PS_uart_tx              <= ST_uart_tx_idle;
            else
                if(reg0_uart_tx_busy = '1' and i_uart_tx_dword_dv = '1') then
                    o_uart_tx_inflow_err <= '1';
                end if;
                                            
                case PS_uart_tx is
                    
                    when ST_uart_tx_idle =>
                        if(i_uart_tx_dword_dv = '1') then                                                                        
                            reg0_uart_tx_dword_in   <= i_uart_tx_dword;
                            reg0_uart_tx_busy       <= '1';
                            o_uart_tx_serial        <= '0';                             
                            ctr_clk_txcount         <= 1;   
                             
                            PS_uart_tx              <= ST_uart_tx_start;                                                                                                                                                           
                        else
                            reg0_uart_tx_dword_in   <= (others=>'0');
                            reg0_uart_tx_busy       <= '0';
                            o_uart_tx_serial        <= '1';  
                            ctr_clk_txcount         <= 0;                                                                                                                                   
                        end if;
                    
                    when ST_uart_tx_start =>
                    -- send start bit (drive serial out low for one bit cycle)
                        if(ctr_clk_txcount < G_CLKS_PER_BIT-1) then
                            ctr_clk_txcount <= ctr_clk_txcount + 1;
                        else
                            uart_tx_bit_index   <= 0;
                            ctr_clk_txcount     <= 0;                        
                            o_uart_tx_serial    <= reg0_uart_tx_dword_in(0);
                            
                            PS_uart_tx      <= ST_uart_tx_serializing;                        
                        end if;                                                                                                            
                                                                                                    
                    when ST_uart_tx_serializing =>
                        if(ctr_clk_txcount < G_CLKS_PER_BIT-1) then
                            ctr_clk_txcount     <= ctr_clk_txcount + 1;
                            
                            if(ctr_clk_txcount = 0) then
                                uart_tx_bit_index <= uart_tx_bit_index + 1;
                            end if;
                        else
                            if(uart_tx_bit_index < G_UART_PACK_BITWIDTH) then
                                ctr_clk_txcount     <= 0;                        
                                o_uart_tx_serial    <= reg0_uart_tx_dword_in(uart_tx_bit_index); 
                            else                            
                                uart_tx_bit_index   <= 0;
                                ctr_clk_txcount     <= 0;      
                                o_uart_tx_serial    <= '1';
                                reg0_uart_tx_busy       <= '0';
    
                                PS_uart_tx      <= ST_uart_tx_idle;                                          
                            end if;                                                
                        end if;
                                                                                            
                    when others =>
                                  
                end case;
            end if;
        end if;
    end process;                                                                
                                
 
    -- RX
    
    PROC_CLK_SYNC_SERIAL_DIN: process(sys_clk, sys_rst) begin
        if(rising_edge(sys_clk)) then
            if(sys_rst = '1') then
                reg0_uart_serial_in <= '0';
                reg1_uart_serial_in <= '0'; 
            else
                reg0_uart_serial_in <= i_uart_rx_serial;
                reg1_uart_serial_in <= reg0_uart_serial_in;
            end if;
        end if;             
    end process;
       
    PROC_UART_RX_FSM: process(sys_clk, sys_rst) begin
        if(rising_edge(sys_clk)) then
            if(sys_rst = '1') then                
                ctr_clk_rxcount   <= 0;
                uart_rx_bit_index  <= 0;
                reg_uart_rx_done_flag <= '0';
                PS_uart_rx <= ST_uart_rx_idle;
            else
                case PS_uart_rx is 
                
                    when ST_uart_rx_idle =>   
                        ctr_clk_rxcount   <= 0;
                        uart_rx_bit_index  <= 0;
                        reg_uart_rx_done_flag <= '0';
                                                                               
                        if(reg1_uart_serial_in = '0') then
                            PS_uart_rx <= ST_uart_rx_start;
                        end if;
                        
                    when ST_uart_rx_start =>
                        if(ctr_clk_rxcount >= (G_CLKS_PER_BIT/2)-1) then
                            if(reg1_uart_serial_in = '0') then
                                PS_uart_rx         <= ST_uart_rxing_bits;
                                ctr_clk_rxcount   <= 0;
                            else
                                PS_uart_rx         <= ST_uart_rx_idle;
                            end if;                                                                
                        else
                            ctr_clk_rxcount <= ctr_clk_rxcount + 1; 
                        end if;
                        
                    when ST_uart_rxing_bits =>
                        if(ctr_clk_rxcount < G_CLKS_PER_BIT-1) then
                            ctr_clk_rxcount <= ctr_clk_rxcount + 1;
                        else                                                                        
                            ctr_clk_rxcount <= 0;                                                            
                            
                            if(uart_rx_bit_index < G_UART_PACK_BITWIDTH) then                                
                                reg_uart_data_packed(uart_rx_bit_index) <= reg1_uart_serial_in;
                                uart_rx_bit_index <= uart_rx_bit_index + 1;    
                            else
                                uart_rx_bit_index <= 0;                                
                                PS_uart_rx <= ST_uart_rx_stop_bit;                                
                            end if;
                        end if;                                                                                                                           
                                                        
                    when ST_uart_rx_stop_bit =>
                        if(ctr_clk_rxcount < G_CLKS_PER_BIT-1) then
                            ctr_clk_rxcount <= ctr_clk_rxcount + 1;
                        else
                            reg_uart_rx_done_flag <= '1';  
                            PS_uart_rx <= ST_uart_rx_clear;  
                        end if;
                        
                    when ST_uart_rx_clear => 
                        ctr_clk_rxcount           <= 0;
                        reg_uart_rx_done_flag   <= '0';                        
                        PS_uart_rx <= ST_uart_rx_idle;  
                                                  
                    when others =>                        
                        
                end case;                        
            end if; 
        end if;                                                                                           
    end process;            

end rtl;