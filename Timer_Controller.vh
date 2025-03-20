library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer_Controller is
    Port (
        clk1Hz       : in STD_LOGIC;  -- ✅ Clock de 1Hz para contar el tiempo
        clk100MHz    : in STD_LOGIC;  -- ✅ Clock principal (100MHz)
        clkDynamic   : in STD_LOGIC;  -- ✅ Clock dinámico (acelera con score)
        reset        : in STD_LOGIC;  -- ✅ Resetea el timer a 30
        state        : in STD_LOGIC_VECTOR(2 downto 0); -- ✅ Estado FSM
        timer_out    : out STD_LOGIC_VECTOR(4 downto 0) -- ✅ Timer (30 a 00)
    );
end Timer_Controller;

architecture Behavioral of Timer_Controller is
    signal timer : UNSIGNED(4 downto 0) := "11110"; -- ✅ 30 en binario

begin
    -- ✅ Process for Reset and State Changes
    process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            if reset = '1' then
                timer <= "11110"; -- ✅ Reset to 30
            end if;
        end if;
    end process;

    -- ✅ Process for HIGH_SCORE and CURRENT_SCORE (Decrements with clk1Hz)
    process(clk1Hz)
    begin
        if rising_edge(clk1Hz) then
            if (state = "011" or state = "101") and timer > 0 then
                timer <= timer - 1;
            end if;
        end if;
    end process;

    -- ✅ Process for PLAY MODE (Decrements with clkDynamic)
    process(clkDynamic)
    begin
        if rising_edge(clkDynamic) then
            if state = "010" and timer > 0 then
                timer <= timer - 1;
            end if;
        end if;
    end process;

    -- ✅ Assign output
    timer_out <= STD_LOGIC_VECTOR(timer);

end Behavioral;
