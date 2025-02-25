----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2025 02:58:01 PM
-- Design Name: 
-- Module Name: misc_pkg - 
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

package misc_pkg is

    function Bitwise_OR_9b(
            i_vector    : std_logic_vector(8 downto 0);
            i_bit       : std_logic)
            return std_logic_vector;

    function Bitwise_AND_8b(
            i_vector    : std_logic_vector(7 downto 0);
            i_bit       : std_logic)
            return std_logic_vector;


end package misc_pkg;
--------------------------------------
package body misc_pkg is

    --------------------------------------------
    function Bitwise_OR_9b(
            i_vector    : std_logic_vector(8 downto 0);
            i_bit       : std_logic)
            return std_logic_vector is
        
        variable o_vector : std_logic_vector(8 downto 0);
        variable vec_len : integer;
    begin
        vec_len := i_vector'length;              
        
        for i in 0 to vec_len-1 loop
            o_vector(i) := i_vector(i) or i_bit;
        end loop;
        
        return o_vector;    
    end function;        


    --------------------------------------------
    function Bitwise_AND_8b(
            i_vector    : std_logic_vector(7 downto 0);
            i_bit       : std_logic)
            return std_logic_vector is
        
        variable o_vector : std_logic_vector(7 downto 0);
        variable vec_len : integer;
    begin
        vec_len := i_vector'length;              
        
        for i in 0 to vec_len-1 loop
            o_vector(i) := i_vector(i) and i_bit;
        end loop;
        
        return o_vector;    
    end function;  

end package body misc_pkg;
