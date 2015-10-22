		 ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:33:03 11/24/2009 
-- Design Name: 
-- Module Name:    update_fitnesses_pipelined - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--library XilinxCoreLib;
--use UNISIM.VComponents.all;

entity test3 is

PORT ( update, clk: IN std_logic;
		 robot_x, robot_y: IN std_logic_vector (11 downto 0);
		 robot_theta: IN std_logic_vector (15 downto 0);							 -----CHECK ARXIKES
		 original: IN std_logic_vector (399 downto 0);
		 person_in: IN std_logic_vector (23 downto 0); --:= "000000000000000000000000";
		 person_in_2: IN std_logic_vector (23 downto 0); --:= "000000000000000000000000";		 --gia na exei timi ston prwto kyklo
		 --start_x: IN std_logic_vector (11 downto 0);
		 --start_y:	IN std_logic_vector (11 downto 0);
		 point_value_1: IN std_logic_vector(7 downto 0);
		 point_value_2: IN std_logic_vector(7 downto 0);
		 address_in: OUT std_logic_vector (8 downto 0);
		 address_in_2: OUT std_logic_vector (8 downto 0);
		 fitness_out: OUT std_logic_vector (12 downto 0);
		 address_out: OUT std_logic_vector (8 downto 0);
		 we: OUT std_logic;
		 point_address_1: OUT std_logic_vector (17 downto 0);
		 point_address_2: OUT std_logic_vector (17 downto 0);
		 up_best_ce: OUT std_logic;
		 up_best_wr: OUT std_logic_vector (23 downto 0);
		 --sin:OUT STD_LOGIC_VECTOR (11 downto 0);
		 --cos:OUT STD_LOGIC_VECTOR (11 downto 0);
		  --p:OUT STD_LOGIC_VECTOR (12 downto 0);
		  --best: OUT STD_LOGIC_VECTOR (12 downto 0);
		 -- t: OUT std_logic_vector (15 downto 0);
--i1x :OUT STD_LOGIC_VECTOR (11 downto 0);
--i1y :OUT STD_LOGIC_VECTOR (11 downto 0);
--i2x :OUT STD_LOGIC_VECTOR (11 downto 0);
--i2y :OUT STD_LOGIC_VECTOR (11 downto 0);
--posx :OUT std_logic_vector (11 downto 0);
--posy :OUT std_logic_vector (11 downto 0);
--t11 :OUT std_logic_vector (21 downto 0);
--t12 :OUT std_logic_vector (21 downto 0);
--t21 :OUT std_logic_vector (21 downto 0);
--t22 :OUT std_logic_vector (21 downto 0);
--jj :OUT std_logic_vector (4 downto 0);

		 cm: OUT std_logic
		 );

end test3;



architecture Behavioral of test3 is
  	--signal original: 	std_logic_VECTOR(399 downto 0) := conv_std_logic_vector(6637563,400);
	signal a, a2:  std_logic_VECTOR(9 downto 0);
	signal b, b2: std_logic_VECTOR(11 downto 0);
	signal o, o2, m1, m2: std_logic_VECTOR(11 downto 0);
	signal phase_in:std_logic_VECTOR(12 downto 0);
	signal x_out: std_logic_VECTOR(11 downto 0);
	signal y_out: std_logic_VECTOR(11 downto 0);
	signal rdy,rdy_m,rdy_m_2: std_logic;
	signal update_l: std_logic;
	--signal counter_l: unsigned(7 downto 0) :="00000000";
	signal counter_l: unsigned(8 downto 0); --:="000000000";
	signal counter_l_2: unsigned(8 downto 0); --:= "000000000";
	signal counter_l_3: unsigned(8 downto 0); --:= "000000000";
	--TYPE ind is array (0 to 149, 0 to 149) of std_logic;
	--signal index: ind;
	signal ppp: std_logic_vector(23 downto 0);


signal i1x :STD_LOGIC_VECTOR (11 downto 0);
signal i1y :STD_LOGIC_VECTOR (11 downto 0);
signal i2x :STD_LOGIC_VECTOR (11 downto 0);
signal i2y :STD_LOGIC_VECTOR (11 downto 0);
signal posx :std_logic_vector (11 downto 0);
signal posy :std_logic_vector (11 downto 0);
signal t11 :std_logic_vector (11 downto 0);
signal t12 :std_logic_vector (11 downto 0);
signal t21 :std_logic_vector (11 downto 0);
signal t22 :std_logic_vector (11 downto 0);
--signal t1,t2: STD_LOGIC_VECTOR (359 downto 0);


signal t1a,t1b,t2a,t2b: STD_LOGIC_VECTOR (43 downto 0);
	
	component trig3
		port (
			phase_in: IN std_logic_VECTOR(12 downto 0);
			x_out: OUT std_logic_VECTOR(11 downto 0);
			y_out: OUT std_logic_VECTOR(11 downto 0);
			rdy: OUT std_logic;
			clk: IN std_logic);
	end component;

  --component multiplier1
