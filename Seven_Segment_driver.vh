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
    signal seg_out : STD_LOGIC_VECTOR(6 downto 0);

    -- Component declaration
    component Seven_Segment_Decoder
        Port (
            hex_in  : in STD_LOGIC_VECTOR(3 downto 0);
            seg_out : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

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

    -- Select which digit to display
    with digit_select select
        current_digit <= hex1 when "00",
                         hex2 when "01",
                         hex3 when "10",
                         hex4 when "11";

    -- Assign decoder output to seg
    seg <= seg_out;

    -- Activate the corresponding digit
    an <= "1110" when digit_select = "00" else
          "1101" when digit_select = "01" else
          "1011" when digit_select = "10" else
          "0111" when digit_select = "11";

end Behavioral;
