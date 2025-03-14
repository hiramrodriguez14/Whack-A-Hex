library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Debouncer is
end tb_Debouncer;

architecture testbench of tb_Debouncer is
    signal clk    : STD_LOGIC := '0';
    signal btn_in  : STD_LOGIC := '0';
    signal btn_out : STD_LOGIC;

    component Debouncer
        Port (
            clk     : in STD_LOGIC;
            btn_in  : in STD_LOGIC;
            btn_out : out STD_LOGIC
        );
    end component;
begin
    -- Instantiate Debouncer
    UUT: Debouncer port map (
        clk => clk,
        btn_in => btn_in,
        btn_out => btn_out
    );

    -- Clock process
    process
    begin
        while now < 500 ms loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Test process (Simulating button bouncing)
    process
    begin
        -- No button press
        btn_in <= '0';
        wait for 100 ns;

        -- Simulating a bouncing press
        btn_in <= '1'; wait for 10 ns;
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 10 ns;
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 100 ns; -- Finally stabilizes high

        -- Holding the button press
        wait for 200 ns;

        -- Simulating a bouncing release
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 10 ns;
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 10 ns;
        btn_in <= '0'; wait for 100 ns; -- Finally stabilizes low

        wait;
    end process;
end testbench;
