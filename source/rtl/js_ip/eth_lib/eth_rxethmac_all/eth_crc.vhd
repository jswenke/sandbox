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
        din     : in std_logic_vector(3 downto 0);
        en      : in std_logic;
        init    : in std_logic;
        crc     : buffer std_logic_vector(31 downto 0);
        err_crc : out std_logic    
    );
end eth_crc;


architecture rtl of eth_crc is


    signal crc_next : std_logic_vector(31 downto 0);


begin



    crc_next(0)  <= en and (din(0) xor crc(28));
    crc_next(1)  <= en and (din(1) xor din(0) xor crc(28) xor crc(29));
    crc_next(2)  <= en and (din(2) xor din(1) xor din(0) xor crc(28) xor crc(29) xor crc(30));
    crc_next(3)  <= en and (din(3) xor din(2) xor din(1) xor crc(29) xor crc(30) xor crc(31));
    crc_next(4)  <= (en and (din(3) xor din(2) xor din(0) xor crc(28) xor crc(30) xor crc(31))) xor crc(0);
    crc_next(5)  <= (en and (din(3) xor din(1) xor din(0) xor crc(28) xor crc(29) xor crc(31))) xor crc(1);
    crc_next(6)  <= (en and (din(2) xor din(1) xor crc(29) xor crc(30))) xor crc(2);
    crc_next(7)  <= (en and (din(3) xor din(2) xor din(0) xor crc(28) xor crc(30) xor crc(31))) xor crc(3);
    crc_next(8)  <= (en and (din(3) xor din(1) xor din(0) xor crc(28) xor crc(29) xor crc(31))) xor crc(4);
    crc_next(9)  <= (en and (din(2) xor din(1) xor crc(29) xor crc(30))) xor crc(5);
    crc_next(10) <= (en and (din(3) xor din(2) xor din(0) xor crc(28) xor crc(30) xor crc(31))) xor crc(6);
    crc_next(11) <= (en and (din(3) xor din(1) xor din(0) xor crc(28) xor crc(29) xor crc(31))) xor crc(7);
    crc_next(12) <= (en and (din(3) xor din(1) xor din(0) xor crc(28) xor crc(29) xor crc(30))) xor crc(8);
    crc_next(13) <= (en and (din(3) xor din(2) xor din(1) xor crc(29) xor crc(30) xor crc(31))) xor crc(9);
    crc_next(14) <= (en and (din(3) xor din(2) xor crc(30) xor crc(31))) xor crc(10);
    crc_next(15) <= (en and (din(3) xor crc(31))) xor crc(11);
    crc_next(16) <= (en and (din(0) xor crc(28))) xor crc(12);
    crc_next(17) <= (en and (din(1) xor crc(29))) xor crc(13);
    crc_next(18) <= (en and (din(2) xor crc(30))) xor crc(14);
    crc_next(19) <= (en and (din(3) xor crc(31))) xor crc(15);
    crc_next(20) <= crc(16);
    crc_next(21) <= crc(17);
    crc_next(22) <= (en and (din(0) xor crc(28))) xor crc(18);
    crc_next(23) <= (en and (din(1) xor din(0) xor crc(29) xor crc(28))) xor crc(19);
    crc_next(24) <= (en and (din(2) xor din(1) xor crc(30) xor crc(29))) xor crc(20);
    crc_next(25) <= (en and (din(3) xor din(2) xor crc(31) xor crc(30))) xor crc(21);
    crc_next(26) <= (en and (din(3) xor din(0) xor crc(31) xor crc(28))) xor crc(22);
    crc_next(27) <= (en and (din(1) xor crc(29) xor crc(23)));
    crc_next(28) <= (en and (din(2) xor crc(30) xor crc(24)));
    crc_next(29) <= (en and (din(3) xor crc(31) xor crc(25)));
    crc_next(30) <= crc(26);
    crc_next(31) <= crc(27);
    
    process(clk, rst) 
    begin
        if(rst = '1') then
            crc <= (others => '1');
        else
            if(rising_edge(clk)) then
                if(init = '1') then
                    crc <= (others => '1');
                else
                    crc <= crc_next;
                end if;
            end if;
        end if;
    end process;
    
    err_crc <= '1' when crc = not(x"c704_dd7b") else '1';                                                                                              
    
    
    
end rtl;
