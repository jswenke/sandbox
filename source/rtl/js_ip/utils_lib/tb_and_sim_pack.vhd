----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2025 08:01:55 PM
-- Design Name: 
-- Module Name: tb_and_sim_pack - Behavioral
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
    
library utils_lib;
    use utils_lib.all;    


package tb_and_sim_pack is


    type rec_dw32_and_wren is record
        dw32    : std_logic_vector(31 downto 0);
        wren    : std_logic;
    end record rec_dw32_and_wren;         
        
    type arr_rec_dw32_and_wren is array (integer range <>) of rec_dw32_and_wren;         
            
    constant INIT_REC_DW32_WREN : rec_dw32_and_wren := (
        dw32    => (others=>'0'),
        wren    => '0'
    );
    
--    constant INIT_ARR_REC_DW32_WREN : arr_rec_dw32_and_wren := (
--        others => INIT_REC_DW32_WREN
--    );




end package;
