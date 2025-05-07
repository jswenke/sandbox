----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2025 02:32:41 PM
-- Design Name: 
-- Module Name: eth_rx_mac - rtl
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
    
library eth_lib;
    use eth_lib.all;    


entity eth_rx_mac is
    port ( 
        rx_rst         : in std_logic;
        rx_clk          : in std_logic;
        rx_dv           : in std_logic;
        rx_din          : in std_logic_vector(3 downto 0);
        
        rx_dout         : out std_logic(7 downto 0);
        rx_valid_out    : out std_logic;
        rx_start_frame  : out std_logic;
        rx_end_frame    : out std_logic;
        
        byte_count      : out std_logic_vector(15 downto 0);
        byte_count_eq0  : out std_logic;
        byte_count_gt2  : out std_logic;                        -- greater than 2
        byte_count_maxfr: out std_logic;                        -- max frame  
        
        MAC             : in std_logic_vector(47 downto 0);     -- station address
        en_broadcast    : in std_logic;                         -- broadcast "disable" in opencore module 
        en_promisc      : in std_logic;                         -- en promiscuous
        HASH0           : in std_logic_vector(31 downto 0);     -- lower 4 bytes of hash signal
        HASH1           : in std_logic_vector(31 downto 0);     -- upper 4 bytes of hash table 
        
        flag_txing_now  : in std_logic;                         -- flag en when txing (?)
        
        en_ifg          : in std_logic;                         -- min. interframe gap enable        
        
        en_hug          : in std_logic;                         -- enable larger than normal eth packet rx, when disabled (0) - packets must be smaller than max_fl
        max_fl          : in std_logic_vector(15 downto 0);     -- max frame length (?)
        
        en_delay_crc    : in std_logic;              
        err_crc         : out std_logic; 
        
        state_idle      : out std_logic;
        state_preamble  : out std_logic;
        state_SFD       : out std_logic;
        state_data      : out std_logic_vector(1 downto 0);
        
        -- need more info on this group of signals
        rx_abort        : out std_logic;                        -- ?
        address_miss    : out std_logic;                        -- ?
        pass_all        : in std_logic;                         -- ?
        control_fr_addr : in std_logic                          -- ?        
    );
end eth_rx_mac;


architecture rtl of eth_rx_mac is

    -- crc related
    signal data_crc : std_logic_vector(3 downto 0);
    signal en_crc   : std_logic;
    signal init_crc : std_logic;
    signal crc      : std_logic_vector(31 downto 0);

begin



    INST_ETH_CRC: entity eth_lib.eth_crc(rtl)
        port map(
            clk     => rx_clk,
            rst     => rx_rst,
            din     => data_crc,
            en      => en_crc,
            init    => init_crc,
            crc     => crc,
            err_crc => err_crc       
        );


end rtl;
