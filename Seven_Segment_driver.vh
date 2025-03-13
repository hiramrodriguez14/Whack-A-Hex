-- Seven-Segment Display Driver Module
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Seven_Segment_Driver is
    Port (
        clk   : in STD_LOGIC;
        hex1, hex2, hex3, hex4 : in STD_LOGIC_VECTOR(3 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        an    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Seven_Segment_Driver;

architecture Behavioral of Seven_Segment_Driver is
    signal digit_select : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal current_digit : STD_LOGIC_VECTOR(3 downto 0);
    
    function hex_to_7seg(hex: STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case hex is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0010010"; -- 5
            when "0110" => return "0000010"; -- 6
            when "0111" => return "1111000"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0010000"; -- 9
            when "1010" => return "0001000"; -- A
            when "1011" => return "0000011"; -- B
            when "1100" => return "1000110"; -- C
            when "1101" => return "0100001"; -- D
            when "1110" => return "0000110"; -- E
            when "1111" => return "0001110"; -- F
            when others => return "1111111";  -- Default off
        end case;
    end hex_to_7seg;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            digit_select <= std_logic_vector(unsigned(digit_select) + 1);
        end if;
    end process;

    with digit_select select
        current_digit <= hex1 when "00",
                         hex2 when "01",
                         hex3 when "10",
                         hex4 when "11";

    seg <= hex_to_7seg(current_digit);
    an <= "1110" when digit_select = "00" else
          "1101" when digit_select = "01" else
          "1011" when digit_select = "10" else
          "0111" when digit_select = "11";

end Behavioral;
