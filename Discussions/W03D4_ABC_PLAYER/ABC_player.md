### W03 (D4) Datapath of the ABC player FSMD

Consider a sequence of ASCII codes representing musical notes that need to be stored in a RAM with the objective of controlling the frequency of a square wave output. The UART, the RAM block, and the programmable waveform generator, are all part of the datapath of the FSMD represented below. The behaviour of the circuit may be described as follows:

* The output will remain at logic ‘0’ until a rising edge is detected in the “Play” input.
* Once the ”Play” input is activated, the square wave output starts with a frequency defined by the content of the first memory position.
* After 0.5 sec. the frequency of the square wave changes to the value defined by the second memory position.
* The process repeats itself up to the last code, and the output will revert to logic ‘0’ afterwards.
 
 
 #### Proposed Block Diagram
![mydiag](D4_ABC/diagram/D4_block_diagram.png)

