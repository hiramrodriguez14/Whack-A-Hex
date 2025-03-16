library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Random_Hex_Generator is 
    Port (
        clk       : in  STD_LOGIC; -- 100 MHz clock
        btn_center : in  STD_LOGIC;
        rand_hex  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Random_Hex_Generator;

architecture Behavioral of Random_Hex_Generator is
    signal counter : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal hex_value : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = "1111" then
                counter <= "0000";
            else
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;

            if btn_center = '1' then
                hex_value <= counter;
            end if;
        end if;
    end process;

    rand_hex <= hex_value;
end Behavioral;
