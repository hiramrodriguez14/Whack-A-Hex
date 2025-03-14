library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Binary_to_BCD is
    Port (
        binary_in  : in  STD_LOGIC_VECTOR(7 downto 0); -- Binary input (0-99)
        bcd_tens   : out STD_LOGIC_VECTOR(3 downto 0); -- BCD Tens place
        bcd_ones   : out STD_LOGIC_VECTOR(3 downto 0)  -- BCD Ones place
    );
end Binary_to_BCD;

architecture Behavioral of Binary_to_BCD is
begin
    process(binary_in)
        variable temp: UNSIGNED(7 downto 0);
        variable bcd_var: UNSIGNED(7 downto 0); -- Store intermediate BCD values
    begin
        temp := UNSIGNED(binary_in);
        bcd_var := (others => '0');

        -- **Modified Double Dabble Algorithm**
        for i in 0 to 7 loop
            -- Check and adjust tens place
            if bcd_var(7 downto 4) > "0100" then
                bcd_var(7 downto 4) := bcd_var(7 downto 4) + 3;
            end if;

            -- Check and adjust ones place
            if bcd_var(3 downto 0) > "0100" then
                bcd_var(3 downto 0) := bcd_var(3 downto 0) + 3;
            end if;

            -- Shift left, bringing in new bit from temp
            bcd_var := bcd_var(6 downto 0) & temp(7);
            temp := temp(6 downto 0) & '0';
        end loop;

        -- Assign output
        bcd_tens <= STD_LOGIC_VECTOR(bcd_var(7 downto 4)); -- Tens
        bcd_ones <= STD_LOGIC_VECTOR(bcd_var(3 downto 0)); -- Ones
    end process;
end Behavioral;
