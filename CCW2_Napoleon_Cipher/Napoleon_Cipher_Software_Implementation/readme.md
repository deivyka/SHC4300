## CCW2 Napoleon Cipher as Software Implementation
#### Group 2: Biplav, Deivy, Leila, Victor
 
 
### Follow steps bellow to recreate this project for Zybo board

---

#### Hardware Configuration in Vivado environment

- Connect Zybo board to your computer and switch the power on
- Open Vivado 2019.1 to create a new project
  - Create a new project and give it a name of your choice
  - In **Default Part** window select **Boards** tab and search for **Zybo**
  - Select the board and click **Finish**

- Create Zynq IP block with HDL wrapper
  - In **IP INTEGRATOR** select **Create Block Design**
    - Give a new design a name of your choice and click **OK**
  - In **Diagram** window on the right
    - Press **+** button and search for **ZYNQ7** and double click on ZYNQ7 Processing System
    - Press **+** button and search for **GPIO** and double click on AXI GPIO
    - Click **Run Block Automation**, make sure upper-leftmost box for **All Automation** is selected and click **OK**
    - Click **Run Connection Automation**, make sure upper-leftmost box for **All Automation** is selected and click **OK**
    - In upper-leftmost corner of the environment click **File** and click on **Save Block Design**
  - In **IP INTEGRATOR** select **Sources** tab
    - Expand **Design Sources**, right click on your design name and select **Create HDL Wrapper...**
    - Select **Let Vivado manage wrapper and auto-update** and click **OK**
    - Click on **OK** to ignore the critical error (This does have no effect for our design)
  
- Generate Bitstream and export the hardware
  - In **PROGRAM AND DEBUG** select **Generate Bitstream**
  - After Bitstream is generated, in upper-leftmost corner click on **File**, hover on **Export** and select **Export Hardware**
    - Mark **Include Bitstream** box and click **OK**

- Launch SDK
  - In upper-leftmost corner click on **File**, click on **Launch SDK** and click **OK**


#### Software implementation in Xilinx SDK environment

- Create a new application
  - In upper-leftmost corner of the environment click **File**, hover on **New** and click **Application Project**
    - Give a project a name of your choice, leave the rest as default and click **Finish**
  - Wait till SDK is finished with building the workspace

- Program FPGA
  - In top section of the environment press **Xilinx** and press on **Program FPGA**
    - Leave settings as default and click **Program**

- Connect to Zybo board
  - Click on **SDK Terminal** tab (bottom of the environment)
    - Click on green **+** button to connect to a serial port
      - Select appropriate communication port for Zybo board
      - Set **Baud Rate** to 115200
      - Press **OK**

- Paste provided code
  - In **Project Explorer** workspace, expand newly created projects folder
    - Expand **src** folder
      - Double click on **helloworld.c**
      - Copy and paste the NapoleonCipher_zybo.c code provided in SHC4300/CCW2_Napoleon_Cipher/Napoleon_Cipher_Software_Implementation/
  - In upper-leftmost corner of the environment click **File** and click on **Save**

- Run provided code
  - In **Project Explorer** workspace
    - Right mouse click on created projects folder and hover to **Run As**, click on **1 Launch on Hardware (System Debugger)**
  - Click on **SDK Terminal** tab (bottom of the environment)
    - Send characters in the dedicated box
