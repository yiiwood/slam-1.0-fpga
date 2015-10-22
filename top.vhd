----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:53 01/20/2010 
-- Design Name: 
-- Module Name:    top_all - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top3 is

PORT(clk, rst, run: in std_logic;
	  r_x, r_y: out std_logic_vector (11 downto 0);
	  --start_x, start_y: IN std_logic_vector (11 downto 0);
	  r_theta: out std_logic_vector (15 downto 0)
	  --original: IN std_logic_vector (399 downto 0);
	  --point_value_1, point_value_2: IN std_logic_vector(7 downto 0);
	  --bT : in std_logic_vector(31 downto 0);
	  --best: 	  OUT std_logic_vector (23 downto 0);
	  --tttx,ttty: OUT std_logic_vector (359 downto 0);
	  --valid: 	OUT std_logic;
	  --init_start, up_start, cm_start,init_done, up_done, cm_done: OUT std_logic;
	  --point_address_1,point_address_2 : out std_logic_vector(15 downto 0);
	  --sin, cos: out STD_LOGIC_VECTOR (11 downto 0);
	  --p: out STD_LOGIC_VECTOR (12 downto 0);
		--best_fit: out STD_LOGIC_VECTOR (12 downto 0);
		--t: out std_logic_vector (15 downto 0);
		--i1x,i1y,i2x,i2y: out STD_LOGIC_VECTOR (11 downto 0);
		--posx : out std_logic_vector (11 downto 0);
		--posy : out std_logic_vector (11 downto 0);
		--t11,t12,t21,t22: out std_logic_vector (21 downto 0);
		--jj : out std_logic_vector (4 downto 0);
		--best_trans: out std_logic_vector(23 downto 0);
		--init_data: OUT STD_LOGIC_VECTOR(23 downto 0);


--person1: OUT STD_LOGIC_VECTOR(23 downto 0);
--person2: OUT STD_LOGIC_VECTOR(23 downto 0);
--address1: OUT STD_LOGIC_VECTOR(8 downto 0);
--address2: OUT STD_LOGIC_VECTOR(8 downto 0);
--fit_out: OUT STD_LOGIC_VECTOR(12 downto 0);
--fit_addr: OUT STD_LOGIC_VECTOR(8 downto 0);
--fit_we: OUT STD_LOGIC;
--b_ce: OUT STD_LOGIC;
--b_data: OUT STD_LOGIC_VECTOR(23 downto 0);
--Q: OUT STD_LOGIC_VECTOR(23 downto 0);
--a1: OUT STD_LOGIC_VECTOR(8 downto 0);
--a2: OUT STD_LOGIC_VECTOR(8 downto 0);




--t_we_test : OUT STD_LOGIC;
--t_a_test : OUT STD_LOGIC_VECTOR(8 downto 0);
--t_dpra_test : OUT STD_LOGIC_VECTOR(8 downto 0);
--person_t_in_test: out std_logic_vector(23 downto 0);
--person_t_out_test : out std_logic_vector(23 downto 0);
--		
--person_fitness_1_in_test: out std_logic_vector(12 downto 0);
--person_fitness_2_in_test: out std_logic_vector(12 downto 0);
--f_a_test: out std_logic_vector (8 downto 0);
--f_dpra_test: out std_logic_vector (8 downto 0);
--f_a_test_2: out std_logic_vector (8 downto 0);
--f_dpra_test_2: out std_logic_vector (8 downto 0)
);

end top3;

architecture Behavioral of top3 is

