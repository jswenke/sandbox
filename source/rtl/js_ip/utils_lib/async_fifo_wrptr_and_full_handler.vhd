----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2025 02:36:11 PM
-- Design Name: 
-- Module Name: async_fifo_wrptr_and_full_handler - rtl
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
    use IEEE.std_logic_misc.or_reduce;
    
library utils_lib;
    use utils_lib.binary2gray;
    use utils_lib.misc_pkg.all;


entity async_fifo_wrptr_and_full_handler is
    generic (
            G_FIFO_ADDRWIDTH : integer := 8
    );
    port ( 
            clk             : in std_logic;
            rst_n           : in std_logic;            
            inc             : in std_logic;    
                    
            wrsynced_rdptr  : inout std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
            full            : inout std_logic;            
                        
            wrptr   : out std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
            addrbin : out std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0)             
    );
end async_fifo_wrptr_and_full_handler;


architecture rtl of async_fifo_wrptr_and_full_handler is
    
    
    signal bin_count_reg    : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0);
    signal bin_count_next   : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0);
    
    signal gray_count_reg   : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0);
    signal gray_count_next  : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0);
    
    signal full_val : std_logic;
    
    signal wrsynced_rdptr_check : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    
    
begin


bin_count_next <=  Bitwise_OR(bin_count_reg,(inc and not(full)));

addrbin <= bin_count_reg(G_FIFO_ADDRWIDTH-2 downto 0);
wrptr   <= gray_count_reg; 

wrsynced_rdptr_check(G_FIFO_ADDRWIDTH)              <= not(wrsynced_rdptr(G_FIFO_ADDRWIDTH));
wrsynced_rdptr_check(G_FIFO_ADDRWIDTH-1 downto 0)   <= wrsynced_rdptr(G_FIFO_ADDRWIDTH-1 downto 0);

full_val <= '1' when (gray_count_next = wrsynced_rdptr_check);


PROC_BINARY_AND_GRAY_REGS : process(clk, rst_n) begin
    if(rst_n = '0') then
        bin_count_reg   <= (others=>'0'); 
        gray_count_reg  <= (others=>'0');
    else
        if(rising_edge(clk)) then
            bin_count_reg   <= bin_count_next; 
            gray_count_reg  <= gray_count_next;
            full            <= full_val;
        end if;
    end if;
end process;                                   
 
 
INST_BINARY2GRAY : entity utils_lib.binary2gray(rtl)
    generic map (
        G_WIDTH => G_FIFO_ADDRWIDTH
    )
    port map (
        bin_vec     => bin_count_next,
        gray_vec    => gray_count_next    
    );
                 

end rtl;
