#include "sort_merge_8bit_head.h"

// **** Main Functions ****
void mergeSort(SortInt inputNums[MAX_NUMBERS], SortInt array_length)
{
    //printf("mergeSort %d %d \n",start,end); 
    int start = 0;
    int end = (int)array_length - 1;
    if(start == end)
        return;
    //int mid = (end + start ) / 2; //this part is not used in the code
    int loop=0;

    for(loop=1; loop <= end; loop*=2)
    {
       int inner_loop=0; 
       for(inner_loop=0; inner_loop < end; inner_loop += 2*loop)
       {
            int tmp_start = inner_loop;
            int tmp_mid = min(inner_loop + loop -1, end);
            int tmp_end = min(tmp_mid + loop, end);
            //printf("\nmergeSort loop %d %d %d",tmp_start,tmp_mid,tmp_end); 
            mergeJoin(inputNums,tmp_start,tmp_mid,tmp_end);
       }
    }
}

void mergeJoin(SortInt inputNums[MAX_NUMBERS], int start,int mid, int end)
{
    int tmp_index = 0;
    int tmp_max = (end - start);
    int tmp[MAX_NUMBERS] = {'\0'}; // this can be optimized, instead of MAX_NUMBERS, tmp_max can be used
    int mid_index = mid + 1;
    int start_index = start;
    if(start == end)
        return;
    while (tmp_index <= tmp_max )
    {
    if(start_index <= mid && mid_index <= end)
    {
        if(inputNums[start_index] < inputNums[mid_index])
        {
            tmp[tmp_index++] = inputNums[start_index++];  
        }
        else
        {
            tmp[tmp_index++] = inputNums[mid_index++];
        }
    }
    else
    {
        if(mid_index > end)
        {
            tmp[tmp_index++] = inputNums[start_index++];  
        }
        else
        {
            tmp[tmp_index++] = inputNums[mid_index++];
        }
    }
    }
    tmp_index = 0;
    for(start_index = start; start_index <= end; start_index++)
    {
        inputNums[start_index] = tmp[tmp_index++];
    //printf("merge join %d[%d] ",inputNums[start_index],start_index); 
    }

}