----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2025 10:10:05 PM
-- Design Name: 
-- Module Name: tb_async_fifo - uut
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

library utils_lib;
    use utils_lib.tb_and_sim_pack.all;
    use utils_lib.async_fifo;

entity tb_async_fifo is
    generic (
        TB_G_FIFO_ADDRWIDTH : integer := 8;
        TB_G_FIFO_DEPTH     : integer := 16;
        TB_G_FIFO_DATAWIDTH : integer := 32
    );
--  Port ( );
end tb_async_fifo;


architecture tb of tb_async_fifo is


    constant wr_clk_period : time := 10ns;
    constant rd_clk_period : time := 20ns;

    signal tb_wr_clk    : std_logic := '0';
    signal tb_wr_rst_n  : std_logic := '1';
    signal tb_wr_en     : std_logic_vector(0 downto 0) := (others=>'0');
    signal tb_wr_din    : std_logic_vector(TB_G_FIFO_DATAWIDTH-1 downto 0) := (others=>'0');
    
    signal tb_rd_clk    : std_logic := '0';
    signal tb_rd_rst_n  : std_logic := '1';
    signal tb_rd_en     : std_logic := '0';
    signal tb_rd_dout   : std_logic_vector(TB_G_FIFO_DATAWIDTH-1 downto 0);
    
    signal tb_full  : std_logic := 'Z';
    signal tb_empty : std_logic := 'Z';
    
    -- double check this syntax
    -- signal tb_arr_rec_dw32_and_wren : arr_rec_dw32_and_wren := INIT_ARR_REC_DW32_WREN;
    -- figure out syntax for making initializing the array of records with non-zero values
    -- think it's something like INIT_REC_DW32_WREN.dw32(somethingsomething) 
        
begin


    UUT_ASYNC_FIFO: entity utils_lib.async_fifo(rtl)
        generic map (         
            G_FIFO_ADDRWIDTH => TB_G_FIFO_ADDRWIDTH,
            G_FIFO_DEPTH     => TB_G_FIFO_DEPTH,
            G_FIFO_DATAWIDTH => TB_G_FIFO_DATAWIDTH
        )
        port map ( 
            -- write
            wr_clk  => tb_wr_clk,
            wr_rst_n=> tb_wr_rst_n,
            wr_en   => tb_wr_en,
            wr_din  => tb_wr_din,
                  
            -- read
            rd_clk  => tb_rd_clk,
            rd_rst_n=> tb_rd_rst_n,
            rd_en   => tb_rd_en,
            rd_dout => tb_rd_dout,
    
            -- status
            full    => tb_full,
            empty   => tb_empty
    
        );
    
    tb_wr_clk <= not(tb_wr_clk) after wr_clk_period/2;
    tb_rd_clk <= not(tb_rd_clk) after rd_clk_period/2;
    
    STIMULUS: process
    begin
        -- drive rsts for a couple clk periods
        tb_wr_rst_n <= '0';
        tb_rd_rst_n <= '0';
        wait for wr_clk_period*5;
        tb_wr_rst_n <= '1';
        tb_rd_rst_n <= '1';
        wait for wr_clk_period*5;
        
        --
        tb_wr_en    <= "1";
        tb_wr_din   <= X"0600_0090";
        wait for wr_clk_period*2;
        tb_wr_en    <= "0";
        wait for wr_clk_period*2;
        
        tb_wr_en    <= "1";
        tb_wr_din   <= X"0BAD_BAD0";
        wait for wr_clk_period*2;
        tb_wr_en    <= "0";
        wait for wr_clk_period*2;
        
        tb_wr_en    <= "1";
        tb_wr_din   <= X"8008_5135";
        wait for wr_clk_period*2;
        tb_wr_en    <= "0";
        wait for wr_clk_period*2;
        
        wait for wr_clk_period*10;
        
        
        tb_rd_en    <= '1';
        wait for rd_clk_period*2;
        tb_rd_en    <= '0';
        wait for rd_clk_period*2;
        
        tb_rd_en    <= '1';
        wait for rd_clk_period*2;
        tb_rd_en    <= '0';
        wait for rd_clk_period*2;
        
        tb_rd_en    <= '1';
        wait for rd_clk_period*2;
        tb_rd_en    <= '0';
        wait for rd_clk_period*2;
    
    
        wait;
    end process;        
        
    
     

end tb;
