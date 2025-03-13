-- Testbench for LED Controller
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_LED_Controller is
end tb_LED_Controller;

architecture testbench of tb_LED_Controller is
    signal clk       : STD_LOGIC := '0';
    signal btn_left  : STD_LOGIC := '0';
    signal btn_right : STD_LOGIC := '0';
    signal pos_out   : STD_LOGIC_VECTOR(3 downto 0);
    signal led_out   : STD_LOGIC_VECTOR(15 downto 0);
    
    component LED_Controller
        Port (
            clk       : in STD_LOGIC;
            btn_left  : in STD_LOGIC;
            btn_right : in STD_LOGIC;
            pos_out   : out STD_LOGIC_VECTOR(3 downto 0);
            led_out   : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
begin
    -- Instantiate the unit under test
    UUT: LED_Controller port map (clk => clk, btn_left => btn_left, btn_right => btn_right, pos_out => pos_out, led_out => led_out);
    
    -- Clock process
    process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    
    -- Test process
    process
    begin
        wait for 10 ns;
        btn_right <= '1';
        wait for 10 ns;
        btn_right <= '0';
        wait for 10 ns;
        btn_left <= '1';
        wait for 10 ns;
        btn_left <= '0';
        wait;
    end process;
end testbench;
