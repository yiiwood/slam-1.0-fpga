--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    15:40:07 03/27/10
-- Design Name:    
-- Module Name:    map_update - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity map_update is

	port (clk: in std_logic;
			mu: in std_logic;
			original_value_x: in std_logic_vector(9 downto 0);
			original_value_y: in std_logic_vector(9 downto 0);
			original_value_scan: in std_logic_vector(9 downto 0);
			robot_pose_x: in std_logic_vector(11 downto 0);
			robot_pose_y: in std_logic_vector(11 downto 0);
			robot_pose_theta: in std_logic_vector(15 downto 0);
			map_value_rd: in std_logic_vector(7 downto 0);
						
			original_address: out std_logic_vector(8 downto 0);
			map_value_wr: out std_logic_vector(7 downto 0);
			map_address_rd: out std_logic_vector(17 downto 0);
			map_address_wr: out std_logic_vector(17 downto 0);
			map_we: out std_logic;
			finished: out std_logic;	
			
			value_t: out std_logic_vector(12 downto 0);
			cos_out_t: out std_logic_vector(11 downto 0);
			sin_out_t: out std_logic_vector(11 downto 0);
			measid_t: out std_logic_vector(8 downto 0);
			measid_2_t: out std_logic_vector(8 downto 0);
			R_t: out std_logic_vector(6 downto 0);--unsigned(6 downto 0) :=0;
			cos_t: out std_logic_vector(11 downto 0);
			sin_t: out std_logic_vector(11 downto 0);
			cos_sum_t: out std_logic_vector(21 downto 0);
			sin_sum_t: out std_logic_vector(21 downto 0);
			cos_sum_special_t: out std_logic_vector(21 downto 0);
			sin_sum_special_t: out std_logic_vector(21 downto 0);
			xpoint_t, ypoint_t: out std_logic_vector(11 downto 0);
			tt_t: out std_logic_vector(7 downto 0)	;		
			temp_t: out std_logic_vector(23 downto 0)	
			);


end map_update;

architecture Behavioral of map_update is

signal mu_l: std_logic;
signal measid: std_logic_vector(8 downto 0):="111111110";
signal measid_2: std_logic_vector(8 downto 0):="000000000";
signal value: std_logic_vector(12 downto 0);
signal cos_out, sin_out: std_logic_vector(11 downto 0);
signal rdy: std_logic;

signal rd_int: std_logic_vector(7 downto 0);
signal div: std_logic_vector(7 downto 0);
signal div2: std_logic_vector(7 downto 0);

component trig4
		port (
			phase_in: IN std_logic_VECTOR(12 downto 0);
			x_out: OUT std_logic_VECTOR(11 downto 0);
			y_out: OUT std_logic_VECTOR(11 downto 0);
			rdy: OUT std_logic;
			clk: IN std_logic);
end component;



begin

U1: trig4
		port map(value,cos_out,sin_out,rdy,clk);

