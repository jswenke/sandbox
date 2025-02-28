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
-- Vivado Design User Guide: Synthesis (UG901)
-- PDF pg. 127: Simple Dual-Port Block RAM with Single Clock
-- 
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.std_logic_unsigned.ALL;

entity dpram is
    generic (
        DEPTH_WIDTH: integer := 512; -- 2^ADDR_WIDTH
        ADDR_WIDTH : integer := 8;
        DATA_WIDTH : integer := 32
    );
    port (
        --
        clk     : in std_logic;
        ena     : in std_logic;
        enb     : in std_logic;
        wea     : in std_logic;
        addra   : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        addrb   : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        dia     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dob     : out std_logic_vector(DATA_WIDTH-1 downto 0)      
    );
end dpram;

architecture rtl of dpram is

    type ram_type is array (DEPTH_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
    shared variable RAM : ram_type;

begin

    HANDLE_PORT_A: process(clk)
    begin
        if clk'event and clk='1' then
            if ena = '1' then
                if wea = '1' then
                    RAM(conv_integer(addra)) := dia;
                end if;
            end if;
        end if;
    end process;
    
    HANDLE_PORT_B: process(clk)
    begin
        if clk'event and clk='1' then
            if enb = '1' then
                dob <= RAM(conv_integer(addrb));
            end if;
        end if;
    end process;
                
            

end rtl;


--        wr_clk      : in std_logic;
--        wr_clk_en   : in std_logic;
        
--        wr_din      : in std_logic_vector(DATA_WIDTH-1 downto 0);
--        wr_addr     : in std_logic_vector(ADDR_WIDTH-1 downto 0);
--        wr_full     : in std_logic;
        
--        rd_dout     : out std_logic_vector(DATA_WIDTH-1 downto 0);
--        rd_addr     : out std_logic_vector(ADDR_WIDTH-1 downto 0)
