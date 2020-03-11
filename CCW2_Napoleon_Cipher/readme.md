We use lower-case ASCII, (a=97, z=122). 


The key = "Jean-Jacques Rousseau" will be hardcoded in the FPGA, i.e. the user can not change the key, only the message.
The message and the ciphertext will be sent through RS232. We need a UART receiver and transmitter. It is possible to encrypt a message into ciphertext, and decrypt the ciphertext into the original message.



* Message: Make every day count
* Key: Jean Jacqu esR ousse
* Encryption: wdpi eexyv ars lfxek


| Message (M):     | m | a | k | e | = | 109 | 97  | 107 | 101 |
|---               |---|---|---|---|---|-----|-----|-----|-----|
| Key (K):         | j | e | a | n | = | 106 | 101 | 97  | 110 | 
| Ciphertext (C):  | w | d | p | i | = | 119 | 100 | 112 | 105 |



'z' - 'a' = 122-97=25


### Encryption
position of C = ((25 - Position of M + position of K) mod 26) + 'a=97' 

<img src="https://latex.codecogs.com/svg.latex?\Large&space;C_i=((25-M_i+K_i)\hspace{2mm}\textup{mod}\hspace{2mm}26)+97" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />

Example related to table shown above:
* ((25-109 + 106) mod 26) + 97 = 119 = 'w'

### Decryption
position of M = ((25 + position of K - position of C) mod 26) + 97

<img src="https://latex.codecogs.com/svg.latex?\Large&space;M_i=((25+K_i-C_i)\hspace{2mm}\textup{mod}\hspace{2mm}26)+97" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />
