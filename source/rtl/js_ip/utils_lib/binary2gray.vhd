----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 10:55:21 PM
-- Design Name: 
-- Module Name: binary2gray - rtl
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

entity binary2gray is
    generic (
        G_WIDTH : integer := 8
    );
    port ( 
        bin_vec     : in std_logic_vector(G_WIDTH-1 downto 0);
        gray_vec    : out std_logic_vector(G_WIDTH-1 downto 0)     
    );
end binary2gray;

architecture rtl of binary2gray is

begin

gray_vec(G_WIDTH-1) <= bin_vec(G_WIDTH-1);

GEN_BIN2GRAY : for i in 0 to G_WIDTH-2 generate
    gray_vec(i) <= bin_vec(i) xor bin_vec(i+1);    
end generate;            


end rtl;
