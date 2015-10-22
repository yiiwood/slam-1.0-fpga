----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:04:52 11/15/2009 
-- Design Name: 
-- Module Name:    crossover_mutation - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity crossover_mutation_f is

	port (clk, cm: in std_logic;
			person_t_in: in std_logic_vector(23 downto 0);
			--person_t_2_in: in std_logic_vector(39 downto 0);
			person_fitness_1_in: in std_logic_vector(12 downto 0);
			person_fitness_2_in: in std_logic_vector(12 downto 0);
			bT : in std_logic_vector(23 downto 0);
			address_t_wr: out std_logic_vector (8 downto 0);
			address_f_r_1: out std_logic_vector (8 downto 0);
			address_f_r_2: out std_logic_vector (8 downto 0);
			address_t_r:out std_logic_vector (8 downto 0);
			person_t_out : out std_logic_vector(23 downto 0);
			--person_fitness_out : out std_logic_vector(11 downto 0)
			finished: out std_logic;
			we: out std_logic
			);

end crossover_mutation_f;

architecture Behavioral of crossover_mutation_f is

	signal value,pd_in: std_logic_VECTOR(23 downto 0);
	signal value2,pd_in_2: std_logic_VECTOR(8 downto 0);
	signal cm_l, load: std_logic ;
	signal counter_l: unsigned(8 downto 0);-- :="00000000";
	signal counter_r: unsigned(15 downto 0) :="0000000000101000";

