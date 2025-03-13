-- Testbench for Random Hex Generator
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Random_Hex_Generator is
end tb_Random_Hex_Generator;

architecture testbench of tb_Random_Hex_Generator is
    signal clk : STD_LOGIC := '0';
    signal rand_hex : STD_LOGIC_VECTOR(3 downto 0);
    
    component Random_Hex_Generator
        Port (
            clk : in STD_LOGIC;
            rand_hex : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
begin
    -- Instantiate the unit under test
    UUT: Random_Hex_Generator port map (clk => clk, rand_hex => rand_hex);
    
    -- Clock process
    process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
end testbench;

