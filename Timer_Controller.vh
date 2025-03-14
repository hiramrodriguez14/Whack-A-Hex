library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer_Controller is
    Port (
        clk           : in STD_LOGIC;  -- Clock input
        reset         : in STD_LOGIC;  -- Resets timer to 99
        paused        : in STD_LOGIC;  -- Pause signal (1 = paused, 0 = running)
        current_score : in STD_LOGIC_VECTOR(7 downto 0); -- Player's score
        timer_out     : out STD_LOGIC_VECTOR(7 downto 0) -- Timer value (99 to 00)
    );
end Timer_Controller;

architecture Behavioral of Timer_Controller is
    signal timer : UNSIGNED(7 downto 0) := "10011001"; -- 99 in binary
    signal tick_counter : UNSIGNED(23 downto 0) := (others => '0'); -- Slows clock to 1Hz

    -- Dynamic speed adjustment based on score
    signal speed_factor : UNSIGNED(23 downto 0);

    -- Base clock cycle values (starting slow, speeds up as score increases)
    constant BASE_SPEED   : UNSIGNED(23 downto 0) := X"989680"; -- ~1Hz at start (50M cycles)
    constant MAX_SPEED    : UNSIGNED(23 downto 0) := X"2DC6C0"; -- ~4Hz at max speed (10M cycles)

begin
    -- Adjust speed based on score: higher score = faster timer
    process(current_score)
    begin
        case current_score is
            when "00000000" to "00000100" => speed_factor <= BASE_SPEED; -- Score 0-4: Normal speed (1Hz)
            when "00000101" to "00001000" => speed_factor <= BASE_SPEED - X"100000"; -- Slightly faster
            when "00001001" to "00001100" => speed_factor <= BASE_SPEED - X"200000"; -- Medium fast
            when "00001101" to "00010000" => speed_factor <= BASE_SPEED - X"300000"; -- Faster
            when "00010001" to "00011111" => speed_factor <= BASE_SPEED - X"400000"; -- Very fast
            when others => speed_factor <= MAX_SPEED; -- Cap the speed at MAX_SPEED
        end case;
    end process;

    -- Timer countdown process
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                timer <= "10011001"; -- Reset to 99
                tick_counter <= (others => '0');
            elsif paused = '0' then -- Only count down when not paused
                tick_counter <= tick_counter + 1;
                if tick_counter >= speed_factor then
                    tick_counter <= (others => '0');
                    if timer > 0 then
                        timer <= timer - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Output timer value
    timer_out <= STD_LOGIC_VECTOR(timer);
end Behavioral;
