library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_Controller is
    Port (
        clk       : in STD_LOGIC; -- 100MHz clk
        btn_left  : in STD_LOGIC;
        btn_right : in STD_LOGIC;
        pos_out   : out STD_LOGIC_VECTOR(3 downto 0);
        led_out   : out STD_LOGIC_VECTOR(15 downto 0);
        state     : in STD_LOGIC_VECTOR(2 downto 0)
    );
end LED_Controller;

architecture Behavioral of LED_Controller is
    signal position : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if state = "010" then
                if btn_left = '1' then
                    if position = "1111" then
                        position <= "0000"; -- Wrap to rightmost LED
                    else
                        position <= std_logic_vector(unsigned(position) + 1);
                    end if;
                elsif btn_right = '1' then
                    if position = "0000" then
                        position <= "1111"; -- Wrap to leftmost LED
                    else
                        position <= std_logic_vector(unsigned(position) - 1);
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    pos_out <= position;
    
    process(position)
        variable index : INTEGER;
    begin
        led_out <= (others => '0'); -- Reset all LEDs
        index := to_integer(unsigned(position));
        if index >= 0 and index < 16 then
            led_out(index) <= '1'; -- Activate the correct LED
        end if;
    end process;
end Behavioral;
