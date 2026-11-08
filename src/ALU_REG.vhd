library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_REG is
Port ( A_ad : in integer range 0 to 3;
       B_ad : in integer range 0 to 3;
       WB_ad : in integer range 0 to 3;
       oper : in std_logic_vector (2 downto 0);
       Clk : in std_logic;
       wr_en : in std_logic;
       Rout : out std_logic_vector(7 downto 0));
end ALU_REG;

architecture Structural of ALU_REG is

component regfile
port (clk, wr_en : in std_logic;
      A_add, B_add, WB_add : in integer range 0 to 3;
      WB : in std_logic_vector(7 downto 0);
      A, B : out std_logic_vector(7 downto 0));
end component;

component alu_if
port (A, B : in std_logic_vector(7 downto 0);
      OP : in std_logic_vector(2 downto 0);
      R : out std_logic_vector(7 downto 0));
end component;

signal x, y : std_logic_vector(7 downto 0);
signal res : std_logic_vector(7 downto 0);

begin

U1 : regfile port map (clk => Clk, wr_en => wr_en, A_add => A_ad, B_add => B_ad,
                       WB_add => WB_ad, WB => res, A => x, B => y);

U2 : alu_if port map (A => x, B => y, OP => oper, R => res);

Rout <= res;

end Structural;
