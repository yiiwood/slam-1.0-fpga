----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:42:15 11/12/2009 
-- Design Name: 
-- Module Name:    initialise_population - Behavioral 
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
--library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use WORK.PACK.ALL;
--use ieee.math_real.all;
--use work.random1;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



--TYPE matrix is array (0 to 1, 0 to 1) of integer;
entity initialise is

PORT ( gotScans, clk: IN std_logic;
		 we: OUT std_logic;
		 start:OUT std_logic;
		 popul_t: OUT STD_LOGIC_VECTOR(23 downto 0);
		 address: OUT std_logic_vector (8 downto 0)
		 );

end initialise;



architecture Behavioral of initialise is
--signal popul_t: matrix;
signal load: std_logic;
--TYPE value_t is array (9 downto 0) of std_logic_vector(31 downto 0);
signal pd_out, pd_in: std_logic_vector(23 downto 0);
--signal n: integer;
--signal divident: signed (9 downto 0);
--signal divisor: signed (4 downto 0);
--signal quotient: signed (9 downto 0);
--signal remainder: signed (4 downto 0);
--signal rfd: std_logic;
signal gotScans_i: std_logic :='0';
signal counter_l: unsigned(8 downto 0) ;--:="000000000";
signal counter_r: unsigned(15 downto 0) :="0000000000101000";

component random2
	port (
	clk: IN std_logic;
	pd_out: OUT std_logic_VECTOR(23 downto 0);
	load: IN std_logic;
	pd_in: IN std_logic_VECTOR(23 downto 0));
end component;

		

begin


--label1: for n in 9 downto 0 generate
U: random2
		port map(
		clk => clk,
		pd_out => pd_out,
		load=>load,
		pd_in=>pd_in
		);
--end generate;


--M1: modulo
--		port map (
--			clk => clk,
--			dividend => dividend,
--			divisor => divisor,
	--		quotient => quotient,
	--		remainder => remainder,
	--		rfd => rfd);

--U1 : random1
	--	port map (
		--	clk => clk,
		--	pd_out => value);

--PROCESS (clk)

--variable lock: std_logic :='0';

--BEGIN

--IF (clk'event and clk='1' )	  THEN
			 	
  -- IF (gotScans = '0' and lock='0')	THEN
--		counter_r<="0000000000001001";
--	else
--		lock:='1';	
--	end if;
--END IF;

--END PROCESS;


PROCESS (clk, gotScans)

BEGIN

IF (clk'event and clk='1' )	  THEN
	if (gotScans='1') then
	 	counter_l<=counter_l+1;
	 	gotScans_i<='1';
		--pd_in <= std_logic_vector(counter_r & counter_r(7 downto 0));
		load<='0';
   ELSIF (gotScans = '0')	THEN
		counter_l<="000000000";
		gotScans_i<='0';
		
		pd_in <= std_logic_vector(counter_r & counter_r(7 downto 0));
		load<='1';
	end if;
END IF;

END PROCESS;



--PROCESS(gotScans)
--	begin
--	if (gotScans'event and gotScans='1') then
--		gotScans_i<='1';
--	end if;
--END PROCESS;



PROCESS (clk)	  --gotScans

--variable R,r1: real;
--variable S1, S2: positive := 42;
--variable HI: integer := 19;
--variable LO: integer := 0;
--constant c: real :=19.0;
--variable r_fixed_int: std_logic_vector(15 downto 0);
variable i: integer :=0;
--variable j: integer :=0;
--constant diaspora: signed :="0000010000";
variable tempx,tempy: signed (4 downto 0);
variable temptheta: signed (13 downto 0);
variable tempxf,tempyf: signed (4 downto 0);
variable tempthetaf: signed (13 downto 0);

begin
--FOR i IN 0 TO 9 LOOP
	--FOR j IN 0 TO 31 LOOP
		IF (gotScans_i='1' and clk'event and clk='1') THEN	--	and i
			
			--temp1 := signed(value(0)(9 downto 0));
			--temp1 := (temp1 mod (conv_signed(20,10)))-10;
			--temp1 := std_logic_vector(temp1);
			--temp2 := signed(value(0)(19 downto 10));
			--temp2 := (temp2 mod (conv_signed(20,10)))-10;
			--temp2 := std_logic_vector(temp2);
			 i := conv_integer(counter_l)-1;
			
			
			tempx :=signed (pd_out(4 downto 0));
			tempy :=signed (pd_out(9 downto 5));
			temptheta :=signed (pd_out(23 downto 10));
			tempxf := conv_signed(((conv_integer(unsigned(tempx)) mod 8)-4),5);
			tempyf := conv_signed(((conv_integer(unsigned(tempy)) mod 8)-4),5);
			tempthetaf := conv_signed(((conv_integer(unsigned(temptheta)) mod 256)-128),14);
			popul_t(4 downto 0) <=std_logic_vector(tempxf);-- value;--(0);--(31 downto 20) & std_logic_vector(temp2) & std_logic_vector(temp1);
			popul_t(9 downto 5) <=std_logic_vector(tempyf);
			popul_t(23 downto 10) <=std_logic_vector(tempthetaf);
			if (i=0) then
				popul_t(4 downto 0) <="00000";-- value;--(0);--(31 downto 20) & std_logic_vector(temp2) & std_logic_vector(temp1);
				popul_t(9 downto 5) <="00000";
				popul_t(23 downto 10) <="00000000000000";
			end if;
			address <= conv_std_logic_vector(i,9);
			--i := i+1;
			--uniform(S1, S2, R);
			
			--r1 := c*R;
			---r_fixed_int <= 
			
			--R := R * real(HI+1-LO) + real(LO);
			--temp := value(0);
			--popul_t(i*32+j) <= value(0)(j)
			
			--popul_t(i*32+j) <= value(i)(j);
			if i>=500 then
				we <= '0';
				--start <='1';
			else
				we <='1';
				--start <='0';

				end if;

if i=501 then
			start <= '1';
			counter_r<=counter_r+"0000000000000001";
			--best <= bestTransformation;
			else start <='0';
			end if;


		END IF;
	--END LOOP;
--END LOOP;

--flag <= '0';

END PROCESS;

--popul_t1 <= popul_t(0,1);
--popul_t2 <= popul_t(1,1);
--start <= flag;

end Behavioral;
