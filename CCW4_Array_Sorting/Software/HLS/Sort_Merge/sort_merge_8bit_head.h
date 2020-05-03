#include <stdint.h> // Required for uint8_t type

// **** Header ****
#define MAX_NUMBERS 200
#define min(x,y) x>y?y:x
#define SortInt uint8_t // Defined as Unsigned type, range from 0 to 255

void mergeSort(SortInt inputNums[MAX_NUMBERS], SortInt array_length);
void mergeJoin(SortInt inputNums[MAX_NUMBERS], int start,int mid, int end);