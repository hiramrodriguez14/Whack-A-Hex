-- Whack-A-Hex: Seven-Segment Display Testbench

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Seven_Segment_Driver is
end tb_Seven_Segment_Driver;

architecture testbench of tb_Seven_Segment_Driver is
    signal clk    : STD_LOGIC := '0';
    signal hex1   : STD_LOGIC_VECTOR(3 downto 0) := "0001"; -- 1
    signal hex2   : STD_LOGIC_VECTOR(3 downto 0) := "0010"; -- 2
    signal hex3   : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- A
    signal hex4   : STD_LOGIC_VECTOR(3 downto 0) := "1111"; -- F
    signal seg    : STD_LOGIC_VECTOR(6 downto 0);
    signal an     : STD_LOGIC_VECTOR(3 downto 0);
    
    component Seven_Segment_Driver
        Port (
            clk   : in STD_LOGIC;
            hex1, hex2, hex3, hex4 : in STD_LOGIC_VECTOR(3 downto 0);
            seg   : out STD_LOGIC_VECTOR(6 downto 0);
            an    : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
begin
    -- Instantiate the unit under test
    UUT: Seven_Segment_Driver port map (clk => clk, hex1 => hex1, hex2 => hex2, hex3 => hex3, hex4 => hex4, seg => seg, an => an);
    
    -- Clock process
    process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
end testbench;
