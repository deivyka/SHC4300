/****************************************************************************
        Group 2: Biplav, Deivy, Leila, Victor
* @file     merge_sort.c
*
* This file contains the implementation of the Merge Sort comparison-based sorting algorithm.
****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define MAX_NUMBERS 200

void mergeSort(int *inputNums, int start, int end);
void mergeJoin(int *inputNums, int start, int mid, int end);

void mergeSort(int *inputNums, int start, int end) {
    //printf("mergeSort %d %d \n",start,end); 
    if(start == end)
        return;
    int mid = (end + start ) / 2;
    mergeSort(inputNums, start, mid);
    mergeSort(inputNums, mid+1, end);
    mergeJoin(inputNums, start, mid, end);
}

void mergeJoin(int *inputNums, int start, int mid, int end) {
    int tmp_index = 0;
    int tmp_max = (end - start);
    int tmp[MAX_NUMBERS] = {'\0'}; // this can be optimized, instead of MAX_NUMBERS, tmp_max can be used
    int mid_index = mid + 1;
    int start_index = start;
    if(start == end)
        return;
    while (tmp_index <= tmp_max) {
        if(start_index <= mid && mid_index <= end) {
            if(inputNums[start_index] < inputNums[mid_index]) {
                tmp[tmp_index++] = inputNums[start_index++];  
            }
            else {
                tmp[tmp_index++] = inputNums[mid_index++];
            }
        }
        else {
            if(mid_index > end) {
                tmp[tmp_index++] = inputNums[start_index++];  
            }
            else {
                tmp[tmp_index++] = inputNums[mid_index++];
            }
        }
    }
    tmp_index = 0;
    for(start_index = start; start_index <= end; start_index++) {
        inputNums[start_index] = tmp[tmp_index++];
    //printf("merge join %d[%d] ",inputNums[start_index],start_index); 
    }
}

/* Main function */
int main() {
    int numbers[MAX_NUMBERS] = {'\0'};
    int totalNum = 0;
    int loop=0;
    while (1) {
        char temp='\0';   // temp is to capture return (enter) keyboard entry
        while (1) {
            totalNum = 0;
            printf("\n****Merge Sort****\nEnter number of integer for sort (2-200), enter 0 for quit: "); 
            scanf("%d%c", &totalNum, &temp); 
            //scanf("%d", &totalNum); 
            if(totalNum == 0) {
                return 0;
            }

            if(totalNum > 200 || totalNum < 2) {
                printf("\n Invalid number \n"); 
                continue;
            }
            break;
        }
        for(loop = 0; loop < totalNum ; loop++) {
            printf("\nEnter %d%s number:",loop+1,
                        (loop+1)%10==1 ?"st": (loop+1)%10==2 ?"nd":(loop+1)%10==3?"rd":"th"); 
            scanf("%d%c", &numbers[loop], &temp); 
            //scanf("%d",&numbers[loop]); 
            //printf("%d ",numbers[loop]); 
        }
        printf("\nOriginal numbers are:  "); 
        for(loop = 0; loop < totalNum ; loop++) {
            printf("%d ",numbers[loop]); 
        }
        //return 0;
        mergeSort(numbers,0,totalNum-1);
        printf("\nSorted numbers are:  "); 
        for(loop = 0; loop < totalNum ; loop++) {
            printf("%d ",numbers[loop]); 
        }
    }
    return 0;
    cleanup_platform();
}