----------------------------------------------------------------------------------
-- Create Date: 16.10.2026 15:26:23
-- Design Name: clk_divider 
-- Module Name: clk_divider - Behavioral
-- Project Name: Clock Divider
-- Tool Versions: Vivado 2022.2
-- Target Devices: Basys3 with Artix7
-- Description: 
-- Divides the input clock to disired frequency 
-- Works only for divisors of 100 MHz clock - others will be casted to int
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk_divider is
    Generic (
        OUTPUT_FREQ_HZ : positive := 1;
        INPUT_FREQ_HZ : positive := 100_000_000
    );
    Port (
        clk_i : in std_logic; -- input clock
        rst_i     : in std_logic; -- asynchronous reset input
        led_o   : out std_logic -- output divided clock    
    );
end clk_divider;

architecture Behavioral of clk_divider is
    -- constants
    constant DIVIDE_BY : positive := INPUT_FREQ_HZ / OUTPUT_FREQ_HZ;
    constant LOW_STATE_COUNT : positive := (DIVIDE_BY + 1) / 2;
    constant HIGH_STATE_COUNT : positive := (DIVIDE_BY /2);
    -- signals
    signal counter : natural range 0 to DIVIDE_BY - 1;
    signal tmp     : std_logic;
begin

--    assert INPUT_FREQ_HZ mod OUTPUT_FREQ_HZ = 0 report "INPUT_FREQ_HZ must be divisible by OUTPUT_FREQ_HZ" severity failure;

--    assert DIVIDE_BY >= 2 report "The division factor must be at least 2" severity failure;

    divider: process (clk_i, rst_i)
    begin
        if rst_i='1' then
            counter <= 0;
            tmp <= '0';
        elsif rising_edge(clk_i) then
            if tmp = '0' then
                if counter = LOW_STATE_COUNT - 1 then
                    counter <= 0;
                    tmp <= '1';
                else
                    counter <= counter + 1;
                end if;
            else
                if counter = HIGH_STATE_COUNT - 1 then
                    counter <= 0;
                    tmp <= '0';
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process divider;
    
    led_o <= tmp;
end Behavioral;