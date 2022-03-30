library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity SoC_pingpong_v3 is
    port(
        clk, reset: in std_logic;
        PL1, PL2: in std_logic;
        led: out std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of SoC_pingpong_v3 is
    -- clock divider
    signal freq: std_logic_vector(25 downto 0);
    signal clk_div: std_logic;
	
	-- led signal
	signal SignalLED: std_logic_vector(7 downto 0);
	
	-- Mealy FSM State
	type GameState is (LeftMove, RightMove, initial, P1Win, P2Win, waitPL1, waitPL2);
	signal state: GameState;
	signal flag_ctrl: std_logic;
	
	-- control serve
	signal serve: std_logic;
	
	-- Count Score
	signal P1Score: std_logic_vector(3 downto 0);
	signal P2Score: std_logic_vector(3 downto 0);
	-- Count Score

begin
    clk_div <= freq(24);

    freq_div: process (clk, reset, freq)
    begin
		if reset = '1' then
			freq <= (others => '0');
		elsif clk 'event and clk = '1' then
            freq <= freq + '1';
		end if;
    end process;
	
	MealyFSM: process (clk, reset, state)
	begin
		if reset = '1' then
			state <= initial;
			serve <= '0';
			
		elsif clk 'event and clk = '1' then
			case state is
				when initial =>
					if serve = '0' then
						-- PL1 serve
						if PL1 = '1' then
							state <= RightMove;
						else
							state <= initial;
						end if;
						
					elsif serve = '1' then
						-- PL2 serve
						if PL2 = '1' then
							state <= LeftMove;
						else
							state <= initial;
						end if;
					end if;
				
				when RightMove =>
                    if SignalLED(0) = '1' then
                        state <= waitPL2;
                    elsif PL2 = '1' then
                        state <= P1Win;
                    end if;

				when LeftMove =>
                    if SignalLED(7) = '1' then
                        state <= waitPL1;
                    elsif PL1 = '1' then
                        state <= P2Win;
                    end if;
				
				when P1Win =>
					if PL1 = '1' then
						state <= initial;
					else
						state <= P1Win;
						serve <= '0';
					end if;
				
				when P2Win =>
					if PL2 = '1' then
						state <= initial;
					else
						state <= P2Win;
						serve <= '1';
					end if;
				
				when waitPL1 =>
				    if flag_ctrl = '1' then
				        if PL1 = '1' then
				            state <= RightMove;
				        else
				            state <= P2Win;
				        end if;
				    end if;
				    
				when waitPL2 => 
                    if flag_ctrl = '1' then
                        if PL2 = '1' then
                            state <= LeftMove;
                        else
                            state <= P1Win;
				        end if;
				    end if;

				when others => 
					serve <= '0';
					state <= initial;

			end case;
		end if;
	end process;
	
	BallState: process (clk_div, reset, state, SignalLED, flag_ctrl)
	begin
		if reset = '1' then
			SignalLED <= "10000000";
			flag_ctrl <= '0';
			
		elsif clk_div 'event and clk_div = '1' then
			case state is 
				when initial =>
					if serve = '0' then
						SignalLED <= "10000000";

					elsif serve = '1' then
						SignalLED <= "00000001";
					end if;
					flag_ctrl <= '0';
					
				when RightMove => 
                   if SignalLED = "11110000" then
                        SignalLED <= "10000000";
                    else
					   SignalLED <= '0' & SignalLED(7 downto 1);
                    end if;
                    flag_ctrl <= '0';

				when LeftMove =>
				   if SignalLED = "00001111" then
				       SignalLED <= "00000001";
				   else
                        SignalLED <= SignalLED(6 downto 0) & '0';
                    end if;
                    flag_ctrl <= '0';
                
                when waitPL1 =>
                    flag_ctrl <= '1';
                    
                when waitPL2 =>
                    flag_ctrl <= '1';    
                        
				when P1Win =>
                    SignalLED <= "11110000";
				
				when P2Win =>
                    SignalLED <= "00001111";
				
				when others => 
				    SignalLED <= "10000000";

			end case;
		end if;
		led <= SignalLED;
	end process;
	
end Behavioral;