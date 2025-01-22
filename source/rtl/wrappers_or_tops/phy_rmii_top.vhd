

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity phy_rmii_top is
    Port (
            ETH_MDC     : in std_logic;
            ETH_MDIO    : in std_logic;
            ETH_RSTN    : in std_logic;
            ETH_CRSDV   : in std_logic;
            ETH_RXERR   : in std_logic;
            ETH_RXD     : in std_logic_vector(1 downto 0);
            
            ETH_TXEN    : out std_logic;
            ETH_TXD     : out std_logic_vector(1 downto 0);
            
            ETH_REFCLK  : out std_logic; -- not sure if out
            ETH_INTN    : out std_logic -- not sure if out        
    );
end phy_rmii_top;

-- access PHY using axi_ethernetlite, then
-- insert mii_to_rmii (Ethernet PHY MII to Reduced MII) to convert the MAC interface from MII to RMII

-- 50 MHz clk needs to be generated for mii_to_rmii core and the CLKIN pin of the external PHY
-- to account for skew introduced by the mii_to_rmii core, generate each clk individually 
-- with the eternal PHY clk having a 45 degree phase shift relative to the mii_to_rmii Ref_Clk

architecture rtl of phy_rmii_top is

begin


end rtl;
