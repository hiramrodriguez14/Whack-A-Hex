library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer_Controller is
    Port (
        clk100MHz    : in STD_LOGIC;  -- 🏁 Reloj principal (100MHz)
        clk1Hz       : in STD_LOGIC;  -- ⏳ Clock de 1Hz (para estados 011 y 101)
        clkDynamic   : in STD_LOGIC;  -- ⚡ Clock dinámico (para estado 010)
        reset        : in STD_LOGIC;  -- 🔄 Reset general
        state        : in STD_LOGIC_VECTOR(2 downto 0); -- 🎮 Estado del juego
        timer_out    : out STD_LOGIC_VECTOR(4 downto 0) -- 🕒 Timer (30 a 00)
    );
end Timer_Controller;

architecture Behavioral of Timer_Controller is
    signal timer : UNSIGNED(4 downto 0) := "11110"; -- ✅ 30 en binario
begin

    -- ✅ ÚNICO proceso que maneja el timer
    process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            if reset = '1' then
                timer <= "11110"; -- 🔄 Reset a 30

            elsif state = "011" or state = "101" then
                -- ⏳ Decrementar con clk1Hz en HIGH_SCORE o CURRENT_SCORE
                if rising_edge(clk1Hz) and timer > 0 then
                    timer <= timer - 1;
                end if;

            elsif state = "010" then
                -- ⚡ Decrementar con clkDynamic en PLAY MODE
                if rising_edge(clkDynamic) and timer > 0 then
                    timer <= timer - 1;
                end if;
            end if;
        end if;
    end process;

    -- 🕒 Salida del timer
    timer_out <= STD_LOGIC_VECTOR(timer);

end Behavioral;