value_t<=value;
cos_out_t<=cos_out;
sin_out_t<=sin_out;
measid_t<=measid;
measid_2_t<=measid_2;


		
PROCESS (clk)
		variable counter_basic:	unsigned(6 downto 0) := "0111111";	--53
		variable counter_basic_2:	unsigned(6 downto 0) := "0000000";

		BEGIN
		IF (clk'event and clk='1' )  THEN
			if (mu='1') then
				counter_basic:=counter_basic+1;
				counter_basic_2:=counter_basic_2+1;
				if (counter_basic=80) then
					measid<=measid+"000000010";
					counter_basic:="0000000";
				end if;
				if (counter_basic_2=80) then
					measid_2<=measid_2+"000000010";
					counter_basic_2:="0000000";
				end if;
				mu_l<='1';
				--value<=("0000" & robot_pose_theta)+(measid_2*("00000001001"))-("00000000011001001000");
		   elsif (mu='0')	then
				measid<="111111110";
				measid_2<="000000000";
				mu_l<='0';
				counter_basic:="0111111";--53
				counter_basic_2:="0000000";
			end if;
		END IF;
END PROCESS;


PROCESS(clk)			

			variable temp: std_logic_vector (23 downto 0);
			variable temp_2: std_logic_vector (15 downto 0);
			variable temp_3: std_logic_vector (12 downto 0);
			variable counter_c: integer := 0;

			begin

				IF (clk'event and clk='1' and mu_l='1') THEN
					
					temp:=(robot_pose_theta(15) & robot_pose_theta(15) & robot_pose_theta(15) & robot_pose_theta(15) & robot_pose_theta & "0000")+(unsigned(measid_2)*conv_unsigned(142,15))-("000000000110010010000111");

																					
					--temp:=(robot_pose_theta(15) & robot_pose_theta(15) & robot_pose_theta(15) & robot_pose_theta(15) & robot_pose_theta)+(unsigned(measid_2)*conv_unsigned("00000001001",11))-("00000000011001001000");
					temp_t<= temp;
					temp_2:=temp(19 downto 4);	 --15 0
			
			
					if temp_2>"0111000100011001" then		--9p			"0000110010010000"+
							temp_2:=temp_2-"0111110110101001";
					elsif temp_2>"0101011111110101" then		  --7p
							temp_2:=temp_2-"0110010010000111";	 
					elsif temp_3>"0011111011010100" then	 --5p
							temp_2:=temp_2-"0100101101100101";
					elsif temp_2>"0010010110110010" then	  --3p
							temp_2:=temp_2-"0011001001000011";
					elsif temp_2>"0000110010010000" then	  --p
							temp_2:=temp_2-"0001100100100000";
					elsif temp_2<"1000111011101000" then		--9p			
							temp_2:=temp_2+"0111110110101001";
					elsif temp_2<"1010100000001011" then		  --7p
							temp_2:=temp_2+"0110010010000111";
					elsif temp_2<"1100000100101100" then	 -- -5p
							temp_2:=temp_2+"0100101101100101";
					elsif temp_2<"1101101001001110" then	  -- -3p
							temp_2:=temp_2+"0011001001000011";
					elsif temp_2<"1111001101110000" then	  -- -p
							temp_2:=temp_2+"0001100100100000";
						
									
					end if;
			
										
--					if temp_2>"0111000100011001" then		--9p			"0000110010010000"+
--							temp_2:=temp_2-"0111110110101001";
--					elsif temp_2>"0101011111110101" then		  --7p
--							temp_2:=temp_2-"0110010010000111";	 
--					elsif temp_3>"0011111011010100" then	 --5p
--							temp_2:=temp_2-"0100101101100101";
--					elsif temp_2>"0010010110110010" then	  --3p
--							temp_2:=temp_2-"0011001001000011";
--					elsif temp_2>"0000110010010000" then	  --p
--							temp_2:=temp_2-"0001100100100000";
--					elsif temp_2<"1000111011101000" then		--9p			
--							temp_2:=temp_2+"0111110110101001";
--					elsif temp_2<"1010100000001011" then		  --7p
--							temp_2:=temp_2+"0110010010000111";
--					elsif temp_2<"1100000100101100" then	 -- -5p
--							temp_2:=temp_2+"0100101101100101";
--					elsif temp_2<"1101101001001110" then	  -- -3p
--							temp_2:=temp_2+"0011001001000011";
--					elsif temp_2<"1111001101110000" then	  -- -p
--							temp_2:=temp_2+"0001100100100000";
--						
--									
--					end if;
					
					temp_3:=temp_2(12 downto 0);
					value<=temp_3;
					

				END IF;

END PROCESS;



PROCESS(clk,mu,rdy)

			variable R: integer:=78;--unsigned(6 downto 0) :=0;	 --67
			variable cos_special, sin_special: std_logic_vector(11 downto 0) :="000000000000";
			variable xpoint, ypoint, xpoint_old, ypoint_old: std_logic_vector(11 downto 0);
			variable xpoint_i, ypoint_i, cos_sum, sin_sum, cos_sum_special, sin_sum_special: std_logic_vector(21 downto 0) :="0000000000000000000000";
			variable tt: std_logic_vector(7 downto 0);
			variable cos, sin : std_logic_vector(11 downto 0);
			variable m: integer;
			--variable	TH: signed(7 downto 0) :=signed(-90);
			--variable dmeasure: unsigned(6 downto 0);
						
			BEGIN
				
				IF (clk'event and clk='1' and rdy='1' and mu_l='1') THEN	  
			

						m:=conv_integer(unsigned(measid))/2; 						  
						original_address<=conv_std_logic_vector(m,9);

						if (cos_out(11)='1') then				
						cos:=cos_out+"000000000001";
						else
						cos:=cos_out;
						end if;
			
						if (sin_out(11)='1') then
						sin:=sin_out+"000000000001";
						else
						sin:=sin_out;
						end if;
cos_t<=cos;
sin_t<=sin;
						cos_sum:=cos_sum+(cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos);
						sin_sum:=sin_sum+(sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin);
cos_sum_t<=cos_sum;
sin_sum_t<=sin_sum;
						xpoint_i:=(robot_pose_x & "0000000000") + ("0000111110100000000000") + (cos_sum);
						ypoint_i:=(robot_pose_y & "0000000000") + ("0000111110100000000000") + (sin_sum);
						xpoint:=xpoint_i(21 downto 10);
						ypoint:=ypoint_i(21 downto 10);

xpoint_t<=xpoint;
ypoint_t<=ypoint;						
						if (R=78) then
							xpoint_i:=(robot_pose_x & "0000000000") + ("0000111110100000000000") + (cos_sum_special) - (cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special) - (cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special);
							ypoint_i:=(robot_pose_y & "0000000000") + ("0000111110100000000000") + (sin_sum_special) - (sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special) - (sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special);
							xpoint_old:=xpoint_i(21 downto 10);
							ypoint_old:=ypoint_i(21 downto 10);
						elsif  (R=79) then
							xpoint_i:=(robot_pose_x & "0000000000") + ("0000111110100000000000") + (cos_sum_special) - (cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special(11) & cos_special);
							ypoint_i:=(robot_pose_y & "0000000000") + ("0000111110100000000000") + (sin_sum_special) - (sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special(11) & sin_special);
							xpoint_old:=xpoint_i(21 downto 10);
							ypoint_old:=ypoint_i(21 downto 10);
						elsif  (R=80) then
							xpoint_i:=(robot_pose_x & "0000000000") + ("0000111110100000000000") + (cos_sum_special);
							ypoint_i:=(robot_pose_y & "0000000000") + ("0000111110100000000000") + (sin_sum_special);
							xpoint_old:=xpoint_i(21 downto 10);
							ypoint_old:=ypoint_i(21 downto 10);
						else
							xpoint_i:=(robot_pose_x & "0000000000") + ("0000111110100000000000") + (cos_sum) - (cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos) - (cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos) - (cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos(11) & cos);
							ypoint_i:=(robot_pose_y & "0000000000") + ("0000111110100000000000") + (sin_sum) - (sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin) - (sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin) - (sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin(11) & sin);
							xpoint_old:=xpoint_i(21 downto 10);
							ypoint_old:=ypoint_i(21 downto 10);							
						end if;
												
						map_address_rd<=conv_std_logic_vector(conv_integer(unsigned(ypoint))*512+conv_integer(unsigned(xpoint)),18);

							tt:=map_value_rd;
				
							map_we<='0';			----prosoxi
						if ((conv_integer(unsigned(original_value_scan))>R) or (original_value_x="0000000000" and original_value_y="0000000000"))	then
							tt:=conv_std_logic_vector(conv_integer(unsigned(tt))+(255-conv_integer(unsigned(tt)))/8,8);
							--tt:=conv_std_logic_vector(conv_integer(unsigned(map_value_rd))+(255-conv_integer(unsigned(map_value_rd)))/8,8);
							map_value_wr<=tt;
							map_address_wr<=conv_std_logic_vector(conv_integer(unsigned(ypoint_old))*512+conv_integer(unsigned(xpoint_old)),18);
							map_we<='1';

							--rd_int<=conv_std_logic_vector(conv_integer(map_value_rd),8);
							--div<=conv_std_logic_vector((255-conv_integer(map_value_rd))/8,8);
						end if;
							
						if (conv_integer(unsigned(original_value_scan))>(R-1) and conv_integer(unsigned(original_value_scan))<(R+2) and conv_integer(unsigned(original_value_scan))/=79) then
							tt:=conv_std_logic_vector(conv_integer(unsigned(tt))/4,8);
							--tt:=conv_std_logic_vector(conv_integer(unsigned(map_value_rd))/4,8);
							map_value_wr<=tt;
							map_address_wr<=conv_std_logic_vector(conv_integer(unsigned(ypoint_old))*512+conv_integer(unsigned(xpoint_old)),18);
							map_we<='1';
						
							--div2<=conv_std_logic_vector(conv_integer(map_value_rd)/4,8);
						end if;				

									----prosoxi
						if ((conv_integer(unsigned(original_value_scan))>R) or (original_value_x="0000000000" and original_value_y="0000000000"))	then
							tt:=conv_std_logic_vector(conv_integer(unsigned(tt))+(255-conv_integer(unsigned(tt)))/8,8);
							--tt:=conv_std_logic_vector(conv_integer(unsigned(map_value_rd))+(255-conv_integer(unsigned(map_value_rd)))/8,8);
							map_value_wr<=tt;
							map_address_wr<=conv_std_logic_vector(conv_integer(unsigned(ypoint_old))*512+conv_integer(unsigned(xpoint_old)),18);
							map_we<='1';

							--rd_int<=conv_std_logic_vector(conv_integer(map_value_rd),8);
							--div<=conv_std_logic_vector((255-conv_integer(map_value_rd))/8,8);
												
						elsif (conv_integer(unsigned(original_value_scan))>(R-2) and conv_integer(original_value_scan)<(R+1)) then
							tt:=conv_std_logic_vector(conv_integer(unsigned(tt))/4,8);
							--tt:=conv_std_logic_vector(conv_integer(unsigned(map_value_rd))/4,8);
							map_value_wr<=tt;
							map_address_wr<=conv_std_logic_vector(conv_integer(unsigned(ypoint_old))*512+conv_integer(unsigned(xpoint_old)),18);
							map_we<='1';
						
							--div2<=conv_std_logic_vector(conv_integer(map_value_rd)/4,8);
						
						else
							 	map_we<='0';
						end if;	




tt_t<=tt;
						
						

						if (R=77) then
							cos_sum_special:=cos_sum;
							sin_sum_special:=sin_sum;
							cos_sum_special_t<=cos_sum_special;
							sin_sum_special_t<=sin_sum_special;
							sin_sum:="0000000000000000000000";
							cos_sum:="0000000000000000000000";
							cos_special:=cos;
							sin_special:=sin;						
						
						end if;

					if (conv_integer(unsigned(measid))<362 and conv_integer(unsigned(measid))>0) then	
						if (R=80) then
							R:=1;
														
						else
							R:=R+1;
						end if;

					elsif (conv_integer(unsigned(measid))=0) then 
						 if (R=80) then
							R:=0;
														
						else
							R:=R+1;
						end if;
					
					--elsif (conv_integer(unsigned(measid))=2) then 
					--	 if (R=69) then
					--		R:=1;
														
					--	else
						--	R:=R+1;
					--	end if;
							
					end if;


R_t<=conv_std_logic_vector(R,7);		
												
						if measid=362 then	  --21
						finished <= '1';
						R:=78;
						else finished <='0';
						end if;

		
				END IF;
	
	

		END PROCESS;



end Behavioral;
