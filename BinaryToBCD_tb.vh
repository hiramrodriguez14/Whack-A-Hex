library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Binary_to_BCD is
end tb_Binary_to_BCD;

architecture testbench of tb_Binary_to_BCD is
    -- Signals for testing
    signal binary_in  : STD_LOGIC_VECTOR(7 downto 0);
    signal bcd_tens   : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_ones   : STD_LOGIC_VECTOR(3 downto 0);

    -- Component under test
    component Binary_to_BCD
        Port (
            binary_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            bcd_tens   : out STD_LOGIC_VECTOR(3 downto 0);
            bcd_ones   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin
    -- Instantiate the Binary-to-BCD converter
    UUT: Binary_to_BCD port map (
        binary_in  => binary_in,
        bcd_tens   => bcd_tens,
        bcd_ones   => bcd_ones
    );

    -- Test process
    process
    begin
        -- **Test 0**
        binary_in <= "00000000"; -- 0
        wait for 20 ns;

        -- **Test 9**
        binary_in <= "00001001"; -- 9
        wait for 20 ns;

        -- **Test 10**
        binary_in <= "00001010"; -- 10 (BCD should be 0001 0000)
        wait for 20 ns;

        -- **Test 25**
        binary_in <= "00011001"; -- 25 (BCD should be 0010 0101)
        wait for 20 ns;

        -- **Test 99**
        binary_in <= "01100011"; -- 99 (BCD should be 1001 1001)
        wait for 20 ns;

        wait;
    end process;
end testbench;
