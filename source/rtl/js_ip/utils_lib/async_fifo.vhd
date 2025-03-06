----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2025 08:37:13 PM
-- Design Name: 
-- Module Name: async_fifo_js - rtl
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
-- NOTE ON G_FIFO_ADDRWIDTH:
-- Actual FIFO depth is 2^(ADDRWIDTH-1)
--
-- Of course, we'd only need a 4 bit vector for a pointer that has 16 possible addresses,
-- however we want the extra bit there to detect rollover of the write pointer -
-- this is one way of differentiating fifo full & fifo empty
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

library UNISIM;
    use UNISIM.VComponents.all;

library utils_lib;
    use utils_lib.all;


entity async_fifo is
    Generic (         
        G_FIFO_ADDRWIDTH : integer := 8; -- 2^(ADDRWIDTH-1) = FIFO Depth
        G_FIFO_DEPTH     : integer := 16;
        G_FIFO_DATAWIDTH : integer := 32
    );
    Port ( 
        -- write
        wr_clk  : in std_logic;
        wr_rst_n: in std_logic;
        wr_en   : in std_logic_vector(0 downto 0);
        wr_din  : in std_logic_vector(G_FIFO_DATAWIDTH-1 downto 0);
              
        -- read
        rd_clk  : in std_logic;
        rd_rst_n: in std_logic;
        rd_en   : in std_logic;
        rd_dout : out std_logic_vector(G_FIFO_DATAWIDTH-1 downto 0);

        -- status
        full : buffer std_logic;
        empty: buffer std_logic

    );
end async_fifo;


architecture rtl of async_fifo is


    type type_fifo is array (0 to G_FIFO_DEPTH-1) of std_logic_vector(G_FIFO_DATAWIDTH-1 downto 0);
        signal fifo_inf : type_fifo := (others=>(others=>'0'));

    signal rd_pntr : std_logic_vector(G_FIFO_ADDRWIDTH downto 0)    := (others=>'0');
    signal rd_addr : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0)  := (others=>'0');
    signal wr_pntr : std_logic_vector(G_FIFO_ADDRWIDTH downto 0)    := (others=>'0');
    signal wr_addr : std_logic_vector(G_FIFO_ADDRWIDTH-1 downto 0)  := (others=>'0');

    
    -- wr/full handler signals
    signal wr_clk_en: std_logic;
    signal wr_inc   : std_logic;
    signal rd_inc   : std_logic;
    signal rd_rst   : std_logic;

    signal wrsynced_rdptr       : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    signal rdptr_reg0           : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    signal rdptr_reg1           : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    
    signal rdsynced_wrptr       : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    signal wrptr_reg0           : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    signal wrptr_reg1           : std_logic_vector(G_FIFO_ADDRWIDTH downto 0);
    
    
begin


    wr_clk_en <= not(full) and wr_inc;         


    PROC_SYNC_RDPTR_TO_WRCLK : process(wr_clk, wr_rst_n)
    begin  
        if(wr_rst_n = '0') then
            rdptr_reg0      <= (others=>'0');
            wrsynced_rdptr  <= (others=>'0');
        else            
            if(rising_edge(wr_clk)) then
                rdptr_reg0      <= rd_pntr;
                wrsynced_rdptr  <= rdptr_reg0;
            end if;
        end if;
    end process;        
    
    
    PROC_SYNC_WRPTR_TO_RDCLK : process(rd_clk, rd_rst_n)
    begin  
        if(rd_rst_n = '0') then
            wrptr_reg0      <= (others=>'0');
            rdsynced_wrptr  <= (others=>'0');
        else                        
            if(rising_edge(rd_clk)) then
                wrptr_reg0      <= wr_pntr;
                rdsynced_wrptr  <= wrptr_reg0;
            end if;
        end if;            
    end process;
    
    
    INST_WRPTR_AND_FULL_HANDLER : entity utils_lib.async_fifo_wrptr_and_full_handler(rtl)
        generic map (
            G_FIFO_ADDRWIDTH => G_FIFO_ADDRWIDTH
        )
        port map ( 
            clk             => wr_clk,
            rst_n           => wr_rst_n,
            inc             => wr_inc,
            
            wrsynced_rdptr  => wrsynced_rdptr,
            full            => full,
            
            wrptr           => wr_pntr,
            addrbin         => wr_addr             
        );
        

    INST_RDPTR_AND_EMPTY_HANDLER : entity utils_lib.async_fifo_rdptr_and_empty_handler(rtl)
        generic map (
            G_FIFO_ADDRWIDTH => G_FIFO_ADDRWIDTH
        )
        port map ( 
            clk             => rd_clk,
            rst_n           => rd_rst_n,
            inc             => rd_inc,
            
            rdsynced_wrptr  => rdsynced_wrptr,
            empty           => empty,
            
            rdptr           => rd_pntr,
            addrbin         => rd_addr             
        );        
    
    rd_rst <= not(rd_rst_n);
    
    INST_SDPRAM: entity utils_lib.dpram(rtl)
        generic map (
            DEPTH_WIDTH => 512,
            ADDR_WIDTH  => 8,
            DATA_WIDTH  => 32
        )
        port map (
            --
            clk     => wr_clk,
            ena     => wr_en(0),
            enb     => rd_en,
            wea     => wr_clk_en,
            addra   => wr_addr,
            addrb   => rd_addr,
            dia     => wr_din,
            dob     => rd_dout   
        );



end rtl;
