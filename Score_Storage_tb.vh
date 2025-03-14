library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Score_Storage is
end tb_Score_Storage;

architecture testbench of tb_Score_Storage is
    signal clk         : STD_LOGIC := '0';
    signal reset       : STD_LOGIC := '0';
    signal game_over   : STD_LOGIC := '0';
    signal increment   : STD_LOGIC := '0';
    signal current_score : STD_LOGIC_VECTOR(7 downto 0);
    signal high_score : STD_LOGIC_VECTOR(7 downto 0);

    component Score_Storage
        Port (
            clk         : in STD_LOGIC;
            reset       : in STD_LOGIC;
            game_over   : in STD_LOGIC;
            increment   : in STD_LOGIC;
            current_score : out STD_LOGIC_VECTOR(7 downto 0);
            high_score : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
begin
    -- Instantiate Score Storage
    UUT: Score_Storage port map (
        clk => clk,
        reset => reset,
        game_over => game_over,
        increment => increment,
        current_score => current_score,
        high_score => high_score
    );

    -- Clock process
    process
    begin
        while now < 500 ms loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Test process
    process
    begin
        -- Reset score
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- Increment score
        increment <= '1';
        wait for 50 ns;
        increment <= '0';
        wait for 50 ns;
        increment <= '1';
        wait for 50 ns;
        increment <= '0';

        -- End game (Check if high score updates)
        game_over <= '1';
        wait for 50 ns;
        game_over <= '0';

        -- Start a new game and increase the score more than last time
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        increment <= '1';
        wait for 50 ns;
        increment <= '0';
        wait for 50 ns;
        increment <= '1';
        wait for 50 ns;
        increment <= '0';
        wait for 50 ns;
        increment <= '1';
        wait for 50 ns;
        increment <= '0';

        -- End game (Check if high score updates again)
        game_over <= '1';
        wait for 50 ns;
        game_over <= '0';

        wait;
    end process;
end testbench;
