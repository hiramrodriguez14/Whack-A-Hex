library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Score_Storage is
    Port (
        clk         : in STD_LOGIC;  -- Clock signal
        reset       : in STD_LOGIC;  -- Reset signal (resets current score)
        game_over   : in STD_LOGIC;  -- Signal indicating the game has ended
        increment   : in STD_LOGIC;  -- Signal to increase the score
        current_score : out STD_LOGIC_VECTOR(7 downto 0); -- Current game score
        high_score : out STD_LOGIC_VECTOR(7 downto 0) -- Highest recorded score
    );
end Score_Storage;

architecture Behavioral of Score_Storage is
    signal score : UNSIGNED(7 downto 0) := (others => '0'); -- Current score
    signal max_score : UNSIGNED(7 downto 0) := (others => '0'); -- High score
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset current score to 0
                score <= (others => '0');
            elsif increment = '1' then
                -- Increase current score
                score <= score + 1;
            end if;

            -- Update high score at game over
            if game_over = '1' then
                if score > max_score then
                    max_score <= score; -- Update high score if current score is greater
                end if;
            end if;
        end if;
    end process;

    -- Assign score values to outputs
    current_score <= STD_LOGIC_VECTOR(score);
    high_score <= STD_LOGIC_VECTOR(max_score);
end Behavioral;
