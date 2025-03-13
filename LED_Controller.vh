-- LED Controller Module
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_Controller is
    Port (
        clk       : in STD_LOGIC;
        btn_left  : in STD_LOGIC;
        btn_right : in STD_LOGIC;
        pos_out   : out STD_LOGIC_VECTOR(3 downto 0);
        led_out   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end LED_Controller;

architecture Behavioral of LED_Controller is
    signal position : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_left = '1' then
                if position = "1111" then
                    position <= "0000"; -- Wrap to the rightmost LED
                else
                    position <= std_logic_vector(unsigned(position) + 1); -- Move left
                end if;
            elsif btn_right = '1' then
                if position = "0000" then
                    position <= "1111"; -- Wrap to the leftmost LED
                else
                    position <= std_logic_vector(unsigned(position) - 1); -- Move right
                end if;
            end if;
        end if;
    end process;
    
    pos_out <= position;
    
    process(position)
        variable index : INTEGER;
    begin
        led_out <= (OTHERS => '0'); -- Reset all LEDs
        index := to_integer(unsigned(position)); -- Convert position to integer
        if index >= 0 and index < 16 then
            led_out(index) <= '1'; -- Activate the correct LED
        end if;
    end process;
end Behavioral;
