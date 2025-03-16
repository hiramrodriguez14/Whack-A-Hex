library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Seven_Segment_Driver is
    Port (
        clk_1kHz   : in STD_LOGIC;  -- ✅ Multiplexing clock (1kHz)
        state      : in STD_LOGIC_VECTOR(2 downto 0);  -- ✅ Game state
        timer_bcd  : in STD_LOGIC_VECTOR(7 downto 0);  -- ✅ Timer in BCD (2 digits)
        score_bcd  : in STD_LOGIC_VECTOR(15 downto 0); -- ✅ Score in BCD (4 digits)
        high_score_bcd : in STD_LOGIC_VECTOR(15 downto 0); -- ✅ High Score in BCD (4 digits)
        random_hex : in STD_LOGIC_VECTOR(3 downto 0);  -- ✅ Random Hexadecimal Number
        lives      : in STD_LOGIC_VECTOR(1 downto 0);  -- ✅ Player's remaining lives
        seg        : out STD_LOGIC_VECTOR(6 downto 0); -- ✅ 7-segment display segments
        an         : out STD_LOGIC_VECTOR(3 downto 0)  -- ✅ Active anode selection
    );
end Seven_Segment_Driver;

architecture Behavioral of Seven_Segment_Driver is
    signal digit_select : STD_LOGIC_VECTOR(1 downto 0) := "00";  -- Cycles between 4 displays
    signal current_digit : STD_LOGIC_VECTOR(3 downto 0);
    signal seg_out : STD_LOGIC_VECTOR(6 downto 0);

    -- Component declaration for 7-segment decoder
    component Seven_Segment_Decoder
        Port (
            hex_in  : in STD_LOGIC_VECTOR(3 downto 0);
            seg_out : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Function to convert lives to 7-segment format
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
    -- Instantiate 7-segment decoder
    Decoder_Inst : Seven_Segment_Decoder port map (
        hex_in  => current_digit,
        seg_out => seg_out
    );

    -- Multiplexing process for display cycling (1kHz)
    process(clk_1kHz)
    begin
        if rising_edge(clk_1kHz) then
            digit_select <= std_logic_vector(unsigned(digit_select) + 1); -- Cycle through 4 displays
        end if;
    end process;

    -- **Handling Different Game States**
    process(state, digit_select, timer_bcd, score_bcd, high_score_bcd, random_hex, lives)
    begin
        case state is
            when "010" => -- ✅ PLAY Mode: Timer, Lives, Random Hex
                case digit_select is
                    when "00" => current_digit <= timer_bcd(7 downto 4); -- Timer Tens
                    when "01" => current_digit <= timer_bcd(3 downto 0); -- Timer Ones
                    when "10" => current_digit <= lives; -- Display Lives
                    when "11" => current_digit <= random_hex; -- Random Hexadecimal
                    when others => current_digit <= "0000";
                end case;

            when "011" => -- ✅ HIGH_SCORE Mode: Show High Score
                case digit_select is
                    when "00" => current_digit <= high_score_bcd(15 downto 12); -- Thousands
                    when "01" => current_digit <= high_score_bcd(11 downto 8); -- Hundreds
                    when "10" => current_digit <= high_score_bcd(7 downto 4); -- Tens
                    when "11" => current_digit <= high_score_bcd(3 downto 0); -- Ones
                    when others => current_digit <= "0000";
                end case;

            when "101" => -- ✅ CURRENT_SCORE Mode: Show Current Score
                case digit_select is
                    when "00" => current_digit <= score_bcd(15 downto 12); -- Thousands
                    when "01" => current_digit <= score_bcd(11 downto 8); -- Hundreds
                    when "10" => current_digit <= score_bcd(7 downto 4); -- Tens
                    when "11" => current_digit <= score_bcd(3 downto 0); -- Ones
                    when others => current_digit <= "0000";
                end case;

            when others => -- IDLE, PAUSE (Blank display)
                current_digit <= "0000";
        end case;
    end process;

    -- Convert lives separately when in PLAY mode
    seg <= lives_to_7seg(lives) when state = "010" and digit_select = "10" else seg_out;

    -- Activate the corresponding display
    an <= "1110" when digit_select = "00" else  -- Left-most digit
          "1101" when digit_select = "01" else  -- Second digit
          "1011" when digit_select = "10" else  -- Third digit
          "0111";  -- Right-most digit

end Behavioral;
