library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use IEEE.MATH_REAL.all;
--use work.????_pkg.all;

entity PWM_CNT is
  generic(
    CNT_WDT     : integer := 11 -- Counter width
  );
  port(
    rst_rhi     : in    std_logic; -- low active asynchronous reset
    clk_ci      : in    std_logic; -- rising edge active clock
    pwm_di      : in    std_logic -- PWM input
  );
end PWM_CNT;

architecture rtl of PWM_CNT is

  --signal pwm_r        : std_logic; -- synchronized PWM signal
  signal sync_pwm_reg   : std_logic_vector(2 downto 0); -- registers for metastability filter
  signal cnt            : unsigned(CNT_WDT-1 downto 0); -- counter
  signal cnt_reg        : std_logic_vector(CNT_WDT-1 downto 0); -- counter buffer

begin

  p_cnt : process(clk_ci, rst_rhi)
  begin
    if rst_rhi = '1' then
      cnt <= (others => '0');
    elsif rising_edge(clk_ci) then
      if (sync_pwm_reg(1) = '1' and sync_pwm_reg(2) = '1') then
        cnt <= cnt+1;
      elsif (sync_pwm_reg(1) = '1' and sync_pwm_reg(2) = '0') then
        cnt <= (others => '0');
      else
        cnt <= cnt;
      end if;
    end if;
  end process p_cnt;

  --pwm_r <= sync_pwm_reg(1);
  p_pwm_sync : process(clk_ci, rst_rhi)
  begin
    if rst_rhi = '1' then
      sync_pwm_reg <= (others => '0');
    elsif rising_edge(clk_ci) then
      sync_pwm_reg(0) <= pwm_di;
      sync_pwm_reg(1) <= sync_pwm_reg(0);
      sync_pwm_reg(2) <= sync_pwm_reg(1);
    end if;
  end process p_pwm_sync;

end rtl;
