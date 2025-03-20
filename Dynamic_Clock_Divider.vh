library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clock_Divider_Dynamic is
    Port (
        clk_100MHz : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        score      : in  STD_LOGIC_VECTOR(13 downto 0);
        state      : in  STD_LOGIC_VECTOR(2 downto 0);
        clk_out    : out STD_LOGIC
    );
end Clock_Divider_Dynamic;

architecture Behavioral of Clock_Divider_Dynamic is
    signal counter : UNSIGNED(26 downto 0) := (others => '0');
    signal clk_sig : STD_LOGIC := '0';
    signal divider_value : UNSIGNED(26 downto 0) := to_unsigned(50_000_000, 27);

begin
    process(clk_100MHz)
        variable score_int : INTEGER;
    begin
        if rising_edge(clk_100MHz) then
            if reset = '1' then
                counter <= (others => '0');
                clk_sig <= '0';
                divider_value <= to_unsigned(50_000_000, 27);
            elsif state = "010" then
                -- 🔄 Ajuste dinámico basado en el score dentro del proceso secuencial
                score_int := to_integer(unsigned(score));
                if score_int < 5 then
                    divider_value <= to_unsigned(50_000_000, 27);
                else
                    divider_value <= to_unsigned(50_000_000 / (1 + (score_int / 5)), 27);
                end if;
                
                -- ✅ Generación del pulso de 1Hz dinámico
                if counter = divider_value then
                    counter <= (others => '0');
                    clk_sig <= not clk_sig;
                else
                    counter <= counter + to_unsigned(1, 26); 
                end if;
            end if;
        end if;
    end process;

    clk_out <= clk_sig;
    
end Behavioral;
