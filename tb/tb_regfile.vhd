library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_regfile is
end tb_regfile;

architecture sim of tb_regfile is
    signal clk   : std_logic := '0';
    signal wr_en : std_logic := '0';
    signal A_add, B_add, WB_add : integer range 0 to 3 := 0;
    signal WB, A, B : std_logic_vector(7 downto 0) := (others => '0');
    signal done : boolean := false;
    constant T : time := 20 ns;
begin
    dut : entity work.regfile
        port map (clk => clk, wr_en => wr_en, A_add => A_add, B_add => B_add,
                  WB_add => WB_add, WB => WB, A => A, B => B);

    clk <= not clk after T / 2 when not done else '0';

    process
        variable errors : natural := 0;
        procedure check(name : string; got, exp : std_logic_vector) is
        begin
            if got /= exp then
                errors := errors + 1;
                report name & " wrong" severity error;
            end if;
        end procedure;
    begin
        wr_en <= '1';
        for i in 0 to 3 loop
            WB_add <= i;
            WB     <= std_logic_vector(to_unsigned(i, 8));
            wait for T;
        end loop;

        wr_en <= '0'; A_add <= 0; B_add <= 1;
        wait for T / 2;
        check("R0", A, "00000000");
        check("R1", B, "00000001");
        wait for T / 2;

        A_add <= 2; B_add <= 3;
        wait for T / 2;
        check("R2", A, "00000010");
        check("R3", B, "00000011");
        wait for T / 2;

        WB_add <= 3; WB <= "10101010";
        wait for T;
        check("R3 after disabled write", B, "00000011");

        if errors = 0 then
            report "REGISTER FILE PASSED: writes and reads are correct";
        else
            report "REGISTER FILE FAILED: " & integer'image(errors) & " errors" severity failure;
        end if;
        done <= true;
        wait;
    end process;
end sim;
