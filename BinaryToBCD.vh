library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Binary_to_BCD_Hybrid is
    Port (
        binary_in  : in  STD_LOGIC_VECTOR(13 downto 0); -- Soporta hasta 9999
        timer_in   : in  STD_LOGIC_VECTOR(4 downto 0);  -- ? Timer de 30 en binario (5 bits)
        score_bcd  : out STD_LOGIC_VECTOR(15 downto 0); -- ? Score en BCD concatenado
        timer_bcd  : out STD_LOGIC_VECTOR(7 downto 0)   -- ? Timer en BCD concatenado
    );
end Binary_to_BCD_Hybrid;

architecture Behavioral of Binary_to_BCD_Hybrid is
    --  LUT para valores de 0 a 31
    type LUT_ARRAY is array (0 to 31) of STD_LOGIC_VECTOR(7 downto 0);
    constant BCD_LUT : LUT_ARRAY := (
        "00000000", "00000001", "00000010", "00000011", -- 0-3
        "00000100", "00000101", "00000110", "00000111", -- 4-7
        "00001000", "00001001", "00010000", "00010001", -- 8-11
        "00010010", "00010011", "00010100", "00010101", -- 12-15
        "00010110", "00010111", "00011000", "00011001", -- 16-19
        "00100000", "00100001", "00100010", "00100011", -- 20-23
        "00100100", "00100101", "00100110", "00100111", -- 24-27
        "00101000", "00101001", "00110000", "00110001"  -- 28-31
    );

    signal temp_bin  : UNSIGNED(13 downto 0);
    signal temp_timer: UNSIGNED(4 downto 0);
    signal bcd_thousands, bcd_hundreds, bcd_tens, bcd_ones : STD_LOGIC_VECTOR(3 downto 0);
    signal timer_tens, timer_units : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(binary_in, timer_in)
        variable temp : UNSIGNED(13 downto 0);
        variable temp_time : UNSIGNED(4 downto 0);
        variable bcd : UNSIGNED(15 downto 0);
    begin
        --  Conversión del Score/High Score a BCD
        temp := UNSIGNED(binary_in);
        if to_integer(temp) <= 31 then
            --  Usar LUT para valores de 0 a 31
            bcd_thousands <= "0000";
            bcd_hundreds  <= "0000";
            bcd_tens      <= BCD_LUT(to_integer(temp))(7 downto 4);
            bcd_ones      <= BCD_LUT(to_integer(temp))(3 downto 0);
        else
            --  Aplicar Double Dabble para valores > 31
            bcd := (others => '0');
            for i in 0 to 13 loop
                if bcd(15 downto 12) > "0100" then
                    bcd(15 downto 12) := bcd(15 downto 12) + 3;
                end if;
                if bcd(11 downto 8) > "0100" then
                    bcd(11 downto 8) := bcd(11 downto 8) + 3;
                end if;
                if bcd(7 downto 4) > "0100" then
                    bcd(7 downto 4) := bcd(7 downto 4) + 3;
                end if;
                if bcd(3 downto 0) > "0100" then
                    bcd(3 downto 0) := bcd(3 downto 0) + 3;
                end if;
                bcd := bcd(14 downto 0) & temp(13);
                temp := temp(12 downto 0) & '0';
            end loop;
            -- Asignar valores BCD
            bcd_thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
            bcd_hundreds  <= STD_LOGIC_VECTOR(bcd(11 downto 8));
            bcd_tens      <= STD_LOGIC_VECTOR(bcd(7 downto 4));
            bcd_ones      <= STD_LOGIC_VECTOR(bcd(3 downto 0));
        end if;

        --  Conversión del Timer (0-30) a BCD
        temp_time := UNSIGNED(timer_in);
        if to_integer(temp_time) <= 31 then
            timer_tens  <= BCD_LUT(to_integer(temp_time))(7 downto 4);
            timer_units <= BCD_LUT(to_integer(temp_time))(3 downto 0);
        else
            --  Aplicar Double Dabble para valores > 31 (Aunque nunca pasa en este caso)
            bcd := (others => '0');
            for i in 0 to 4 loop
                if bcd(7 downto 4) > "0100" then
                    bcd(7 downto 4) := bcd(7 downto 4) + 3;
                end if;
                if bcd(3 downto 0) > "0100" then
                    bcd(3 downto 0) := bcd(3 downto 0) + 3;
                end if;
                bcd := bcd(14 downto 0) & temp_time(4);
                temp_time := temp_time(3 downto 0) & '0';
            end loop;
            -- Asignar valores BCD
            timer_tens  <= STD_LOGIC_VECTOR(bcd(7 downto 4));
            timer_units <= STD_LOGIC_VECTOR(bcd(3 downto 0));
        end if;

        --  Concatenación final antes de exportar
        score_bcd <= bcd_thousands & bcd_hundreds & bcd_tens & bcd_ones;
        timer_bcd <= timer_tens & timer_units;
    end process;
end Behavioral;
