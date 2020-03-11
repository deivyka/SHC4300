/****************************************************************************
		Group 2: Biplav, Deivy, Leila, Victor

* @file     NapoleonCipher_zybo.c
*
* This file contains the implementation of the Napoleon Cipher.
*
* Usage:
* 	0) Start Xilinx SDK. Connect Zybo to computer via USB.
* 	1) Go to Xilinx > Program FPGA > Program
* 	2) Open SDK Terminal
* 	2.1) Press '+' > Select COM-port > Keep default values under 'Advanced Settings' > ok
* 	3) Right-click on 'Napoleon_Cipher'-folder > Run as > 1 Launch on Hardware (system debugger)
* 	4) Go to SDK Terminal > encode/decode your message
****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define MAX_TEXT_SIZE 200
#define CIPHER_KEY "victordeivyleilabiplav"
#define CIPHER_KEY_LEN 23 

/***************************************************************************
* Return the encrypted text generated with the help of the key
* @param	Original text and Cipher text
* @return	Cipher text
****************************************************************************/
void encodeDecode(const char* plainText, char* encryptText) {
	char key[CIPHER_KEY_LEN] = CIPHER_KEY;
	int textCounter, keyCounter = 0;
	for (textCounter = 0; plainText[textCounter] != '\0'; textCounter++) {
		if(plainText[textCounter] == ' ') {
			encryptText[textCounter] = ' ';
			continue;
		}
		int ciph = ((25-plainText[textCounter]) + key[keyCounter]) % 26;
		ciph = ciph + 'a';  // convert into ASCII, A = 65, a = '97'
		encryptText[textCounter] = (char)ciph;
		keyCounter++;
		keyCounter = (keyCounter > CIPHER_KEY_LEN-1) ? 0 : keyCounter; // keyCounter = 0 if keyCounter > key length, else keyCounter = keyCounter
	}
	encryptText[textCounter] = '\0';
	return;
}


/***************************************************************************
* Main function to either decode or encode text
* @param	None
* @return	None
****************************************************************************/
int main() {
	char text[MAX_TEXT_SIZE] = {'\0'};
	char convertedText[MAX_TEXT_SIZE] = {'\0'};
	char selection = '\0';
	while (1) {
		char temp;
		while (selection != 'e' && selection != 'd' && selection != 'q') {
			printf("\n****Napoleon Cipher****\nPress 'e' for encrypt or 'd' for decrypt, 'q' for quit: "); // this prints twice after first selection
			scanf("%c%c", &selection, &temp);
		}
		if (selection == 'q') {
			print("\nFinished...");
			return 0;
		}
		if (selection == 'e' || selection == 'd' ) { // - Encode
			if (selection == 'e') {
				print("\r\nEnter the plain text:\r\n");
			}
			else {
				print("\r\nEnter the encrypted text:\r\n");
			}
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
				i++;
				if ( i == MAX_TEXT_SIZE -2 ) {
					printf("max size reached\r\n");
					i++;
					text[i]='\0';
					break;
				}
			}
			encodeDecode(text, convertedText);
			if (selection == 'e') {
				print("\r\nThe plain text:\r\n");
			}
			else {
				print("\r\nThe encrypted text:\r\n");
			}
			print(text);
			if (selection == 'e') {
				print("\r\nThe encrypted text:\r\n");
			}
			else {
				print("\r\nThe plain text:\r\n");
			}
			print(convertedText);
			print("\r\n");
		}
		selection = '\0';
	}
	return 0;
	cleanup_platform();
}
