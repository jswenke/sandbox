----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2025 10:30:33 PM
-- Design Name: 
-- Module Name: async_fifo_rdptr_and_empty_handler - rtl
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

library UNISIM;
    use UNISIM.VComponents.all;

library utils_lib;
    use utils_lib.binary2gray;
    use utils_lib.misc_pkg.all;    


entity async_fifo_rdptr_and_empty_handler is
    generic (
                G_FIFO_ADDRWIDTH : integer := 8
        );
        port ( 
                clk             : in std_logic;
                rst_n           : in std_logic;            
                inc             : in std_logic;    
                        
                rdsynced_wrptr  : in std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
                empty           : buffer std_logic;            
                            
                rdptr   : out std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
                addrbin : out std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0)             
        );
end async_fifo_rdptr_and_empty_handler;


architecture rtl of async_fifo_rdptr_and_empty_handler is


    signal bin_count_reg    : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    signal bin_count_next   : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    
    signal gray_count_reg   : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    signal gray_count_next  : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    
    signal empty_val : std_logic;
    
    signal wrptr_check : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    
    
begin


bin_count_next <=  Bitwise_OR_9b(bin_count_reg,(inc and not(empty)));

addrbin <= bin_count_reg(G_FIFO_ADDRWIDTH-1 downto 0);
rdptr   <= gray_count_reg; 

empty_val <= '1' when (gray_count_next = rdsynced_wrptr) else '0';


PROC_BINARY_AND_GRAY_REGS : process(clk, rst_n) begin
    if(rst_n = '0') then
        bin_count_reg   <= (others=>'0'); 
        gray_count_reg  <= (others=>'0');
        empty           <= '1';
    else
        if(rising_edge(clk)) then
            bin_count_reg   <= bin_count_next; 
            gray_count_reg  <= gray_count_next;
            empty           <= empty_val;
        end if;
    end if;
end process;                                   
 
 
INST_BINARY2GRAY : entity utils_lib.binary2gray(rtl)
    generic map (
        G_WIDTH => G_FIFO_ADDRWIDTH+1
    )
    port map (
        bin_vec     => bin_count_next,
        gray_vec    => gray_count_next    
    );


end rtl;
