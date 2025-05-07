----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2025 05:55:26 PM
-- Design Name: 
-- Module Name: eth_top - rtl
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
-- eth_top.vhd will contain:
--      - eth_wishbone (?) (may replace with some kind of PCIe interface)
--      - eth_registers.vhd
--      - eth_rxethmac.vhd
--      - eth_macstatus.vhd
--      - eth_txethmac.vhd
--      - eth_maccontrol.vhd
--      - eth_miim.vhd
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
library eth_lib;
    use eth_lib.all;    


-- NOTE: Artix7 dev board setup I think only has 2 bits for RX/TX din/dout - will need to adjust logic for those accordingly

entity eth_top is
    port ( 
        --
        SYS_RST     : in std_logic;
        CLK100MHZ   : in std_logic;
        
        -- eth
        ETH_MDC     : out std_logic;                    -- management data clock (clock for teh MDIO serial channel)   
        ETH_MDIO    : inout std_logic;                  -- management data input/output. bi-directional serial data channel for PHY/STA communication
        --ETH_RSTN    : in std_logic;                     -- can make this general system reset          
        ETH_CRSDV   : in std_logic;                     -- carrier sense - phy asynchronously asserts carrier sense signal after the medium is detected in a non-idle state. when deasserted, signal indiciates that the media is in an idle state (and the transmission can start)
        
        ETH_RXCLK   : in std_logic;
        ETH_RXERR   : in std_logic;                     -- PHY asserts this to indiciate to the RX MAC that a media error was detected during transmission of current frame
        ETH_RXDIN   : in std_logic_vector(3 downto 0);  -- receive data bits, when
        ETH_RXDV    : in std_logic; 
        
        ETH_TXCLK   : in std_logic;
        ETH_TXEN    : out std_logic;                    -- TX enable, when asserted indicates to PHY that TXD(1:0) is valid and TX can start (remains asserted till all bits to be TX'd are presented to the PHY
        ETH_TXD     : out std_logic_vector(3 downto 0)  -- TX data bits
    
    );
end eth_top;


architecture rtl of eth_top is




begin


    -- ETH_RXETHMAC NOTES --
    -- In charge of RX'ing data
    -- External PHY chip:
        -- receives serial data from the physical layer (cable)
        -- assembles it into 2 bit packets (MRxD [1:0]), doesn't have a DV to go along with it in this example?
        -- RX_ETHMAC then assembles the 2 bit packets into data bytes, and will send them elsewhere with a few signals   
        -- SUBMODULES:
            -- eth_crc          : Cyclic Rendundancy Check (CRC)
            -- eth_rxaddrcheck  : address recognition module
            -- eth_rxcounters   : counters needed for packet reception
            -- eth_rxstatem     : fsm for rx module
    INST_RX_ETHMAC: entity eth_lib.eth_rx_mac(rtl)
        port map(
            rx_rst          => SYS_RST, -- need a rx clk synced rst potentially, after determining what they're using rst for
            rx_clk          => ETH_RXCLK,
            rx_dv           => ETH_RXDV,
            rx_din          => ETH_RXDIN,
            
            rx_dout         => ,
            rx_valid_out    => ,
            rx_start_frame  => ,
            rx_end_frame    => ,
            
            byte_count      => ,
            byte_count_eq0  => ,
            byte_count_gt2  => ,
            byte_count_maxfr=> ,  
            
            MAC             => ,
            en_broadcast    => , 
            en_promisc      => ,
            HASH0           => ,
            HASH1           => , 
            
            flag_txing_now  => ,
            
            en_ifg          => ,        
            
            en_hug          => ,
            max_fl          => ,
            
            en_delay_crc    => ,              
            err_crc         => , 
            
            state_idle      => ,
            state_preamble  => ,
            state_SFD       => ,
            state_data      => ,
            
            -- need more info on this group of signals
            rx_abort        => ,
            address_miss    => ,
            pass_all        => ,
            control_fr_addr =>                 
        
        );
    


    -- ETH_TXETHAMC NOTES --
    -- In charge of TX'ing data
    -- Will (eventually) get data from wishbone/PCIe/other in byte form 
        -- SUBMODULES:
            -- eth_crc          : Cyclic Rendundancy Check (CRC) generates 32-bit CRC appended to data field
            -- eth_random       : generates random delay needed when back off is performed (after collision)
            -- eth_txcounters   : counters needed for packet tx
            -- eth_txstatem     : fsm for tx module
    --INST_TXETHMAC:
    
    
    -- ETH_MIIM NOTES --
    -- Used for setting PHY's configuration registers and reading status from it
        -- SUBMODULES:
            -- eth_clockgen     : generates MII clock signal (Mdc), used for clocking MII interface of teh PHY chip (READ DOC OF PHY CHIP ON NEXYS A7 TO SET MDC FREQ.)
            -- eth_shiftreg     : serialize data that goes toward Eth PHY chip (Mdo), parallelize input data from Eth PHY chip )Mdi), generate linkfail signal
            -- eth_outputcontrol: generates MII serial output signal (Mdo), generates enable signal (MdoEn) for Mdo
    --INST_ETH_MIIM:
    
    
    -- ETH_MACCONTROL NOTES --
    -- In charge of data flow control in full duplex mode
        -- SUBMODULES:
            -- eth_txcontrol    : 
            -- eth_rxcontrol    :
    -- INST_ETH_MACCONTROL:
         
    
    -- ETH_MACSTATUS NOTES --
    -- Monitors ethernet MAC operations
    --INST_ETH_MACSTATUS:
    
    
    -- Look more into this, but shouldn't be necessary for a loopback configuration
    --INST_ETHREGISTERS:


end rtl;