component controller
	PORT ( clk, rst, run, init_done, fix_done, up_done, cm_done, up_best_ce, map_done: IN STD_LOGIC;
	address_t_wr_init, address_t_r_up_1, address_t_r_up_2, address_f_wr_up, address_t_r_cm, address_t_wr_cm, address_f_r_cm_1, address_f_r_cm_2 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
	angle_index_fix, angle_index_map: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
	address_m_rd1_up, address_m_rd2_up, address_m_wr_map, address_m_rd_map: IN STD_LOGIC_VECTOR(17 DOWNTO 0);
	data_t_init, data_t_cm , up_best_wr: IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	data_m_map: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	we_t_init, we_t_cm, we_f_up, we_m_map: IN STD_LOGIC;
	Q: IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	address_t_a, address_t_dpra, address_f_a, address_f_dpra: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
	address_m_a, address_m_dpra: 	OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
	data_t: OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
	data_m: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	we_t, we_f, we_m, init_start, fix_start, up_start, cm_start, map_start, valid, best_ce: OUT STD_LOGIC;
	best_wr: OUT std_logic_vector(23 DOWNTO 0);
	robotPose_x, robotPose_y: OUT std_logic_vector(11 DOWNTO 0);
	robotPose_theta: OUT std_logic_vector(15 DOWNTO 0);
	angle_index: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
	scan_index: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
end component;

component initialise
PORT ( gotScans, clk: IN std_logic;
		 we: OUT std_logic;
		 start:OUT std_logic;
		 popul_t: OUT STD_LOGIC_VECTOR(23 downto 0);
		 address: OUT std_logic_vector (8 downto 0)
		 );
end component;

component test3
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
end component;

component crossover_mutation_f
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
end component;

component map_update is

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
 
end component;

component fix_original is

		port (clk: in std_logic;
				start: in std_logic;
				data_x : in std_logic_vector(9 downto 0);
				data_y : in std_logic_vector(9 downto 0);
				angle_index : out std_logic_vector(8 downto 0);
				original: out std_logic_vector(399 downto 0);
				finished: out std_logic
				);
				
end component;

component t_memory_dual
port (clk : in std_logic;
			we : in std_logic;
			a : in std_logic_vector(8 downto 0);
			dpra : in std_logic_vector(8 downto 0);
			di : in std_logic_vector(23 downto 0);
			spo : out std_logic_vector(23 downto 0);
			dpo : out std_logic_vector(23 downto 0)
			);
end component;

component fitness_memory_dual
	port (clk : in std_logic;
			we : in std_logic;
			a : in std_logic_vector(8 downto 0);
			dpra : in std_logic_vector(8 downto 0);
			di : in std_logic_vector(12 downto 0);
			spo : out std_logic_vector(12 downto 0);
			dpo : out std_logic_vector(12 downto 0)
			);
end component;

component best_transformation_register is
		port(clk ,ce: in std_logic;
	D: in std_logic_vector(23 downto 0);
	Q : out std_logic_vector(23 downto 0));
end component;



component map_mem is

port (clk : in std_logic;
			we : in std_logic;
			a : in std_logic_vector(17 downto 0);
			dpra : in std_logic_vector(17 downto 0);
			di : in std_logic_vector(7 downto 0);
			spo : out std_logic_vector(7 downto 0);
			dpo : out std_logic_vector(7 downto 0)
			);

end component;

component original_rom is

		port (clk: in std_logic;
				angle_index : in std_logic_vector(8 downto 0);
				scan_index: in std_logic_vector(9 downto 0);
				--addr_x :	  in std_logic_vector(8 downto 0);
				--addr_y :	 in std_logic_vector(8 downto 0);
				data_scan : out std_logic_vector(9 downto 0);
				data_x : out std_logic_vector(9 downto 0);
				data_y : out std_logic_vector(9 downto 0));

end component;



signal contr_init, contr_up, contr_cross, we_t_init, init_contr, up_contr, cross_contr, we_f, we_t_cm, we_t, we_f_up, we_m_map, up_best_ce, best_ce: std_logic;
signal popul_init,t_spo, t_dpo, data_t_init,data_t_cm,data_t, best_wr, best_r, up_best_wr: std_logic_vector(23 downto 0);
signal address_t_r_up_1, address_t_r_up_2: std_logic_vector(8 downto 0);
signal f_spo, f_dpo, f_di: std_logic_vector(12 downto 0);
signal address_f_wr_up: std_logic_vector(8 downto 0);
signal address_t_wr_init,address_t_wr_cm,address_f_r_cm_1, address_f_r_cm_2, address_t_r_cm, address_f_a, address_f_dpra, address_t_a, address_t_dpra: std_logic_vector(8 downto 0);
signal point_address_1_c, point_address_2_c, map_address_wr, map_address_rd: std_logic_vector(17 downto 0);

signal robotPose_x, robotPose_y: std_logic_vector(11 DOWNTO 0);
signal robotPose_theta: std_logic_vector(15 DOWNTO 0);
signal original : std_logic_vector(399 downto 0);
signal angle_index_fix, angle_index_map: std_logic_vector(8 downto 0);
signal address_m_a, address_m_dpra: std_logic_vector(17 downto 0);
signal m_din, data_m_map: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal we_m, contr_fix, contr_map: STD_LOGIC;
signal angle_index: STD_LOGIC_VECTOR(8 DOWNTO 0);
signal scan_index: STD_LOGIC_VECTOR(9 DOWNTO 0);
signal data_scan : std_logic_vector(9 downto 0);
signal data_x : std_logic_vector(9 downto 0);
signal data_y : std_logic_vector(9 downto 0);
signal m_spo, m_dpo : std_logic_vector(7 downto 0);
signal fix_contr, map_contr: std_logic;
--signal start_x, start_y: std_logic_vector(11 downto 0);
--signal point_value_1, point_value_2: std_logic_vector(7 downto 0);
--signal point_address_1,point_address_2 : std_logic_vector(15 downto 0);
--signal sin, cos: STD_LOGIC_VECTOR (11 downto 0);
--signal p: STD_LOGIC_VECTOR (12 downto 0);
--signal best: STD_LOGIC_VECTOR (12 downto 0);
--signal t: std_logic_vector (15 downto 0);
--signal i1x,i1y,i2x,i2y: STD_LOGIC_VECTOR (11 downto 0);
--signal posx : std_logic_vector (11 downto 0);
--signal posy : std_logic_vector (11 downto 0);
--signal t11,t12,t21,t22: std_logic_vector (21 downto 0);
--signal jj : std_logic_vector (4 downto 0);



begin
 
U1: initialise
port map (
			gotScans => contr_init,
			clk => clk,
			we => we_t_init,
			start => init_contr,
			popul_t => data_t_init,
			address	=> address_t_wr_init);


U2: test3
port map(
			update => contr_up,
			clk =>	clk,
		 	robot_x => robotPose_x,
			robot_y=> robotPose_y,
		   robot_theta=> robotPose_theta,
		   original	=>	 original,
		   person_in => t_spo,
		   person_in_2	=>	 t_dpo,
		   --start_x=>	 start_x,
		 	--start_y=>	 start_y,
		 	point_value_1=>	m_spo,
		 	point_value_2=>	m_dpo,
			address_in	=>	address_t_r_up_1,
		   address_in_2=>	  address_t_r_up_2,
		   --best=>		best,
		 	fitness_out=>	f_di,
		   address_out=> address_f_wr_up,
		   we=>	we_f_up,
		  	point_address_1=>	point_address_1_c,
		   point_address_2=>	point_address_2_c,
			up_best_ce=> up_best_ce,
		   up_best_wr=> up_best_wr,
				 
		 --sin=> sin,
		 --cos=> cos,
		  --p=> p,
		  --best=> best_fit,
		  --t=> t,
		  --i1x=> i1x,
		  --i1y => i1y,
		  --i2x => i2x,
		  --i2y => i2y,
		 -- posx => posx,
		  --posy => posy,
		 -- t11 =>  t11,
		 -- t12=> t12,
		 -- t21 => t21,
		 -- t22 => t22,
		 -- jj => jj,
		  cm=>up_contr
			
			
			
			);


U3: crossover_mutation_f
port map(clk =>  clk,
			cm=>	 contr_cross,
			person_t_in=>	t_dpo,
			person_fitness_1_in=> f_spo,
			person_fitness_2_in=> f_dpo,
			bT =>	best_r,
			address_t_wr=>	address_t_wr_cm,
			address_f_r_1=>	address_f_r_cm_1,
			address_f_r_2=>	 address_f_r_cm_2,
			address_t_r=>	 address_t_r_cm,
			person_t_out=>	  data_t_cm,
			finished=> cross_contr,
			we=>	we_t_cm	);


U4: fitness_memory_dual
port map(clk => clk,
			we =>	we_f,
			a => address_f_a,
			dpra => address_f_dpra,
			di =>	 f_di,
			spo =>f_spo, 
			dpo =>f_dpo);


U5: t_memory_dual
port map(clk => clk,
			we =>	we_t,
			a => address_t_a,
			dpra =>  address_t_dpra,
			di =>	 data_t,
			spo =>t_spo, 
			dpo =>t_dpo);


U6: controller
port map(clk => clk,
			rst =>rst, 
			run => run,
			init_done => init_contr, 
			up_done => up_contr, 
			cm_done=>cross_contr,
			fix_done=>fix_contr,
			map_done=>map_contr,
			up_best_ce => up_best_ce,
			address_t_wr_init=>address_t_wr_init, 
			address_t_r_up_1=>address_t_r_up_1, 
			address_t_r_up_2=>address_t_r_up_2, 
			address_f_wr_up=>address_f_wr_up, 
			address_t_r_cm=>address_t_r_cm, 
			address_t_wr_cm=>address_t_wr_cm, 
			address_f_r_cm_1=>address_f_r_cm_1, 
			address_f_r_cm_2=>address_f_r_cm_2,
			angle_index_fix => angle_index_fix,
			angle_index_map => angle_index_map,
			address_m_rd1_up => point_address_1_c, 
			address_m_rd2_up => point_address_2_c, 
			address_m_wr_map => map_address_wr, 
			address_m_rd_map => map_address_rd,
			data_t_init=>data_t_init, 
			data_t_cm=>data_t_cm,
			up_best_wr => up_best_wr,
			data_m_map => data_m_map,
			we_t_init=>we_t_init, 
			we_t_cm=>we_t_cm,
			we_f_up=>we_f_up,
			we_m_map=>we_m_map,
			Q => best_r,
			address_t_a=>address_t_a, 
			address_t_dpra=>address_t_dpra, 
			address_f_a=>address_f_a, 
			address_f_dpra=>address_f_dpra,
			address_m_a=>address_m_a, 
			address_m_dpra=>address_m_dpra,
			data_t=>data_t,
			data_m=>m_din,
			we_t=>we_t, 
			we_f=>we_f,
			we_m=>we_m,
			fix_start => contr_fix, 
			map_start => contr_map,
			init_start=>contr_init, 
			up_start=>contr_up, 
			cm_start=>contr_cross, 
			--valid=>valid,
			best_ce=>best_ce,
			best_wr=>best_wr,
			robotPose_x => robotPose_x, 
			robotPose_y => robotPose_y,
			robotPose_theta => robotPose_theta,
			angle_index => angle_index,	
			scan_index =>scan_index
			);

U7: best_transformation_register			 ----timing allagi!!!!!!!
port map(clk => clk,
			ce => best_ce,
			D => best_wr,
			Q => best_r);

U8: map_update
port map(clk => clk,
			mu=> contr_map,
			original_value_x=> data_x,
			original_value_y=> data_y,
			original_value_scan=> data_scan,
			robot_pose_x=> robotPose_x,
			robot_pose_y=> robotPose_y,
			robot_pose_theta=> robotPose_theta,
			map_value_rd=> m_dpo,
						
			original_address=> angle_index_map,
			map_value_wr=> data_m_map,
			map_address_rd=> map_address_rd,
			map_address_wr=> map_address_wr, 
			map_we=> we_m_map,
			finished=> map_contr
			
			--value_t: out std_logic_vector(12 downto 0);
			--cos_out_t: out std_logic_vector(11 downto 0);
			--sin_out_t: out std_logic_vector(11 downto 0);
			--measid_t: out std_logic_vector(8 downto 0);
			--measid_2_t: out std_logic_vector(8 downto 0);
			--R_t: out std_logic_vector(6 downto 0);--unsigned(6 downto 0) :=0;
			--cos_t: out std_logic_vector(11 downto 0);
			--sin_t: out std_logic_vector(11 downto 0);
			--cos_sum_t: out std_logic_vector(21 downto 0);
			--sin_sum_t: out std_logic_vector(21 downto 0);
			--cos_sum_special_t: out std_logic_vector(21 downto 0);
			--sin_sum_special_t: out std_logic_vector(21 downto 0);
			--xpoint_t, ypoint_t: out std_logic_vector(11 downto 0);
			--tt_t: out std_logic_vector(7 downto 0)	;		
			--temp_t: out std_logic_vector(19 downto 0)	
			);

U9: map_mem
port map(	
			clk =>clk,
			we => we_m,
			a  => address_m_a,
			dpra => address_m_dpra,
			di =>m_din,
			spo => m_spo,
			dpo => m_dpo
);

U10: original_rom
port map(
			clk => clk, 
			angle_index => angle_index,
			scan_index => scan_index,
			data_scan => data_scan,
			data_x => data_x,
			data_y => data_y
);

U11: fix_original
port map(
				clk => clk,
				start => contr_fix,
				data_x => data_x,
				data_y =>data_y,
				angle_index => angle_index_fix,
				original => original,
				finished => fix_contr	 
);






r_x<=robotPose_x;
r_y<=robotPose_x;
r_theta<=robotPose_theta ;
--init_start <= contr_init;
--up_start<= contr_up;
--cm_start<= contr_cross;
--init_done<=init_contr;
--up_done<=up_contr;
--cm_done<=cross_contr;
--best_trans <= best_r;
--
--
--init_data<=data_t;
--person1<=t_spo;
--person2<=t_dpo;
--address1<=address_t_r_up_1;
--address2<=address_t_r_up_2;
--fit_out<=f_di;
--fit_addr<=address_f_a;
--fit_we<=we_f ;
--b_ce<=up_best_ce;
--b_data<=up_best_wr;
--Q<=best_r;
--a1<=address_t_a;
--a2<=address_t_dpra;





--t_we_test <=	we_t;
--t_a_test <= address_t_a;
--t_dpra_test <=  address_t_dpra;
--person_t_in_test<= t_dpo;
--person_t_out_test <= data_t; 
--		
--person_fitness_1_in_test <= f_spo;
--person_fitness_2_in_test <= f_dpo;
--f_a_test<= address_f_a;
--f_dpra_test<= address_f_dpra;
--
--f_a_test_2<= address_f_r_cm_1;
--f_dpra_test_2 <= address_f_r_cm_2;
end Behavioral;