----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:49:48 01/03/2010 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

entity controller is

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

end controller;

architecture Behavioral of controller is

	TYPE state IS (standby, standby_b, initialise, initialise_b, counter_0, best_0, fix_original, fix_original_b, update, update_b, cm, cm_b, counter_inc, counter_check, update_pose, update_map, update_map_b, new_scan);
	SIGNAL pr_state, nx_state: state;
	SIGNAL address_t_a_temp, address_t_dpra_temp, address_f_a_temp, address_f_dpra_temp: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL address_m_a_temp, address_m_dpra_temp: STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL data_t_temp, best_wr_temp: STD_LOGIC_VECTOR(23 DOWNTO 0);
	SIGNAL data_m_temp: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL we_t_temp, we_f_temp, we_m_temp, valid_temp, init_start_temp, fix_start_temp, up_start_temp, cm_start_temp, map_start_temp, best_ce_temp: STD_LOGIC;
	SIGNAL angle_index_temp: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL address_dead: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL data_dead: STD_LOGIC_VECTOR(23 DOWNTO 0);
	SIGNAL robotPose_x_in, robotPose_y_in: std_logic_vector(11 downto 0):="000000000000";
	SIGNAL robotPose_theta_in: std_logic_vector(15 downto 0):="0000000000000000";
	SIGNAL counter: integer RANGE 0 to 50;
	SIGNAL scan_counter: integer RANGE 0 to 500 :=0;	

	BEGIN
	
	address_dead <= "000000000";
	data_dead <= "000000000000000000000000";
	robotPose_x<=robotPose_x_in;
	robotPose_y<=robotPose_y_in;
	robotPose_theta<=robotPose_theta_in;
	scan_index <= conv_std_logic_vector(scan_counter,10);
	--data_t<=conv_std_logic_vector(counter,32) ;
	----- Lower section: ----------------------
	PROCESS (rst, clk)
		BEGIN
		IF (rst='1') THEN
			pr_state <= standby;
		ELSIF (clk'EVENT AND clk='1') THEN
			address_t_a <= address_t_a_temp;
			address_t_dpra <= address_t_dpra_temp;
			address_f_a <= address_f_a_temp;
			address_f_dpra <= address_f_dpra_temp;
			address_m_a <= address_m_a_temp;
			address_m_dpra <= address_m_dpra_temp;
			data_t <= data_t_temp;
			data_m <= data_m_temp;
			angle_index <= angle_index_temp;
			we_t <= we_t_temp;
			we_f <= we_f_temp;
			we_m <= we_m_temp;
			init_start <= init_start_temp;
			up_start <= up_start_temp;
			cm_start <= cm_start_temp;
			best_ce <= best_ce_temp;
			best_wr <= best_wr_temp;
			valid <= valid_temp;
			fix_start <= fix_start_temp;
			map_start <= map_start_temp;
			pr_state <= nx_state;
		END IF;
	END PROCESS;
	---------- Upper section: -----------------
	PROCESS (address_t_wr_init, address_t_r_up_1, address_t_r_up_2, address_f_wr_up, address_t_r_cm, address_t_wr_cm, address_f_r_cm_1, address_f_r_cm_2, data_t_init, data_t_cm, we_t_init, we_t_cm, run, init_done, up_done, cm_done, fix_done, map_done, up_best_ce, up_best_wr, we_f_up, we_m_map, Q, address_m_rd1_up, address_m_rd2_up, address_m_rd_map, address_m_wr_map, angle_index_fix, angle_index_map, data_m_map, pr_state)
		BEGIN
		CASE pr_state IS
			WHEN standby =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '1';
									fix_start_temp <= '0';
									map_start_temp <= '0';
									--IF (run='1') THEN nx_state <= standby_b;
									--ELSE nx_state <= standby;
									--END IF;
									nx_state <= standby_b;
									
			WHEN standby_b =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '1';
									fix_start_temp <= '0';
									map_start_temp <= '0';
									--IF (run='0') THEN nx_state <= initialise;
									--ELSE nx_state <= standby_b;
									--END IF;
									nx_state <= initialise;
									
			WHEN initialise =>
									address_t_a_temp <= address_t_wr_init;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_t_init;
									angle_index_temp <= address_dead;
									we_t_temp <= we_t_init;
									we_f_temp <= '0';
									init_start_temp <= '1';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';
									map_start_temp <= '0';
									IF (init_done='1') THEN nx_state <= initialise_b;
									ELSE nx_state <= initialise;
									END IF;
									
			WHEN initialise_b =>
									address_t_a_temp <= address_t_wr_init;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_t_init;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';
									map_start_temp <= '0';
									IF (init_done='0') THEN nx_state <= fix_original;
									ELSE nx_state <= initialise_b;
									END IF;

			WHEN fix_original =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= angle_index_fix;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '1';
									map_start_temp <= '0';
									IF (fix_done='1') THEN nx_state <= fix_original_b;
									ELSE nx_state <= fix_original;
									END IF;

		WHEN fix_original_b =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';									
									IF (fix_done='0') THEN nx_state <= counter_0;
									ELSE nx_state <= fix_original_b;
									END IF;

									
			WHEN counter_0 =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';
									map_start_temp <= '0';
									counter <= 0;
									nx_state <= best_0;
			
			WHEN best_0 =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '1';
									best_wr_temp <= "000000000000000000000000";
									valid_temp <= '0';
									fix_start_temp <= '0';
									map_start_temp <= '0';
									nx_state <= update;
	 								
														
			WHEN update =>
									address_t_a_temp <= address_t_r_up_1;
									address_t_dpra_temp <= address_t_r_up_2;
									address_f_a_temp <= address_f_wr_up;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<=address_m_rd1_up;
									address_m_dpra_temp<=address_m_rd2_up;
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= we_f_up;
									init_start_temp <= '0';
									up_start_temp <= '1';
									cm_start_temp <= '0';
									best_ce_temp <= up_best_ce;
									best_wr_temp <= up_best_wr;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									IF (up_done='1') THEN nx_state <= update_b;
									ELSE nx_state <= update;
									END IF;
									
			WHEN update_b =>
									address_t_a_temp <= address_t_r_up_1;
									address_t_dpra_temp <= address_t_r_up_2;
									address_f_a_temp <= address_f_wr_up;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '1';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									IF (up_done='0') THEN nx_state <= cm;
									ELSE nx_state <= update_b;
									END IF;
									
			WHEN cm =>
									address_t_a_temp <= address_t_wr_cm; 
									address_t_dpra_temp <= address_t_r_cm;
									address_f_a_temp <= address_f_r_cm_1;
									address_f_dpra_temp <= address_f_r_cm_2;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_t_cm;
									angle_index_temp <= address_dead;
									we_t_temp <= we_t_cm;
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '1';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									IF (cm_done='1') THEN nx_state <= cm_b;
									ELSE nx_state <= cm;
									END IF;
									
			WHEN cm_b =>
									address_t_a_temp <= address_t_wr_cm; 
									address_t_dpra_temp <= address_t_r_cm;
									address_f_a_temp <= address_f_r_cm_1;
									address_f_dpra_temp <= address_f_r_cm_2;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_t_cm;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '1';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									IF (cm_done='0') THEN nx_state <= counter_inc;
									ELSE nx_state <= cm_b;
									END IF;
									
			WHEN counter_inc =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									counter <= counter+1;
									nx_state <= counter_check;
									
			WHEN counter_check =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									IF (counter = 30) THEN 
									counter <= 0;
									nx_state <= update_pose;
									ELSE nx_state <= best_0;
									END IF;
		WHEN update_pose =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									robotPose_x_in<=robotPose_x_in+Q(4 downto 0);
									robotPose_y_in<=robotPose_y_in+Q(9 downto 5);
									robotPose_theta_in<=robotPose_theta_in+Q(23 downto 10);
									nx_state <= update_map;

		WHEN update_map =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<=address_m_wr_map;
									address_m_dpra_temp<=address_m_rd_map;
									data_m_temp <= data_m_map;
									we_m_temp <= we_m_map;
									data_t_temp <= data_dead;
									angle_index_temp <= angle_index_map;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '1';									
									IF (map_done='1') THEN nx_state <= update_map_b;
									ELSE nx_state <= update_map;
									END IF;

		WHEN update_map_b =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									map_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '1';
									IF (map_done='0') THEN nx_state <= new_scan;
									ELSE nx_state <= update_map_b;
									END IF;

		WHEN new_scan =>
									address_t_a_temp <= address_dead;
									address_t_dpra_temp <= address_dead ;
									address_f_a_temp <= address_dead;
									address_f_dpra_temp <= address_dead;
									address_m_a_temp<="000000000000000000";
									address_m_dpra_temp<="000000000000000000";
									data_m_temp <= "00000000";
									we_m_temp <= '0';
									data_t_temp <= data_dead;
									angle_index_temp <= address_dead;
									we_t_temp <= '0';
									we_f_temp <= '0';
									init_start_temp <= '0';
									up_start_temp <= '0';
									cm_start_temp <= '0';
									best_ce_temp <= '0';
									best_wr_temp <= data_dead;
									valid_temp <= '0';
									fix_start_temp <= '0';	 
									map_start_temp <= '0';
									scan_counter <= scan_counter+1;
									nx_state <= standby;
																		
												
									
		END CASE;
	END PROCESS;


end Behavioral;