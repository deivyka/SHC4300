// IP Napoleon Cipher

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include <string.h>

#define MAX_TEXT_SIZE 200
unsigned int *ipCiphAddr = XPAR_ENCODER_DECODER_0_ENCODER_DECODER_BASEADDR; // pointer to base address (see system.hdf)


int main() {
	char key_out[] ="jeanjacquesrousseau";
    char text[MAX_TEXT_SIZE] = {'\0'};
    char convertedText[MAX_TEXT_SIZE] = {'\0'};
    char selection = '\0';
    char new_key[32];

    while (1) {
    		char temp;
    		while (selection != 'e' && selection != 'q') {
    			printf("\n\n****Napoleon Cipher****\nPress 'e' for encrypt/decrypt, 'q' for quit: ");
    			scanf("%c%c", &selection, &temp);
    		}
    		if (selection == 'q') {
    			print("\nFinished...");
    			return 0;
    		}
    		if (selection == 'e') {
    			print("\r\nEnter the plain text:\r\n");
    			int i = 0;
    			while((temp = getchar())) {
    				if((temp < 'a' || temp > 'z' ) && temp != ' ' && temp != '\r' && temp != '\n') {
    				   printf("Invalid character ignoring\r\n");
    				   continue;
    				}
    				if (temp == '\n' || temp == '\r') {
    					text[i]='\0';
    					break;
    				}
    				text[i] = temp;
    				if (text[i] == ' ') {
    					convertedText[i] = ' ';
    					continue;
    				}
    				i++;
    			}
    			// generate key based on length of input-text
    			for (int u=0, v=0; u < strlen(text); ++u, ++v) {
    				if (v == strlen(key_out)) {
    					v = 0; // "restart" key
    				}
    				new_key[u] = key_out[v];
    			}

    			for (int x=0; x < strlen(text); ++x) {
    				*(ipCiphAddr + 0) = text[x]; 			// put text into slv_reg0 (base address)
    				*(ipCiphAddr + 2) = new_key[x]; 		// put key into slv_reg2 (base address+2)
    				 convertedText[x] = *(ipCiphAddr + 1); 	// read cipher text from slv_reg1 (base address+1)
    			}
    			printf("text in: %s\r\n", text);
    			printf("text out: %s\r\n", convertedText);
    			print("\r\n");
    		}
    		selection = '\0';
    		for (int i = 0; i < 32; ++i) { // clear output
    		    convertedText[i] = '\0';
    		}
    	}
    	return 0;
    	cleanup_platform();
    }
