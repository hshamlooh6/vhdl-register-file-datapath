library ieee;
use ieee.std_logic_1164.all;

entity tb_alu_reg is
end tb_alu_reg;

architecture sim of tb_alu_reg is
    signal Clk   : std_logic := '0';
    signal wr_en : std_logic := '0';
    signal A_ad, B_ad, WB_ad : integer range 0 to 3 := 0;
    signal oper  : std_logic_vector(2 downto 0) := "000";
    signal Rout  : std_logic_vector(7 downto 0);
    signal done  : boolean := false;
    constant T : time := 20 ns;

    type int_list  is array (1 to 4) of integer range 0 to 3;
    type op_list   is array (1 to 4) of std_logic_vector(2 downto 0);
    type byte_list is array (natural range <>) of std_logic_vector(7 downto 0);
    constant A_seq  : int_list  := (0, 2, 0, 2);
    constant B_seq  : int_list  := (1, 3, 1, 3);
    constant WB_seq : int_list  := (2, 3, 1, 0);
    constant OP_seq : op_list   := ("000", "001", "010", "011");
    constant written : byte_list(1 to 4) := ("00000000", "00000001", "11111111", "00000000");
    constant final   : byte_list(0 to 3) := ("00000000", "11111111", "00000000", "00000001");
begin
    dut : entity work.ALU_REG
        port map (A_ad => A_ad, B_ad => B_ad, WB_ad => WB_ad, oper => oper,
                  Clk => Clk, wr_en => wr_en, Rout => Rout);

    Clk <= not Clk after T / 2 when not done else '0';

    process
        variable errors : natural := 0;
    begin
        wr_en <= '1';
        for i in 1 to 4 loop
            A_ad <= A_seq(i); B_ad <= B_seq(i); WB_ad <= WB_seq(i); oper <= OP_seq(i);
            wait for T / 2 - 1 ns;
            if Rout /= written(i) then
                errors := errors + 1;
                report "cycle " & integer'image(i) & ": wrong value written" severity error;
            end if;
            wait for T / 2 + 1 ns;
        end loop;

        wr_en <= '0'; oper <= "100";
        for k in 0 to 3 loop
            A_ad <= k; B_ad <= k;
            wait for T;
            if Rout /= final(k) then
                errors := errors + 1;
                report "final R" & integer'image(k) & " wrong" severity error;
            end if;
        end loop;

        if errors = 0 then
            report "ALU_REG PASSED: all 4 operations stored the right results";
        else
            report "ALU_REG FAILED: " & integer'image(errors) & " errors" severity failure;
        end if;
        done <= true;
        wait;
    end process;
end sim;
