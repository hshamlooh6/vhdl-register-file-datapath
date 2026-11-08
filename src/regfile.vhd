library ieee;
use ieee.std_logic_1164.all;

entity regfile is
port (clk, wr_en : in std_logic;
      A_add, B_add, WB_add : in integer range 0 to 3;
      WB : in std_logic_vector(7 downto 0);
      A, B : out std_logic_vector(7 downto 0));
end regfile;

architecture behavioral of regfile is

type reg_array is array(3 downto 0) of std_logic_vector(7 downto 0);
signal myreg : reg_array := ("11111111", "00000000", "11110000", "00001111");

begin

process(clk)
begin
    if rising_edge(clk) then
        if wr_en = '1' then
            myreg(WB_add) <= WB;
        end if;
    end if;
end process;

process(A_add, B_add, myreg)
begin
    A <= myreg(A_add);
    B <= myreg(B_add);
end process;

end behavioral;
