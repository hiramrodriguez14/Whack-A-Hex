library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Timer_Controller is
end tb_Timer_Controller;

architecture testbench of tb_Timer_Controller is
    -- Test signals
    signal clk           : STD_LOGIC := '0';
    signal reset         : STD_LOGIC := '0';
    signal paused        : STD_LOGIC := '0';
    signal current_score : STD_LOGIC_VECTOR(13 downto 0) := "00000000000000"; -- Score = 0
    signal timer_out     : STD_LOGIC_VECTOR(7 downto 0);

    -- Component declaration
    component Timer_Controller
        Port (
            clk           : in STD_LOGIC;
            reset         : in STD_LOGIC;
            paused        : in STD_LOGIC;
            current_score : in STD_LOGIC_VECTOR(13 downto 0);
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

    -- Clock process (50 MHz -> 20 ns period)
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
        -- **1️⃣ Reset Timer and Check Initialization**
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- **2️⃣ Let Timer Run for a Few Seconds**
        wait for 2 sec;  -- Timer should decrement normally

        -- **3️⃣ Pause Timer and Ensure It Stops Counting**
        paused <= '1';
        wait for 2 sec;  -- Timer should NOT decrement
        paused <= '0';

        -- **4️⃣ Test Speed Increase Based on Score**
        current_score <= "00000000000101"; -- Score = 5
        wait for 2 sec;  -- Timer should decrement slightly faster

        current_score <= "00000000001000"; -- Score = 10
        wait for 2 sec;  -- Timer should decrement even faster

        current_score <= "00000000010000"; -- Score = 16
        wait for 2 sec;  -- Timer should be even faster

        -- **5️⃣ Reset Timer and Verify it Goes Back to 99**
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        wait for 2 sec;

        wait;
    end process;
end testbench;
