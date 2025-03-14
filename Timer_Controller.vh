library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer_Controller is
    Port (
        clk       : in STD_LOGIC;  -- 50MHz clock
        reset     : in STD_LOGIC;  -- Resets timer to 99
        paused    : in STD_LOGIC;  -- Pause signal (1 = paused, 0 = running)
        current_score : in STD_LOGIC_VECTOR(13 downto 0); -- Score affects speed
        timer_out : out STD_LOGIC_VECTOR(7 downto 0) -- Timer value (99 to 00)
    );
end Timer_Controller;

architecture Behavioral of Timer_Controller is
    signal timer : UNSIGNED(7 downto 0) := "10011001"; -- 99 in binary
    signal tick_counter : UNSIGNED(25 downto 0) := (others => '0'); -- 26-bit for clock division
    signal speed_factor : UNSIGNED(25 downto 0);

    -- Base and Max speed values (adjust for faster speeds)
    constant BASE_SPEED : UNSIGNED(25 downto 0) := X"2FAF080"; -- 50M cycles ≈ 1 sec
    constant MAX_SPEED  : UNSIGNED(25 downto 0) := X"0F4240";  -- ~1/5 sec (faster mode)

begin
    -- Adjust timer speed based on score
    process(current_score)
    begin
        case current_score is
            when "00000000000000" to "00000000000100" => speed_factor <= BASE_SPEED; -- Normal speed
            when "00000000000101" to "00000000001000" => speed_factor <= BASE_SPEED - X"400000"; 
            when "00000000001001" to "00000000010000" => speed_factor <= BASE_SPEED - X"800000"; 
            when "00000000010001" to "00000000011111" => speed_factor <= BASE_SPEED - X"C00000"; 
            when others => speed_factor <= MAX_SPEED; -- Fastest countdown
        end case;
    end process;

    -- Timer countdown process
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                timer <= "10011001"; -- Reset to 99
                tick_counter <= (others => '0');
            elsif paused = '0' then  -- Only count down when not paused
                tick_counter <= tick_counter + 1;

                if tick_counter >= speed_factor then
                    tick_counter <= (others => '0');

                    if timer > 0 then
                        timer <= timer - 1; -- Decrement timer
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Assign output
    timer_out <= STD_LOGIC_VECTOR(timer);
end Behavioral;
