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
    signal bcd: UNSIGNED(7 downto 0);
begin
    process(binary_in)
        variable temp: UNSIGNED(7 downto 0);
    begin
        temp := UNSIGNED(binary_in);

        -- **Double Dabble Algorithm**
        for i in 0 to 7 loop
            if temp(7 downto 4) > "0100" then
                temp(7 downto 4) := temp(7 downto 4) + 3;
            end if;
            temp := temp(6 downto 0) & '0'; -- Shift left
        end loop;

        -- Assign output
        bcd_tens <= STD_LOGIC_VECTOR(temp(7 downto 4)); -- Tens
        bcd_ones <= STD_LOGIC_VECTOR(temp(3 downto 0)); -- Ones
    end process;
end Behavioral;
