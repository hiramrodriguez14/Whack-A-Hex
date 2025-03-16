library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Dynamic_Clock_Divider is --CLK for play
    Port (
        clk_100MHz  : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        score       : in  STD_LOGIC_VECTOR(13 downto 0);
        state       : in  STD_LOGIC_VECTOR(2 downto 0);
        clk_dynamic : out STD_LOGIC
    );
end Dynamic_Clock_Divider;

architecture Behavioral of Dynamic_Clock_Divider is
    signal counter : UNSIGNED(26 downto 0) := (others => '0');
    signal clk_dynamic_sig : STD_LOGIC := '0';
    signal divider_value : UNSIGNED(26 downto 0);

begin
    process(clk_100MHz,state)
    begin
    if state = "010" then
        if rising_edge(clk_100MHz) then
            if reset = '1' then
                counter <= (others => '0');
                clk_dynamic_sig <= '0';
            else
                divider_value <= 50_000_000 / (1 + to_integer(unsigned(score) / 5));

                if counter >= divider_value then
                    counter <= (others => '0');
                    clk_dynamic_sig <= not clk_dynamic_sig;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    clk_dynamic <= clk_dynamic_sig;
    
end Behavioral;