--	port(
--		clk: IN std_logic;
--	a: IN std_logic_VECTOR(9 downto 0);
--	b: IN std_logic_VECTOR(11 downto 0);
--	q: OUT std_logic_VECTOR(11 downto 0);
	
--	rdy: OUT std_logic);
--	end component;



	begin

		U1: trig3
			port map(phase_in,x_out,y_out,rdy,clk);
		--sin<=y_out;
		--cos<=x_out;
  		--p<=phase_in;

--		U2: multiplier1
--			port map(clk,a,b,o,rdy_m);

--			U3: multiplier1
--			port map(clk,a2,b2,o2,rdy_m_2);
		
		
		PROCESS (clk)
		variable counter_basic:	unsigned(4 downto 0); --:= "00000";
		variable counter_basic_2:	unsigned(4 downto 0); --:= "11010";
		variable counter_basic_3:	unsigned(4 downto 0); --:= "11000";
		BEGIN
		IF (clk'event and clk='1' )  THEN
			if (update='1') then
				counter_basic:=counter_basic+"00001";
				counter_basic_2:=counter_basic_2+"00001";
				counter_basic_3:=counter_basic_3+"00001";
				if (counter_basic=10) then
					counter_l<=counter_l+"000000001";
					counter_basic:="00000";
				end if;
				if (counter_basic_2=10) then
					
					counter_l_2<=counter_l_2+"000000001";
					counter_basic_2:="00000";
				end if;
				if (counter_basic_3=10) then
					
					counter_l_3<=counter_l_3+"000000001";
					counter_basic_3:="00000";
				end if;
				update_l<='1';	
		   elsif (update='0')	then
				counter_l<="000000000";
				counter_l_2<="000000000";
				counter_l_3<="000000000";
				update_l<='0';
				counter_basic:="00000";
				counter_basic_2:="11001";
				counter_basic_3:="10100";
			end if;
		END IF;
		END PROCESS;
		
				
		--PROCESS (clk)

		--BEGIN
		--IF (clk'event and clk='1' )  THEN
		--	if (update='1') then
			--	counter_l<=counter_l+1;
			--	update_l<='1';
		  -- elsif (update='0')	then
		--		counter_l<="00000000";
		--		update_l<='0';
		--	end if;
		--END IF;
	--	END PROCESS;


		PROCESS(clk)			

			variable temp_3: std_logic_vector (15 downto 0);
			variable temp_3_f: std_logic_vector (12 downto 0);
			variable counter_c: integer := 0;

			begin

				IF (clk'event and clk='1' and update_l='1') THEN
																							  -----XREIAZETAI ELENXOS SOS
					counter_c := conv_integer(counter_l)-1;
									

					address_in <= conv_std_logic_vector(counter_c,9);
					temp_3 := robot_theta+(person_in(23) & person_in(23) & person_in(23 downto 10));		
					--t<=temp_3;
					if temp_3>"0111000100011000" then		--9p			"0000110010010000"+
							temp_3:=temp_3-"0111110110101001";
					elsif temp_3>"0101011111110101" then		  --7p
							temp_3:=temp_3-"0110010010000111";	 
					elsif temp_3>"0011111011010100" then	 --5p
							temp_3:=temp_3-"0100101101100101";
					elsif temp_3>"0010010110110010" then	  --3p
							temp_3:=temp_3-"0011001001000011";
					elsif temp_3>"0000110010010000" then	  --p
							temp_3:=temp_3-"0001100100100000";
					elsif temp_3<"1000111011101000" then		--9p			
							temp_3:=temp_3+"0111110110101001";
					elsif temp_3<"1010100000001011" then		  --7p
							temp_3:=temp_3+"0110010010000111";
					elsif temp_3<"1100000100101100" then	 -- -5p
							temp_3:=temp_3+"0100101101100101";
					elsif temp_3<"1101101001001110" then	  -- -3p
							temp_3:=temp_3+"0011001001000011";
					elsif temp_3<"1111001101110000" then	  -- -p
							temp_3:=temp_3+"0001100100100000";
						
					
					end if;
					
					temp_3_f:=temp_3(12 downto 0);
					phase_in<=temp_3_f;
					--counter_c:=counter_c+1;
	
	
				END IF;

		END PROCESS;

	

		PROCESS(clk,update,rdy)

			variable j: integer :=2;
			variable temp_1,temp_2: std_logic_vector (11 downto 0);
			--variable temp_3: std_logic_vector (22 downto 0);
			variable sinth,costh: STD_LOGIC_VECTOR (11 downto 0);
			variable fitness: unsigned (12 downto 0); --:= "0000000000000";		 ---mipws unsigned????
			variable counter, counter_fit: integer :=0;
			--variable bestTransformation: std_logic_vector (23 downto 0) := "000000000000000000000000";
			variable bestFitness: unsigned (12 downto 0);-- := "0000000000000";  ---mipws unsigned??
			--variable new_fitness: std_logic_vector (12 downto 0);
			--variable useless: STD_LOGIC_VECTOR (5 downto 0):= "000100";
			variable point1, point2: integer;
			variable ttt1x, ttt1y, ttt2x, ttt2y: STD_LOGIC_VECTOR(11 downto 0);--TYPE v is array (0 to 499, 0 to 19) of unsigned(11 downto 0);
			--variable tttx_temp, ttty_temp: v;
			variable t1,t2: STD_LOGIC_VECTOR (43 downto 0);
			variable person_in_temp: std_logic_vector(23 downto 0);

			BEGIN --------------best fitness 0 na ginetai------------------------


				IF (clk'event and clk='1' and rdy='1' and update_l='1') THEN	  --counter 501
			
						counter := conv_integer(counter_l_2)-2;
						counter_fit := conv_integer(counter_l_3)-2;	
						
						address_in_2 <= conv_std_logic_vector(counter,9);
						--fitness := conv_std_logic_vector(counter/16,6);
						temp_1 := robot_x+(person_in_2(4) & person_in_2(4) & person_in_2(4) & person_in_2(4) & person_in_2(4) & person_in_2(4) & person_in_2(4) & person_in_2(4 downto 0));
						temp_2 := robot_y+(person_in_2(9) & person_in_2(9) & person_in_2(9) & person_in_2(9) & person_in_2(9) & person_in_2(9) & person_in_2(9) & person_in_2(9 downto 5));
						--temp_3 := robot_theta+person_in(31 downto 10);
						
posx<=temp_1;
posy<=temp_2;

						if (y_out(11)='1') then				
						sinth:=y_out+"000000000001";
						else
						sinth:=y_out;
						end if;
			
						if (x_out(11)='1') then
						costh:=x_out+"000000000001";
						else
						costh:=x_out;
						end if;
													
						

						--a<=original((j*20+9) downto (j*20));
					--	b<=	costh;
					--	m1<= o;

					--	a2<=original((j*20+19) downto (j*20+10));
					--	b2<=	sinth;
					--	m2<= o2;

					--	t1((21) downto (0)):=m1+m2+ (temp_1(11) & temp_1(11) & temp_1(11) & temp_1(11) & temp_1(11) &  temp_1(11) &  temp_1(11) &  temp_1(11) &  temp_1(11) &  temp_1(11) & temp_1);--+conv_signed(250,16),16);
						t1((21) downto (0)):=original((j*20+9) downto (j*20))*costh-original((j*20+19) downto (j*20+10))*sinth+(temp_1 & "0000000000");--+conv_signed(250,16),16);
						t2((21) downto (0)):=original((j*20+9) downto (j*20))*sinth+original((j*20+19) downto (j*20+10))*costh+(temp_2 & "0000000000");--+conv_signed(250,16),16);
						j:=j+1;
						t1((43) downto (22)):=original((j*20+9) downto (j*20))*costh-original((j*20+19) downto (j*20+10))*sinth+(temp_1 & "0000000000");--+conv_signed(250,16),16);
						t2((43) downto (22)):=original((j*20+9) downto (j*20))*sinth+original((j*20+19) downto (j*20+10))*costh+(temp_2 & "0000000000");--+conv_signed(250,16),16);
						j:=j+1;	
						if (j=20) then
							
							j:=0;
						end if;
		--	jj<=conv_std_logic_vector(j,5);			 -------------!!!!prosoxi an allazei to timing otan vazw bram gia xarti
			t11<=	t1((21) downto (10));
			t12<=	t2((21) downto (10));
			t21<=	t1((43) downto (32));
			t22<=	t2((43) downto (32));		
						---FOR j IN 0 TO 1 LOOP				----------------POLLAPLASIASTES ETOIMA CORES
				
							--tttx((j*18+17) downto (j*18))<=original((j*20+9) downto j*20)*costh-original((j*20+19) downto (j*20+10))*sinth+temp_1;--+conv_signed(250,16),16);
							--ttty((j*18+17) downto (j*18))<=original((j*20+9) downto j*20)*sinth;--+conv_signed(250,16),16);
						  					
							---t1((j*22+21) downto (j*22)):=original((j*20+9) downto (j*20))*costh-original((j*20+19) downto (j*20+10))*sinth+(temp_1(11) & temp_1(11) & temp_1(11) & temp_1(11) & temp_1(11) &  temp_1(11) &  temp_1(11) &  temp_1(11) &  temp_1(11) &  temp_1(11) & temp_1);--+conv_signed(250,16),16);
							---t2((j*22+21) downto (j*22)):=original((j*20+9) downto (j*20))*sinth+original((j*20+19) downto (j*20+10))*costh+(temp_2(11) & temp_2(11) & temp_2(11) & temp_2(11) & temp_2(11) &  temp_2(11) &  temp_2(11) &  temp_2(11) &  temp_2(11) &  temp_2(11) & temp_2);--+conv_signed(250,16),16);
													
							--tttx_temp(counter,j) := unsigned(t1((j*18+17) downto (j*18+6))+250);	
							--ttty_temp(counter,j) := unsigned(t2((j*18+17) downto (j*18+6))+250);
														
							--if unsigned(tttx_temp(counter,j))<50 and unsigned(ttty_temp(counter,j))<50 then
							--index(conv_integer(unsigned(t1((j*18+10) downto (j*18+6)))),conv_integer(unsigned(t2((j*18+10) downto (j*18+6))))) <= '1';
							--end if;
							--tttx((j*18+17) downto (j*18)) <= conv_std_logic_vector(signed(original((j*20+9) downto j*20))*signed(costh)-signed(original((j*20+19) downto (j*20+10)))*signed(sinth)+signed(temp_1)+conv_signed(25,18),18);--+conv_signed(250,16),16);
							--ttty((j*18+17) downto (j*18)) <= conv_std_logic_vector(signed(original((j*20+9) downto j*20))*signed(sinth)+signed(original((j*20+19) downto (j*20+10)))*signed(costh)+signed(temp_2)+conv_signed(25,18),18);--+conv_signed(250,16),16);
							--tttz(23 downto 0) <= std_logic_vector(signed(robot_theta)/255);
						---END LOOP;
						
						ttt1x := t1(21 downto 10)+250;
						ttt1y := t2(21 downto 10)+250;
						ttt2x := t1(43 downto 32)+250;--(temp_1 & "0000000000");
						ttt2y := t2(43 downto 32)+250;--(temp_2 & "0000000000");

