## CCW4 Sorting Algorithm Implementation in Vivado HLS
#### Group 2: Biplav, Deivy, Leila, Victor
 
### Summary
---

The HLS solution includes numerous files. Header file `sort_merge_8bit_head.h` includes definitions needed for the functions defined in `sort_merge_8bit_function.c` file.
Further a test bench file `sort_merge_8bit_tb.c` is used to test the solution by reading the unsorted array from `unsorted.dat` file, 
storing the sorted array in `sorted_result.dat` file and finally letting the system to compare pre-sorted array as defined 
in `sorted_defined.dat` file with `sorted_result.dat` file to check if the solution sorts the array as expected.
 
---
### Follow the steps bellow to recreate this project for Zybo board

#### Requirements

- Zybo Board files **must** be placed in appropriate directory before proceeding
- For how to add the board files see Digilent guide -> [Installing Vivado Board Files for Digilent Boards](https://reference.digilentinc.com/reference/software/vivado/board-files?redirect=1)


#### Creating a new project in Vivado HLS environment

- Open Vivado HLS 2019.1 to create a new project
  - Create a new project and give it a project name of your choice
  - In **Add/Remove Files** window select **Add Files...** tab (Top Function)
  - Browse to HLS folder downloaded from this repository
  - Browse to Sort_Merge solution folder and add these files
    - `sort_merge_8bit_function.c`
    - `sort_merge_8bit_head.h`
  - Back in **Add/Remove Files** window select **Browse...** tab in order to select Top Function
      - Select `mergeSort (sort_merge_8bit_function.c)`
    - Press Next
  - In **Add/Remove Files** window select **Add Files...** tab (TestBench Files)
    - Browse to Sort_Merge solution folder and add these files
      - `sort_merge_8bit_tb.c`
      - `sorted_defined.dat`
      - `sorted_result.dat`
      - `unsorted.dat`
    - Press Next
  - In **Part Selection** section press **...** button
  - Press **Boards** tab and search for **Zybo**
  - Select the Zybo board and press **OK**
  - Press Finish


#### Synthesizing, Co-simulating and exporting the solution as IP block 

- In Vivado HLS 2019.1
  - In top section of the projects window, press **Solution** and select **Run C Synthesis**
  - The report generated is giving some estimates for the solution
  - In top section of the projects window, press **Run C/RTL Cosimulation**
    - In RTL Selection choose **VHDL** and press **OK**
  - Cosimulation report should give a `Pass` result in the **Status** section
    - By clicking on `Pass` will open a log file for the simulation
  - In top section of the projects window, press **Solution** and select **Export RTL**
    - In **Evaluate Generated RTL** section, select **VHDL** 
    - Press **OK**


#### Creating a new project, adding IP and creating Block Design in Vivado

- Open Vivado 2019.1
  
  ##### Create a project
  - Select **Create Project**
      - Give it a project name of your choice
      - Select a location for the project
    - Press **Next**
    - Press **Next**
    - In **Default Part** section press on **Boards** tab
    - Search for **Zybo** and select the board
    - Press **Next**
    - Press **Finish**
  
  ##### Add HLS IP solution to IP Catalog
  - In **Flow Navigator** section
    - Press **PROJECT MANAGER**
      - Press **IP Catalog**
      - In the appeared window, right mouse click and select **Add Repository...**
      - Browse to HLS solution folder
      - Expand Solution folder
      - Expand **solution_1** folder
      - Expand **impl** folder
      - Press on **ip** folder and press **Select**
      - In pop-up window press **OK**
      - In **IP Catalog** window you should now see a **User Repository** section
      - Expand all the sections and check that the **Mergesort** is available
  
  ##### Create Block Design
  - In **Flow Navigator** section
    - Press **IP INTEGRATOR**
    - Press **Create Block Design**
      - Give it a name and press **OK**
    - Select **Sources** tab and in **Design Sources** section double click on the design name defined
    - In **Diagram** window appeared press **+** button to add IP
      - In the search box look for **ZYNQ7 Processing System** and double click on it
      - Again in the search box look for **Mergesort** and double click on it
    - Press **Run Block Automation** and press **OK**
    - Press **Run Connection Automation** and press **OK**

##### At this point you should have a HLS IP block in a new Vivado project

#### Future work: Communication between Vivado SDK and generated HLS IP block
