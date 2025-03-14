library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Port (
        clk     : in STD_LOGIC;  -- Clock signal
        btn_in  : in STD_LOGIC;  -- Noisy button input
        btn_out : out STD_LOGIC  -- Debounced output
    );
end Debouncer;

architecture Behavioral of Debouncer is
    signal shift_reg : STD_LOGIC_VECTOR(19 downto 0) := (others => '0'); -- Shift register for debouncing
    signal btn_out_reg : STD_LOGIC := '0'; -- Ensure initialization
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Shift in new button value
            shift_reg <= shift_reg(18 downto 0) & btn_in;
            
            -- Button is stable if all bits are the same
            if shift_reg = "11111111111111111111" then
                btn_out_reg <= '1';
            elsif shift_reg = "00000000000000000000" then
                btn_out_reg <= '0';
            end if;
        end if;
    end process;
    
    btn_out <= btn_out_reg; -- Assign registered output
end Behavioral;
