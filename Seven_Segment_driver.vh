library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Seven_Segment_Driver is
    Port (
        clk   : in STD_LOGIC;
        timer_left, timer_right : in STD_LOGIC_VECTOR(3 downto 0);
        random_hex : in STD_LOGIC_VECTOR(3 downto 0);
        lives : in STD_LOGIC_VECTOR(1 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        an    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Seven_Segment_Driver;

architecture Behavioral of Seven_Segment_Driver is
    signal digit_select : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal current_digit : STD_LOGIC_VECTOR(3 downto 0);
    signal seg_out : STD_LOGIC_VECTOR(6 downto 0);

    -- Component declaration
    component Seven_Segment_Decoder
        Port (
            hex_in  : in STD_LOGIC_VECTOR(3 downto 0);
            seg_out : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Function to display lives as horizontal segments
    function lives_to_7seg(lives: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case lives is
            when "00" => return "1111111"; -- No lives (Display off)
            when "01" => return "1000001"; -- 1 life (Bottom segment on)
            when "10" => return "1001001"; -- 2 lives (Middle & Bottom segments on)
            when "11" => return "0001001"; -- 3 lives (Top, Middle & Bottom on)
            when others => return "1111111"; -- Default off
        end case;
    end lives_to_7seg;

begin
    -- Instantiate Decoder
    Decoder_Inst : Seven_Segment_Decoder port map (hex_in => current_digit, seg_out => seg_out);

    -- Clock process for digit multiplexing
    process(clk)
    begin
        if rising_edge(clk) then
            digit_select <= std_logic_vector(unsigned(digit_select) + 1);
        end if;
    end process;

    -- Select which value to display
    with digit_select select
        current_digit <= timer_left when "00",
                         timer_right when "01",
                         lives when "10",
                         random_hex when "11";

    -- Convert lives separately since it's a special format
    seg <= lives_to_7seg(lives) when digit_select = "10" else seg_out;

    -- Activate the corresponding digit
    an <= "1110" when digit_select = "00" else
          "1101" when digit_select = "01" else
          "1011" when digit_select = "10" else
          "0111" when digit_select = "11";

end Behavioral;
