----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2025 08:37:13 PM
-- Design Name: 
-- Module Name: async_fifo_js - rtl
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
-- NOTE ON G_FIFO_ADDRWIDTH:
-- Actual FIFO depth is 2^(ADDRWIDTH-1)
--
-- Of course, we'd only need a 4 bit vector for a pointer that has 16 possible addresses,
-- however we want the extra bit there to detect rollover of the write pointer -
-- this is one way of differentiating fifo full & fifo empty
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

library UNISIM;
    use UNISIM.VComponents.all;

entity async_fifo is
    Generic (         
        G_FIFO_ADDRWIDTH : integer := 5; -- 2^(ADDRWIDTH-1) = FIFO Depth
        G_FIFO_DEPTH     : integer := 16;
        G_FIFO_DATAWIDTH : integer := 32
    );
    Port ( 
        -- write
        wr_clk  : in std_logic;
        wr_rst  : in std_logic;
        wr_en   : in std_logic;
        wr_din  : in std_logic_vector(G_FIFO_DATAWIDTH-1 downto 0);
              
        -- read
        rd_clk  : in std_logic;
        rd_rst  : in std_logic;
        rd_en   : in std_logic;
        rd_dout : out std_logic_vector(G_FIFO_DATAWIDTH-1 downto 0);

        -- status
        full : out std_logic;
        empty: out std_logic

    );
end async_fifo;


architecture rtl of async_fifo is


    type type_fifo is array (0 to G_FIFO_DEPTH-1) of std_logic_vector(G_FIFO_DATAWIDTH-1 downto 0);
        signal fifo_inf : type_fifo := (others=>(others=>'0'));

    signal rd_pntr : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0) := (others=>'0');
    signal wr_pntr : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0) := (others=>'0');


begin


    PROC_FIFO_WR_HANDLE : process(wr_clk, wr_rst)
    begin

    end process;

    
    PROC_FIFO_RD_HANDLE : process(rd_clk, rd_rst)
    begin

    end process;


end rtl;
