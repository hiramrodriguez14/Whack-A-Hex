library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Whack_A_Hex is
    Port (
        clk_100MHz : in  STD_LOGIC;
        btn_left   : in  STD_LOGIC;
        btn_right  : in  STD_LOGIC;
        btn_center : in  STD_LOGIC;
        btn_up     : in  STD_LOGIC;
        btn_down   : in  STD_LOGIC;
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        an         : out STD_LOGIC_VECTOR(3 downto 0);
        led_out    : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Whack_A_Hex;

architecture Structural of Whack_A_Hex is
    signal reset, reset_dynamic : std_logic;
    
    signal clk_1Hz, clk_1kHz, clk_dynamic : STD_LOGIC;
    
    signal state : STD_LOGIC_VECTOR(2 downto 0);
    
    signal timer_bcd  : STD_LOGIC_VECTOR(7 downto 0);
    signal score_bcd  : STD_LOGIC_VECTOR(15 downto 0);
    signal high_score_bcd : STD_LOGIC_VECTOR(15 downto 0);
    signal timer_out  : STD_LOGIC_VECTOR(4 downto 0);
    signal current_score, high_score : STD_LOGIC_VECTOR(13 downto 0);
    
    signal btn_left_clean, btn_right_clean, btn_center_clean, btn_up_clean, btn_down_clean : STD_LOGIC;
    
    signal pos_out : STD_LOGIC_VECTOR(3 downto 0);
    signal rand_hex : STD_LOGIC_VECTOR(3 downto 0);
    signal lives : STD_LOGIC_VECTOR(1 downto 0);
    
    signal increment : STD_LOGIC; -- Nueva señal para incrementar el puntaje

begin
    -- Debounce buttons
    DebounceLeft : entity work.Debouncer port map (clk_100MHz, btn_left, btn_left_clean);
    DebounceRight : entity work.Debouncer port map (clk_100MHz, btn_right, btn_right_clean);
    DebounceCenter : entity work.Debouncer port map (clk_100MHz, btn_center, btn_center_clean);
    DebounceUp : entity work.Debouncer port map (clk_100MHz, btn_up, btn_up_clean);
    DebounceDown : entity work.Debouncer port map (clk_100MHz, btn_down, btn_down_clean);

    -- Finite State Machine Controller
    FSM : entity work.FSM_Controller port map (
        clk        => clk_100MHz,
        btn_up     => btn_up_clean,
        btn_down   => btn_down_clean,
        btn_left   => btn_left_clean,
        btn_right  => btn_right_clean,
        btn_center => btn_center_clean,
        timer_out  => timer_out,
        pos_out    => pos_out, 
        random_hex => rand_hex,
        lives      => lives,
        state_out  => state,
        reset_out  => reset,
        reset_dynamic => reset_dynamic,
        increment  => increment -- Se activa cuando el jugador acierta
    );

    -- LED Controller for Player Movement
    LEDControl : entity work.LED_Controller port map (
        clk        => clk_100MHz,
        btn_left   => btn_left_clean,
        btn_right  => btn_right_clean,
        pos_out    => pos_out,
        led_out    => led_out,
        state      => state
    );

    -- Clock dividers
    Clock1Hz : entity work.Clock_Divider_1Hz port map (clk_100MHz, reset, clk_1Hz);
    Clock1kHz : entity work.Clock_Divider_1kHz port map (clk_100MHz, reset, clk_1kHz);
    DynamicClk : entity work.Clock_Divider_Dynamic port map (clk_100MHz, reset_dynamic, current_score, state, clk_dynamic);

    -- Score Storage
    ScoreStore : entity work.Score_Storage port map (
        clk           => clk_100MHz,
        reset         => reset,
        state         => state,
        increment     => increment, -- Se usa para aumentar el puntaje
        current_score => current_score,
        high_score    => high_score
    );
    
    -- Timer Control
    TimerCtrl : entity work.Timer_Controller port map (clk_1Hz, clk_100MHz, clk_dynamic, reset, state, timer_out);
    
    -- Convert Binary to BCD
    BCD_Converter : entity work.Binary_to_BCD_Hybrid port map (current_score, timer_out, score_bcd, timer_bcd);

    -- Seven Segment Display Driver
    SegDriver : entity work.Seven_Segment_Driver port map (
        clk_1kHz => clk_1kHz,
        state => state,
        timer_bcd => timer_bcd,
        score_bcd => score_bcd,
        high_score_bcd => high_score_bcd,
        random_hex => rand_hex,
        lives => lives,
        seg => seg,
        an => an
    );

end Structural;
