library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Seven_Segment_Driver is
    Port (
        clk        : in STD_LOGIC;
        timer_bin  : in STD_LOGIC_VECTOR(7 downto 0); -- Timer in Binary
        random_hex : in STD_LOGIC_VECTOR(3 downto 0); -- Random Hexadecimal Number
        lives      : in STD_LOGIC_VECTOR(1 downto 0); -- Lives
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        an         : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Seven_Segment_Driver;

architecture Behavioral of Seven_Segment_Driver is
    -- **BCD Signals**
    signal timer_bcd_tens, timer_bcd_ones : STD_LOGIC_VECTOR(3 downto 0);
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

    -- **Integrate Binary to BCD Converter**
    component Binary_to_BCD
        Port (
            binary_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            bcd_tens   : out STD_LOGIC_VECTOR(3 downto 0);
            bcd_ones   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Function to display lives using horizontal segments
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
    -- **Instantiate Binary-to-BCD Converter**
    BCD_Converter: Binary_to_BCD port map (
        binary_in => timer_bin,
        bcd_tens  => timer_bcd_tens,
        bcd_ones  => timer_bcd_ones
    );

    -- Instantiate Decoder
    Decoder_Inst : Seven_Segment_Decoder port map (
        hex_in => current_digit, 
        seg_out => seg_out
    );

    -- **Clock Process for Multiplexing**
    process(clk)
    begin
        if rising_edge(clk) then
            digit_select <= std_logic_vector(unsigned(digit_select) + 1);
        end if;
    end process;

    -- **Select which value to display**
    with digit_select select
        current_digit <= timer_bcd_tens when "00",  -- Timer Tens place
                         timer_bcd_ones when "01",  -- Timer Ones place
                         lives when "10",          -- Lives (Special format)
                         random_hex when "11";     -- Random Hex number

    -- **Use custom function for lives**
    seg <= lives_to_7seg(lives) when digit_select = "10" else seg_out;

    -- **Activate corresponding digit**
    an <= "1110" when digit_select = "00" else  -- Left-most
          "1101" when digit_select = "01" else  -- Second digit
          "1011" when digit_select = "10" else  -- Third digit (Lives)
          "0111";                               -- Right-most (Random Hex)

end Behavioral;
