#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "sort_merge_8bit_head.h"

// **** Test Bench ****
int main() {
    FILE *inputFile;
    FILE *outputFile;
    SortInt numbers[MAX_NUMBERS] = {'\0'};
    SortInt i;
    SortInt array_length = 0; 
    
    // Open files
    inputFile=fopen("unsorted.dat","r");
    outputFile=fopen("sorted_result.dat","w+");
    if (!inputFile) {
        printf("Problem with opening unsorted.txt file\n");
        return 0; // Exit the program
    }

    // Print unsorted array
    printf("\r\nUnsorted numbers from unsorted.txt are: \n");  
    for (i=0; i<MAX_NUMBERS; i++) {
        if (fscanf(inputFile, "%d", &numbers[i]) != 1) {
            array_length = i; // get lenght of the array in text file
            break;
        }
        printf("%d ", numbers[i]);
    }

/*    // Print the length of the array for testing purposes
    printf("\r\nLenght in unsorted.txt is: ");
    printf("%d", array_length);
*/
    
    // Call sorting and merging function
    mergeSort(numbers, array_length);
    
    // Print and store sorted array

    printf("\r\nSorted numbers placed in sorted.txt are: \n"); 
    for(i = 0; i < array_length ; i++) {
        fprintf(outputFile, "%d \n", numbers[i]); //Place values in myfile
        printf("%d ",numbers[i]); 
    }

    // Close the files and exit the program
    fclose(inputFile);
    fclose(outputFile);
    printf("\n\n");
    
    // Only for testing to verify the correct behavior
    if (system("diff -w sorted_result.dat sorted_defined.dat")) {
        fprintf(stdout, "**** FAIL: Output DOES NOT Matches Predefined Output ****\n");
        return 1;
    }
    else{
        fprintf(stdout, "**** PASS: Output Matches Predefined Output ****\n");
    }
    return 0;
}
