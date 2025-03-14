library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Score_Storage is
    Port (
        clk         : in STD_LOGIC;  -- Reloj
        reset       : in STD_LOGIC;  -- Reinicia el puntaje
        game_over   : in STD_LOGIC;  -- Fin del juego (actualiza high score)
        increment   : in STD_LOGIC;  -- Aumenta el puntaje
        current_score : out STD_LOGIC_VECTOR(13 downto 0); -- Puntaje actual (máx. 9999)
        high_score : out STD_LOGIC_VECTOR(13 downto 0) -- Puntaje más alto (máx. 9999)
    );
end Score_Storage;

architecture Behavioral of Score_Storage is
    signal score : UNSIGNED(13 downto 0) := (others => '0'); -- Puntaje actual
    signal max_score : UNSIGNED(13 downto 0) := (others => '0'); -- Puntaje máximo

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reinicia el puntaje
                score <= (others => '0');
            elsif increment = '1' then
                if score < 9999 then  -- Evita que el puntaje suba de 9999
                    score <= score + 1;
                end if;
            end if;

            -- Actualizar el high score cuando termina el juego
            if game_over = '1' then
                if score > max_score then
                    max_score <= score;
                end if;
            end if;
        end if;
    end process;

    -- Asignar valores a las salidas
    current_score <= STD_LOGIC_VECTOR(score);
    high_score <= STD_LOGIC_VECTOR(max_score);
end Behavioral;
