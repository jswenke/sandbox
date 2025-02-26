----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2025 11:16:27 PM
-- Design Name: 
-- Module Name: dpram - rtl
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

entity dpram is
    generic (
        ADDR_WIDTH : integer := 4;
        DATA_WIDTH : integer := 32
    );
    port (
        --
        wr_clk      : in std_logic;
        wr_clk_en   : in std_logic;
        
        wr_din      : in std_logic_vector(DATA_WIDTH-1 downto 0);
        wr_addr     : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        wr_full     : in std_logic;
        
        rd_dout     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        rd_addr     : out std_logic_vector(ADDR_WIDTH-1 downto 0)       

    );
end dpram;

architecture rtl of dpram is

begin


end rtl;