i1x <=ttt1x;
i1y <= ttt1y;
i2x <= ttt2x;
i2y <= ttt2y;

					-- point1:=((unsigned(ttt1x))-(unsigned(start_x)))*256+unsigned(ttt1y)-unsigned(start_y);
					--	point2:=((unsigned(ttt2x))-(unsigned(start_x)))*256+unsigned(ttt2y)-unsigned(start_y);

					
					point1:=(conv_integer(unsigned(ttt1y)))*512+conv_integer(unsigned(ttt1x));
					point2:=(conv_integer(unsigned(ttt2y)))*512+conv_integer(unsigned(ttt2x));

						point_address_1 <= conv_std_logic_vector(point1,18);
						point_address_2 <= conv_std_logic_vector(point2,18);
						
--point_address_1 <= conv_std_logic_vector((conv_integer(unsigned(t2(21 downto 10))))*512+conv_integer(unsigned(t1(21 downto 10))),18);
--point_address_2 <= conv_std_logic_vector((conv_integer(unsigned(t2(43 downto 32))))*512+conv_integer(unsigned(t1(43 downto 32))),18);


						fitness:=fitness+"0000011111111"-unsigned("00000" & point_value_1)+"0000011111111"-unsigned("00000" & point_value_2);		
						--tttx<=t1;
						--ttty<=t2;
						--tttx <= tttx_temp;
						--ttty <= ttty_temp;
						--fitness := "001010";
						--useless := "000110";
						--new_fitness := conv_std_logic_vector(signed(fitness)*signed(useless),16);
						fitness_out <= std_logic_vector(fitness);
						
						if (j=6) then
							
							if fitness > bestFitness then
								
								if counter_fit>0 then 
								bestFitness := fitness;
								
								up_best_wr <= person_in_temp;
								up_best_ce <= '1';
							
								end if;
									
							else 	
							--up_best_wr <= person_in;
							up_best_ce <= '0';
							end if;
						--	best<=std_logic_vector(bestFitness);
							fitness := "0000000000000";
							person_in_temp:=person_in_2;
							ppp <= person_in_temp;
						end if;
					
--if (j=8) then 
	  ----SOS
--end if;					
						

						if counter_fit>=0 and counter_fit<500 then		 --20
						address_out <= conv_std_logic_vector(counter_fit,9);
						we <= '1';
						else we<='0';
						end if;
			
						if counter=0 then
						bestFitness:="0000000000000";
						--person_in_temp:=person_in_2;
						end if;						

						--if counter=511 and j=18 then
						--j:=12;
					--	end if;
									
						--counter:=counter+1;
			
						if counter=501 then	  --21
						cm <= '1';
						else cm <='0';
						end if;

						--person_in_temp:=person_in_2;
		
				END IF;
	
	

		END PROCESS;
	

			

end Behavioral;