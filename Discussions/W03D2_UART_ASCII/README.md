## W03 Jan 29 (D2) Receive ASCII codes via RS232 and display them on the Basys-3 leds

**Tasks:**

* Create a Vivado project for the UART and simulate to make sure that everything is correct.
* Program the FPGA, and use HyperTerminal or PuTTY to set up the serial communication channel for 19200 bps, 1 stop bit, no parity, and flow control = "None"

>You should now see the Basys-3 leds displaying the ASCII codes of any keys pressed on your keyboard.

---

*Universal asynchronous receiver and transmitter* (UART) is a circuit that sends parallel data through a serial line. 
A UART includes a transmitter (tx) and a receiver (rx). The transmitter is a special shift register that loads data in parallel and then shifts it out bit by bit at a specific rate. The receiver shifts in data bit by bit and then reassembles the data. 

* The serial line is '1' when it is idle. 
* The transmission starts with a start bit, which is '0', followed by data bits and an optional parity bit, and ends with stop bits, which are '1'. 
* The number of data bits can be 6, 7, or 8. 
* The optional parity bit is used for error detection. For odd parity, it is set to ’0’ when the data bits have an odd number of 1’s. For even parity, it is set to ’0’ when the data bits have an even number of 1’s.

<img src="https://github.com/deivyka/SHC4300/blob/master/Discussions/W03D2_UART_ASCII/0.%20IMAGES/uart.png" alt="drawing" width="450" height="125"/>


The transmission with 8 data bits, no parity, and 1 stop bit is shown in the figure above. The LSB of the data word is transmitted first. Before the transmission starts, the tx and rx must agree on a set of parameters in advance, which include the baud rate (e.g. 19200 bps), the number of data bits and stop bits, and use of the parity bit.

<img src="https://github.com/deivyka/SHC4300/blob/master/Discussions/W03D2_UART_ASCII/0.%20IMAGES/block_diagram.jpg" alt="drawing" width="550" height="225"/>

>Figure above.

* Baud rate generator (mod-M counter): the circuit to generate the sampling ticks.
* UART receiver: the circuit to obtain the data word via oversampling.
* Interface circuit: the circuit that provides buffer and status between the UART receiver and the system that uses the UART.


---
#### Baud rate generator and oversampling procedure
The most commonly used sampling rate is 16 times the baud rate, which means that each serial bit is sampled 16 times.
The oversampling scheme basically performs the function of a clock signal. Instead of using the rising edge to indicate when the input signal is valid, it utilizes sampling ticks to estimate the middle point of each bit. While the receiver has no information about the exact onset time of the start bit, the estimation can be off by at most 1/16. 

The baud rate generator generates a sampling signal whose frequency is exactly 16 times the UART’s designated baud rate. For the 19200 baud rate, the sampling rate has to be 307200 (19200 * 16) ticks/s. Since the system clock rate is 100 MHz, the baud rate generator needs a mod-326 (100 MHz / 307200) counter, in which the one-clock-cycle tick is asserted once every 326 clock cycles.

---
#### UART receiver
Since no clock information is conveyed from the transmitted signal, rx can retrieve the data bits only by using the predetermined parameters. We use an oversampling scheme to estimate the middle points of transmitted bits and then retrieve them at these points accordingly.


---
#### ASMD Chart
<img src="https://github.com/deivyka/SHC4300/blob/master/Discussions/W03D2_UART_ASCII/0.%20IMAGES/ASMD_UART.png">

**Source: FPGA Prototyping by VHDL Examples, Pong P. Chu**

---
## Replication instructions

#### To be able to reproduce simulation shown in Simualtion picture at the bottom of the page, the steps above should be followed.

1. Download the appropriate files and add these to your new project.
2. Synthesize the project, after it is finished, add waveform configuration file attached in Simulation folder.
3. To test this solution in practice, Basys-3 board is needed. Generate bitstream in Vivado before proceeding to the next step.
4. Find the right communication port: For Windows users we can find appropriate USB connection port in Device Manager, as shown in Device Manager picture above.
5. Further, as shown in Putty picture above, the RS-232 communication between the virtual port and Basys-3 board can be established in putty terminal manager.
6. Program device and test it yourself.

----
![Device Manager](https://github.com/deivyka/SHC4300/blob/master/Discussions/W03D2_UART_ASCII/0.%20IMAGES/device_manager.PNG)
>Device Manager

----
![Putty](https://github.com/deivyka/SHC4300/blob/master/Discussions/W03D2_UART_ASCII/0.%20IMAGES/putty.PNG)
>Putty

----
![Simulation](https://github.com/deivyka/SHC4300/blob/master/Discussions/W03D2_UART_ASCII/0.%20IMAGES/simulation.PNG)
>Simulation

