library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Seven_Segment_Driver is
end tb_Seven_Segment_Driver;

architecture testbench of tb_Seven_Segment_Driver is
    signal clk : STD_LOGIC := '0';
    signal timer_left   : STD_LOGIC_VECTOR(3 downto 0) := "0001"; -- 1
    signal timer_right  : STD_LOGIC_VECTOR(3 downto 0) := "0010"; -- 2
    signal random_hex   : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- A
    signal lives        : STD_LOGIC_VECTOR(1 downto 0) := "11";    -- 3 Lives
    signal seg         : STD_LOGIC_VECTOR(6 downto 0);
    signal an          : STD_LOGIC_VECTOR(3 downto 0);

    component Seven_Segment_Driver
        Port (
            clk   : in STD_LOGIC;
            timer_left, timer_right : in STD_LOGIC_VECTOR(3 downto 0);
            random_hex : in STD_LOGIC_VECTOR(3 downto 0);
            lives : in STD_LOGIC_VECTOR(1 downto 0);
            seg   : out STD_LOGIC_VECTOR(6 downto 0);
            an    : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin
    -- Instantiate the unit under test
    UUT: Seven_Segment_Driver port map (
        clk => clk, 
        timer_left => timer_left, 
        timer_right => timer_right, 
        random_hex => random_hex, 
        lives => lives, 
        seg => seg, 
        an => an
    );

    -- Clock process
    process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

end testbench;
