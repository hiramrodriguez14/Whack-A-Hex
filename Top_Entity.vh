-- Whack-A-Hex: Top-Level Entity
-- This module integrates all submodules for the Whack-A-Hex game on BASYS-3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Whack_A_Hex is
    Port (
        clk         : in STD_LOGIC;
        reset       : in STD_LOGIC;
        btn_left    : in STD_LOGIC;
        btn_right   : in STD_LOGIC;
        btn_enter   : in STD_LOGIC;
        btn_up      : in STD_LOGIC;
        btn_down    : in STD_LOGIC;
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        an          : out STD_LOGIC_VECTOR(3 downto 0);
        led         : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Whack_A_Hex;

architecture Behavioral of Whack_A_Hex is
    -- Internal signals
    signal game_state : STD_LOGIC_VECTOR(2 downto 0);
    signal player_pos : STD_LOGIC_VECTOR(3 downto 0);
    signal lives      : STD_LOGIC_VECTOR(1 downto 0);
    signal timer      : STD_LOGIC_VECTOR(3 downto 0);
    signal random_hex : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Component declarations
    component FSM_Controller is
        Port (
            clk, reset, btn_enter, btn_up, btn_down : in STD_LOGIC;
            state_out : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;
    
    component Seven_Segment_Driver is
        Port (
            clk : in STD_LOGIC;
            hex1, hex2, hex3, hex4 : in STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0);
            an : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component LED_Controller is
        Port (
            clk : in STD_LOGIC;
            btn_left, btn_right : in STD_LOGIC;
            pos_out : out STD_LOGIC_VECTOR(3 downto 0);
            led_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    component Random_Hex_Generator is
        Port (
            clk : in STD_LOGIC;
            rand_hex : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component Timer_Controller is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            time_out : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    -- Component Instantiation
begin
    FSM_Inst : FSM_Controller port map(clk, reset, btn_enter, btn_up, btn_down, game_state);
    LED_Inst : LED_Controller port map(clk, btn_left, btn_right, player_pos, led);
    RNG_Inst : Random_Hex_Generator port map(clk, random_hex);
    Timer_Inst : Timer_Controller port map(clk, reset, timer);
    Seg_Display : Seven_Segment_Driver port map(clk, timer, random_hex, lives, "0000", seg, an);
end Behavioral;
