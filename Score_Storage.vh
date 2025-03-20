library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Score_Storage is
    Port (
        clk           : in STD_LOGIC;
        reset         : in STD_LOGIC;
        state         : in STD_LOGIC_VECTOR(2 downto 0);
        increment     : in STD_LOGIC;
        current_score : out STD_LOGIC_VECTOR(13 downto 0);
        high_score    : out STD_LOGIC_VECTOR(13 downto 0)
    );
end Score_Storage;

architecture Behavioral of Score_Storage is
    signal score      : UNSIGNED(13 downto 0) := (others => '0');
    signal max_score  : UNSIGNED(13 downto 0) := (others => '0');
    signal inc_flag   : STD_LOGIC := '0';

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                score <= (others => '0');
            elsif state = "010" then
                if increment = '1' and inc_flag = '0' then
                    if score < 9999 then
                        score <= score + 1;
                    end if;
                    inc_flag <= '1';
                elsif increment = '0' then
                    inc_flag <= '0';
                end if;
            end if;

            if state = "101" then
                if score > max_score then
                    max_score <= score;
                end if;
            end if;
        end if;
    end process;

    current_score <= STD_LOGIC_VECTOR(score);
    high_score    <= STD_LOGIC_VECTOR(max_score);

end Behavioral;
