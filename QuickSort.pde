import controlP5.*;


int first;
int last;
int splitpoint;
int pivotValue; //TODO replace with Hue, Brightness, etc
int leftmark;
int rightmark;
int temp;

boolean done = false;

void quickSort(int[] arr) {
  quickSortHelper(arr,0,arr.length-1);
}

void quickSortHelper(int[] arr, int first, int last) {
   if (first < last) {
     splitpoint = partition(arr,first,last);
     
     quickSortHelper(arr,first,splitpoint-1);
     quickSortHelper(arr,splitpoint+1,last);
   }
}

int partition(int[] arr, int first, int last) {
  pivotValue = arr[first];
  
  leftmark = first + 1;
  rightmark = last;
  
  done = false;
  
  while (!done) {
    while (leftmark <= rightmark &&
           getCompareValue(arr[leftmark]) <= getCompareValue(pivotValue)) {
      leftmark++; 
    }
    while (getCompareValue(arr[rightmark]) >= getCompareValue(pivotValue) 
           && rightmark >= leftmark) {
      rightmark--; 
    }
    
    if (rightmark < leftmark) { //base case
      done = true; 
    } else {
      temp = arr[leftmark];
      arr[leftmark] = arr[rightmark];
      arr[rightmark] = temp;
    }
  }
  
  temp = arr[first];
  arr[first] = arr[rightmark];
  arr[rightmark] = temp;
  
  return rightmark;
}

int getCompareValue(int pixel){
  switch(compareType) {
    case 0  :return (int)hue(pixel);
    case 1  :return (int)brightness(pixel);
    case 2  :return (int)red(pixel);
    case 3  :return (int)green(pixel);
    case 4  :return (int)blue(pixel);
    case 5  :return (int)alpha(pixel);
    case 6  :return (int)saturation(pixel);
  } return 0;
}

void testQuickSort() {
  
  int[] testNums = {10, 9, 8, 7, 5, 5, 6, 4, 3, 2, 1};
  println(testNums);
  println();
  
  quickSort(testNums);
  println(testNums);
}