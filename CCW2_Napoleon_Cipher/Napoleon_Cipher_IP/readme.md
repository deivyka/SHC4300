## CCW2 Napoleon Cipher IP - Step-by-step Guide
#### Group 2: Biplav, Deivy, Leila, Victor

---

#### Hardware Configuration in Vivado environment

- Connect Zybo board to your computer and switch the power on
- Open Vivado 2019.1 to create a new project
  - Create a new project and give it a name of your choice
  - In **Default Part** window select **Boards** tab and search for **Zybo**
  - Select the board → **Finish**

---

#### Create AXI peripheral
 - Tools → Create and Package New IP... → Next → 
 - Create a new AXI4 peripheral → Next → Next → Next → Edit IP → Finish 
 - A new window opens → open `myip_v1_0_S00_AXI.vhd`
    - Comment out slave register 1:
 ```vhdl
 ---...
 process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	     -- slv_reg1 <= (others => '0');
	      slv_reg2 <= (others => '0');
	      slv_reg3 <= (others => '0');
	    else 
      --- ...
  --- ...
  when b"01" =>
	  for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	    if ( S_AXI_WSTRB(byte_index) = '1' ) then
	      -- Respective byte enables are asserted as per write strobes                   
	      -- slave registor 1
	      -- slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	    end if;
	  end loop;
  when b"10" =>
  --- ...
 ```
 - And add the following:
 ```vhdl
 	-- Add user logic here
	   slv_reg1 <= X"0D" when slv_reg0 = X"0D" or slv_reg0 = X"0A" else
                   std_logic_vector(((25 - unsigned(slv_reg0) + unsigned(slv_reg2)) mod 26) + 97);
	-- User logic ends
  
end arch_imp;
 ```
 - Save the file → Go to Package IP tab → File Groups → Merge changes from File Groups Wizard.
 - Review and Package → Re-Package IP → Click 'Yes' in the Close Project window.
 
 ---
 
 #### Create Block Design
 - Create Block Design → OK → Click on the '+'-symbol within the empty Diagram window.
 - Add the ZYNQ7 Processing System → Run Block Automation → OK
 - Add your new IP block to the diagram → Run Connection Automation → OK
 - Click on the '✓'-symbol to validate the design.
 
 ---
 
 #### Create HDL wrapper  
 - In **IP INTEGRATOR** select **Sources** tab
    - Expand **Design Sources**, right click on your design name and select **Create HDL Wrapper...**
    - Select **Let Vivado manage wrapper and auto-update** → **OK**
    - Click on **OK** to ignore the critical error (This does have no effect for our design)
 
 ---
 
- Generate Bitstream and export the hardware
  - In **PROGRAM AND DEBUG** select **Generate Bitstream**
  - After Bitstream is generated, in upper-leftmost corner click on **File** → **Export** → **Export Hardware**
    - Mark **Include Bitstream** box and click **OK**

---

#### Software implementation in Xilinx SDK environment

- Launch SDK
  - In upper-leftmost corner click on **File** → **Launch SDK** → **OK**

- Create a new application
  - In upper-leftmost corner of the environment click **File**, hover on **New** → **Application Project**
    - Give a project a name of your choice, leave the rest as default → **Finish**
  - Wait till SDK is finished with building the workspace

- Program FPGA
  - In top section of the environment press **Xilinx** → **Program FPGA**
    - Keep default settings → **Program**

- Connect to Zybo board
  - Click on **SDK Terminal** tab (bottom of the environment)
    - Click on green **+** button to connect to a serial port
      - Select appropriate communication port for Zybo board
      - Set **Baud Rate** to 115200 → OK

- Paste provided code
  - In **Project Explorer** workspace, expand newly created projects folder
    - Expand **src** folder
      - Double click on **helloworld.c**
      - Copy and paste the `napoleon_cipher_ip.c` code provided in `SHC4300/CCW2_Napoleon_Cipher/Napoleon_Cipher_IP/`

- Run provided code
  - In **Project Explorer** workspace
    - Right mouse click on created projects folder and hover to **Run As** → **1 Launch on Hardware (System Debugger)**
  - Click on **SDK Terminal** tab (bottom of the environment)
    - Send characters in the dedicated box
