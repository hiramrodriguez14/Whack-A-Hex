library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Seven_Segment_Driver is
end tb_Seven_Segment_Driver;

architecture testbench of tb_Seven_Segment_Driver is
    -- Signals
    signal clk         : STD_LOGIC := '0';
    signal timer_bin   : STD_LOGIC_VECTOR(7 downto 0) := "00011001"; -- 25 in binary
    signal random_hex  : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- A
    signal lives       : STD_LOGIC_VECTOR(1 downto 0) := "11";    -- 3 Lives
    signal seg         : STD_LOGIC_VECTOR(6 downto 0);
    signal an          : STD_LOGIC_VECTOR(3 downto 0);

    -- Component under test
    component Seven_Segment_Driver
        Port (
            clk        : in STD_LOGIC;
            timer_bin  : in STD_LOGIC_VECTOR(7 downto 0);
            random_hex : in STD_LOGIC_VECTOR(3 downto 0);
            lives      : in STD_LOGIC_VECTOR(1 downto 0);
            seg        : out STD_LOGIC_VECTOR(6 downto 0);
            an         : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin
    -- Instantiate the unit under test
    UUT: Seven_Segment_Driver port map (
        clk        => clk, 
        timer_bin  => timer_bin, 
        random_hex => random_hex, 
        lives      => lives, 
        seg        => seg, 
        an         => an
    );

    -- Clock process
    process
    begin
        while now < 1000 ns loop
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
        -- **Test 1: Timer at 25**
        timer_bin <= "00011001"; -- 25
        wait for 50 ns;

        -- **Test 2: Timer at 50**
        timer_bin <= "00110010"; -- 50
        wait for 50 ns;

        -- **Test 3: Timer at 99**
        timer_bin <= "01100011"; -- 99
        wait for 50 ns;

        -- **Test 4: Lives at 2**
        lives <= "10"; -- 2 Lives
        wait for 50 ns;

        -- **Test 5: Random Hex at F**
        random_hex <= "1111"; -- F
        wait for 50 ns;

        wait;
    end process;
end testbench;
