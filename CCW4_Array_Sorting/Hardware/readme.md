## Hardware based array sorting

This parallel sorting algorithm is based on:

* https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/

* https://github.com/Poofjunior/fpga_fast_serial_sort


This solution handles repeating numbers and sorts arrays of unsigned 8-bit data from size 0 up to N, where N is the total number of sorting cells that we’ve synthesize onto an FPGA. Time complexity for the implemented algorithm is `O(n)`.

----

When the sorting begins all cells are empty. We begin by inserting a new element, this new element is the smallest we've seen so far, so it's going to be inserted into the first cell.

<img src="images/linsort1.png" alt="drawing" width="500"/>

<img src="images/linsort2.png" alt="drawing" width="500"/>

<img src="images/linsort3.png" alt="drawing" width="500"/>

• If a cell is empty, it will claim the incoming element if the above cell is occupied.

• If a cell is occupied, it will claim the incoming element if the incoming element is less than the stored element AND the occupied cell above this cell is not pushing out its element.

• If the cell above the current cell pushes out it’s element, then the current cell MUST claim the above cell’s element, regardless of whether or not the current cell is empty or occupied.

• If a cell is occupied and accepts a new element (either from the above cell or from the incoming data), it must push out its current element.

----
#### Schematic

We read the unsigned 8-bit data (numbers from 0 to 255) from a `2^6-by-8` ROM. `memory_ctrl` increments the ROM address.

<img src="images/SCH1.PNG" alt="drawing" width="850"/>


##### Inside `Sort top`
<img src="images/SCH2.PNG" alt="drawing" width="850"/>
For the first cell `pre_data` is set to [0..0] since this is the first cell, and no previous data exists.

<img src="images/SCH3.PNG" alt="drawing" width="850"/>

For the last cell we connect `nxt_data` to the `sorted_data` output.


----
#### Testbench
<img src="images/TB1.PNG" alt="drawing" width="850"/>

<img src="images/TB2.PNG" alt="drawing" width="850"/>

<img src="images/TB3.PNG" alt="drawing" width="850"/>

<img src="images/TB4.PNG" alt="drawing" width="850"/>

----
#### Synthesis report
<img src="images/SUMMARY.PNG" alt="drawing" width="550"/>

<img src="images/POWER.PNG" alt="drawing" width="550"/>
