----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 09:24:28 PM
-- Design Name: 
-- Module Name: eth_crc - rtl
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


entity eth_crc is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        din     : in std_logic_vector(1 downto 0);
        en      : in std_logic;
        
        crc     : out std_logic_vector(31 downto 0);
        crc_err : out std_logic    
    );
end eth_crc;

architecture rtl of eth_crc is

    signal crc_next : std_logic_vector(31 downto 0);

begin


end rtl;
