library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC_STD.all;
--use IEEE.MATH_REAL.all;
--use work.???_pkg.all;

entity PWM2SBUS is
  generic(
    CNT_WDT     : integer := 11; -- Counter width
    N_CH        : integer := 14 -- Number of input channels
  );

  port(
    rst_rhi     : in    std_logic; -- low active asynchronous reset
    clk_ci      : in    std_logic; -- rising edge active clock
    ch_di       : in    std_logic_vector(N_CH - 1 downto 0); -- input channels
    sbus_do     : out   std_logic -- SBUS output
  );
end PWM2SBUS;

architecture rtl of PWM2SBUS is

  component PWM_CNT is
    generic(
      CNT_WDT     : integer := 11 -- Counter width
    );
    port(
      rst_rhi     : in    std_logic; -- low active asynchronous reset
      clk_ci      : in    std_logic; -- rising edge active clock
      pwm_di      : in    std_logic -- PWM input
    );
  end component PWM_CNT;

  signal rst      : std_logic;
  signal clk      : std_logic;
  signal channel  : std_logic_vector(N_CH - 1 downto 0);
  signal sbus     : std_logic;

begin

  gen_pwm_cnt : for ch in 0 to N_CH - 1 generate
    i_pwm_cnt : PWM_CNT
      port map(
        rst_rhi     => rst,
        clk_ci      => clk,
        pwm_di      => channel(ch)
      );
  end generate gen_pwm_cnt;

end rtl;
