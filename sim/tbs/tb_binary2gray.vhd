----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 11:16:14 PM
-- Design Name: 
-- Module Name: tb_binary2gray - uut
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
    use utils_lib.all;

entity tb_binary2gray is
    generic (
        G_TB_WIDTH : integer := 8
    );
--  Port ( );
end tb_binary2gray;



architecture uut of tb_binary2gray is

    signal tb_bin_vec   : std_logic_vector(G_TB_WIDTH-1 downto 0);
    signal tb_gray_vec  : std_logic_vector(G_TB_WIDTH-1 downto 0);
    
begin

UUT_binary2gray : entity utils_lib.binary2gray(rtl)
    generic map (
        G_WIDTH => 8
    )
    port map ( 
        bin_vec     => tb_bin_vec,
        gray_vec    => tb_gray_vec   
    );

STIMULUS : process
    begin
    
        tb_bin_vec <= X"00";
        wait for 10ns;
        
        tb_bin_vec <= X"03";
        wait for 10ns;
        
        tb_bin_vec <= X"A7";
        wait for 10ns;
        
        tb_bin_vec <= X"BB";
        wait for 10ns;
        
        tb_bin_vec <= X"50";
        wait for 10ns;        

        tb_bin_vec <= X"A7";
        wait for 10ns;
        
    wait;
end process;    


end uut;
