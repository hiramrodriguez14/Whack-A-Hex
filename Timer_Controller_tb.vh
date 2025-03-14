library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Timer_Controller is
end tb_Timer_Controller;

architecture testbench of tb_Timer_Controller is
    signal clk           : STD_LOGIC := '0';
    signal reset         : STD_LOGIC := '0';
    signal paused        : STD_LOGIC := '0';
    signal current_score : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; -- Start at score 0
    signal timer_out     : STD_LOGIC_VECTOR(7 downto 0);

    component Timer_Controller
        Port (
            clk           : in STD_LOGIC;
            reset         : in STD_LOGIC;
            paused        : in STD_LOGIC;
            current_score : in STD_LOGIC_VECTOR(7 downto 0);
            timer_out     : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
begin
    -- Instantiate Timer Controller
    UUT: Timer_Controller port map (
        clk => clk,
        reset => reset,
        paused => paused,
        current_score => current_score,
        timer_out => timer_out
    );

    -- Clock process
    process
    begin
        while now < 500 ms loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Test process
    process
    begin
        -- Reset timer
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- Let timer run normally for 5 seconds
        wait for 5 sec;

        -- Increase score gradually
        current_score <= "00000101"; -- Score = 5
        wait for 5 sec;
        current_score <= "00001010"; -- Score = 10
        wait for 5 sec;
        current_score <= "00001111"; -- Score = 15
        wait for 5 sec;
        current_score <= "00010010"; -- Score = 18
        wait for 5 sec;
        current_score <= "00100000"; -- Score = 32 (Max Speed)

        -- Pause for 3 seconds
        paused <= '1';
        wait for 3 sec;
        paused <= '0';

        -- Let timer reach 0
        wait for 20 sec;

        wait;
    end process;
end testbench;
