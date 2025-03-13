-- Random Hexadecimal Generator Module
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Random_Hex_Generator is
    Port (
        clk : in STD_LOGIC;
        rand_hex : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Random_Hex_Generator;

architecture Behavioral of Random_Hex_Generator is
    signal lfsr : STD_LOGIC_VECTOR(3 downto 0) := "1101"; -- Initial seed
begin
    process(clk)
    begin
        if rising_edge(clk) then
            lfsr <= lfsr(2 downto 0) & (lfsr(3) xor lfsr(1)); -- LFSR for pseudo-random generation
        end if;
    end process;
    
    rand_hex <= lfsr;
end Behavioral;
