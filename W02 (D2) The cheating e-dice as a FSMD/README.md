# FSMD-based-e-dice with different cheating modes

### The block diagram represented below corresponds to a FSMD architecture that implements the functional requirements of a cheating electronic dice.

![FSMD](https://github.com/deivyka/SHC4300/blob/master/IMAGES/w2d2%20FSMD%20e-dice%20Jose.png)

- Assume that only two operating modes are supported: no cheating, and triple probability for the result specified by inputs “result(2:0)”. Present an ASMD chart that illustrates the behaviour of this FSMD. N.B.: In this case, “mode” is a single input that defines the no-cheating mode when at ‘0’, and the triple probability mode when at ‘1’.

- Make all appropriate corrections and / or simplifications to the ASMD chart represented below, which is supposed to illustrate the behaviour of the architecture represented above, when supporting four operating modes (“00”: no-cheating; “01”: forbidden result; “10”: predefined result; “11”: triple probability).  

- Build the corresponding VHDL description and prove that your solution works by showing simulation results in Vivado.

![ASMD Chart](https://github.com/deivyka/SHC4300/blob/master/IMAGES/w2d2%20ASMD%20e-dice%20Jose.png)


### Solution ASMD Chart for triple probability
![ASMD Chart](https://github.com/deivyka/SHC4300/blob/master/IMAGES/w2d2%20ASMD%20e-dice%20with%20triple%20prob.png)

### Solution ASMD Chart for different modes
![ASMD Chart](https://github.com/deivyka/SHC4300/blob/master/IMAGES/w2d2%20ASMD%20e-dice%20with%20modes.png)

#### Following files must be compiled in order to run and simulate e-dice solution for triple probability mode:

- FSMD e-dice with triple probability/fsmd_e_dice_triple_probability.vhd
- FSMD e-dice with triple probability/fsmd_e_dice_triple_probability_TB.vhd
- FSMD e-dice with triple probability/fsmd_e_dice_triple_probability_Basys_3_Constrain.xdc

#### Following files must be compiled in order to run and simulate e-dice solution for multiple cheating modes:

- FSMD e-dice with modes/fsmd_e_dice_modes.vhd
- FSMD e-dice with modes/fsmd_e_dice_modes_TB.vhd
- FSMD e-dice with modes/fsmd_e_dice_modes_Basys_3_Constrain.xdc