signal tempxf_out,tempyf_out,btx_out,bty_out: std_logic_vector(4 downto 0);
signal tempthetaf_out,bttheta_out: std_logic_vector(13 downto 0);

	component random2
		port (
		clk: IN std_logic;
		pd_out: OUT std_logic_VECTOR(23 downto 0);
		load: IN std_logic;
		pd_in: IN std_logic_VECTOR(23 downto 0)
		);
	end component;

	component random3
		port (
		clk: IN std_logic;
		pd_out: OUT std_logic_VECTOR(8 downto 0);
		load: IN std_logic;
		pd_in: IN std_logic_VECTOR(8 downto 0)
		);
	end component;


	BEGIN

	U1: random2
			port map(
			clk => clk,
			pd_out => value,
			load=>load,
			pd_in=>pd_in
			);
		
	U2: random3
			port map(
			clk => clk,
			pd_out => value2,
			load=>load,
			pd_in=>pd_in_2
			);


	PROCESS (clk, cm)

		BEGIN

		IF (clk'event and clk='1' )	  THEN
			if (cm='1') then
				counter_l<=counter_l+1;
				cm_l<='1';
				load<='0';
		   elsif (cm='0')	then
				counter_l<="000000000";
				cm_l<='0';
				pd_in <= std_logic_vector(counter_r & counter_r(7 downto 0));
				pd_in_2 <= std_logic_vector(counter_r(8 downto 0));
				load<='1';
			end if;
		END IF;

	END PROCESS;


	PROCESS (clk)

--		variable counter: integer; --:=0;
--		variable tempx,tempy: signed (4 downto 0);
--		variable temptheta: signed (13 downto 0);
--		variable tempxf,tempyf: signed (4 downto 0);
--		variable tempthetaf: signed (13 downto 0);
--		variable btx,bty: signed (4 downto 0);
--		variable bttheta: signed (13 downto 0);

		variable counter: integer; --:=0;
		variable tempx,tempy: std_logic_vector (4 downto 0);
		variable temptheta: std_logic_vector (13 downto 0);
		variable tempxf,tempyf: std_logic_vector (4 downto 0);
		variable tempthetaf: std_logic_vector (13 downto 0);
		variable btx,bty: std_logic_vector(4 downto 0);
		variable bttheta: std_logic_vector (13 downto 0);



		BEGIN

		IF (clk'event and clk='1' and cm_l='1') THEN						 --and counter <503
			
			counter := conv_integer(counter_l)-1;
			
			if ((counter)<25) then
					
				if (counter = 0) then
				
					person_t_out <= bT;
					address_t_wr <= conv_std_logic_vector(counter,9);
					--wr_addr <= "000000000";
					we <='1';
				else
		
--					tempx :=signed (value(4 downto 0));
--					tempy :=signed (value(9 downto 5));
--					temptheta :=signed (value(23 downto 10));
--		
--					tempxf := conv_signed(((conv_integer(unsigned(tempx)) mod 4)-2),5);
--					tempyf := conv_signed(((conv_integer(unsigned(tempy)) mod 4)-2),5);
--					tempthetaf := conv_signed(((conv_integer(unsigned(temptheta)) mod 128)-64),14);
--					btx:=signed(bT(4 downto 0));
--					bty:=signed(bT(9 downto 5));
--					bttheta:=signed(bT(23 downto 10));
--					person_t_out(4 downto 0) <=conv_std_logic_vector(btx+tempxf,5);-- value;--(0);--(31 downto 20) & std_logic_vector(temp2) & std_logic_vector(temp1);
--					person_t_out(9 downto 5) <=conv_std_logic_vector(bty+tempyf,5);
--					person_t_out(23 downto 10) <=conv_std_logic_vector(bttheta+tempthetaf,14);
--					address_t_wr <= conv_std_logic_vector(counter,9);
--					--wr_addr <= std_logic_vector(counter);
--					we <='1';


					tempx :=value(4 downto 0);
					tempy :=value(9 downto 5);
					temptheta :=value(23 downto 10);
		
					tempxf := conv_std_logic_vector(((conv_integer(unsigned(tempx)) mod 4)-2),5);
					tempyf := conv_std_logic_vector(((conv_integer(unsigned(tempy)) mod 4)-2),5);
					tempthetaf := conv_std_logic_vector(((conv_integer(unsigned(temptheta)) mod 128)-64),14);
					btx:=bT(4 downto 0);
					bty:=bT(9 downto 5);
					bttheta:=bT(23 downto 10);
					person_t_out(4 downto 0) <=conv_std_logic_vector(signed(btx+tempxf),5);-- value;--(0);--(31 downto 20) & std_logic_vector(temp2) & std_logic_vector(temp1);
					person_t_out(9 downto 5) <=conv_std_logic_vector(signed(bty+tempyf),5);
					person_t_out(23 downto 10) <=conv_std_logic_vector(signed(bttheta+tempthetaf),14);
					address_t_wr <= conv_std_logic_vector(counter,9);
					--wr_addr <= std_logic_vector(counter);
					we <='1';



				end if;
	
			elsif (counter<501) then		--21

				address_f_r_1 <= conv_std_logic_vector(counter,9);
				if conv_integer(value2)<500 then
					address_f_r_2 <= conv_std_logic_vector(conv_integer(value2),9);
					address_t_r <= conv_std_logic_vector(conv_integer(value2),9);
				else
					address_f_r_2 <= conv_std_logic_vector(499,9);
					address_t_r <= conv_std_logic_vector(499,9);
				end if;
	
				
	
				if (unsigned(person_fitness_2_in)>unsigned(person_fitness_1_in)) then
		
--					--person_t_out <= person_t_2_in;
--					tempx :=signed (value(4 downto 0));
--					tempy :=signed (value(9 downto 5));
--					temptheta :=signed (value(23 downto 10));
--					tempxf := conv_signed(((conv_integer(unsigned(tempx)) mod 4)-2),5);
--					tempyf := conv_signed(((conv_integer(unsigned(tempy)) mod 4)-2),5);
--					tempthetaf := conv_signed(((conv_integer(unsigned(temptheta)) mod 64)-32),14);
--					btx:=signed(person_t_in(4 downto 0));
--					bty:=signed(person_t_in(9 downto 5));
--					bttheta:=signed(person_t_in(23 downto 10));
--					person_t_out(4 downto 0) <=conv_std_logic_vector(signed(btx)+signed(tempx),5);-- value;--(0);--(31 downto 20) & std_logic_vector(temp2) & std_logic_vector(temp1);
--					person_t_out(9 downto 5) <=conv_std_logic_vector(signed(bty)+signed(tempy),5);
--					person_t_out(23 downto 10) <=conv_std_logic_vector(signed(bttheta)+signed(tempthetaf),14);
					
					--person_t_out <= person_t_2_in;
					tempx :=value(4 downto 0);
					tempy :=value(9 downto 5);
					temptheta :=value(23 downto 10);
					tempxf := conv_std_logic_vector(((conv_integer(unsigned(tempx)) mod 4)-2),5);
					tempyf := conv_std_logic_vector(((conv_integer(unsigned(tempy)) mod 4)-2),5);
					tempthetaf := conv_std_logic_vector(((conv_integer(unsigned(temptheta)) mod 64)-32),14);
					btx:=person_t_in(4 downto 0);
					bty:=person_t_in(9 downto 5);
					bttheta:=person_t_in(23 downto 10);
					person_t_out(4 downto 0) <=conv_std_logic_vector(signed(btx)+signed(tempxf),5);-- value;--(0);--(31 downto 20) & std_logic_vector(temp2) & std_logic_vector(temp1);
					person_t_out(9 downto 5) <=conv_std_logic_vector(signed(bty)+signed(tempyf),5);
					person_t_out(23 downto 10) <=conv_std_logic_vector(signed(bttheta)+signed(tempthetaf),14);
					
					tempxf_out<=tempxf; 
					tempyf_out<=tempyf;
					tempthetaf_out<=tempthetaf;
					btx_out<=btx;
					bty_out<=bty;
					bttheta_out<=bttheta;
					
								
					--else
					--person_t_out <= person_t__in;
					address_t_wr <= conv_std_logic_vector(counter-3,9);
					we <='1';
		
				else
					we <='0';
	
				end if;
			
			elsif (counter=501) then --21
				we<='0';
	
	
			end if;


			if counter=501 then		 --21
				finished <= '1';
				counter_r<=counter_r+"0000000000000001";
				--best <= bestTransformation;
			else finished <='0';
			end if;
			--counter:=counter+1;

		END IF;


	END PROCESS;


end Behavioral;

