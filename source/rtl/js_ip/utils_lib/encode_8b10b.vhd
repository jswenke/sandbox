----------------------------------------------------------------------------------
-- Company: 
-- Engineer: J. Swenke 
-- 
-- Create Date: 04/29/2025 08:48:10 PM
-- Design Name: 
-- Module Name: encode_8b10b - rtl
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
-- Designed in accordance with Xilinx XAPP1122 "Parameterizable 8b/10b Encoder" v1.1, Application
-- and IBM doc "The ANSI Fibre Channel Transmission Code"
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;


entity encode_8b10b is
    port (
        clk         : in std_logic;
        ce          : in std_logic;
        din         : in std_logic_vector(7 downto 0);
        kin         : in std_logic;
        force_code  : in std_logic;
        force_disp  : in std_logic;
        disp_in     : in std_logic;
        
        dout        : out std_logic_vector(9 downto 0);
        kerr        : out std_logic;
        disp_out    : out std_logic;
        nd          : out std_logic        
    );
end encode_8b10b;


architecture rtl of encode_8b10b is

    -- need to look more into what implementation to do 
    -- implement in LUTs using logic equations or strictly in BRAM using a memory init file
    -- if I go the LUT route, need better understanding of the logic equations explained in the tables/document

begin


end rtl;
