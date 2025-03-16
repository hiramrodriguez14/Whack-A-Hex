library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clock_Divider_1Hz is --CLK for HIGH SCORE and CURRENT SCORE
    Port (
        clk_100MHz : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        clk_out    : out STD_LOGIC
    );
end Clock_Divider_1Hz;

architecture Behavioral of Clock_Divider_1Hz is
    signal counter : UNSIGNED(26 downto 0) := (others => '0');
    signal clk_sig : STD_LOGIC := '0';

begin
    process(clk_100MHz)
    begin
        if rising_edge(clk_100MHz) then
            if reset = '1' then
                counter <= (others => '0');
                clk_sig <= '0';
            elsif counter >= 50_000_000 then
                counter <= (others => '0');
                clk_sig <= not clk_sig;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_sig;
    
end Behavioral;
