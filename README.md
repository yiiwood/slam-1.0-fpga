# SMG-SLAM algorithm in VHDL (FPGA implementation)

This repository includes code that implements the SMG-SLAM algorithm in VHDL. The code can be used to map the algorithm on an FPGA chip in order to achieve one order of magnitude speedup compared to a the C++ implementation. SMG-SLAM is a simultaneous localization and mapping algorithm for mobile robots. It is based on matching measurements from the sensors of the robot to the existing map in order to update both the position of the robot and the map. This process is also known as registration. It works based on a genetic algorithm. The genetic algorithm finds the optimal position of the robot at each time step based on the given measurements from the sensors.

Publication: Grigorios Mingas, Emmanouil Tsardoulias, and Loukas Petrou. 2012. An FPGA implementation of the SMG-SLAM algorithm. Microprocess. Microsyst. 36, 3 (May 2012), 190-204. DOI=http://dx.doi.org/10.1016/j.micpro.2011.12.002

This code is part of the Pandora mobile rescue robot project (Department of Electrical and Computer Engineering, Aristotle University of Thessaloniki). Copyright Grigorios Mingas 2010-2012.
