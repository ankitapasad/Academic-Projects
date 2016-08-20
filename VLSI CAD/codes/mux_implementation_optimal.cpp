// This code:
// Fits mux in k-input LUTs (where order of mux and k are both set by the user)
// OUTPUT: Final answer for given select inputs and given inputs for the MUX
//         Total number of LUTs required for the implementation of the same

#include <iostream>
#include <stdio.h>
#include <math.h>
#include <string>
#include <fstream>
#include <ctime>

using namespace std;

// Initializing global variables
// enter only 0/1 values
int n = 3;
int k = 3;
int no_inputs = pow(2,n);
int *select_inputs = new int[n]{0,0,0};
int *mux_input = new int[no_inputs]{0,1,0,1,0,1,0,1};
int no_LUT = 0;
int in_OR = 0; //number of bots to be ORed

int mux_final(int n, int k);
int single_op_LUT(int mux_input_index[], int select_input_index[], int select_input_to_mux[], int no_mux_inputs);
int * int_to_binary(int number);
int final_OR(int result[]);
int OR_LUT(int output[]);

int mux_final(int n, int k){
int answer;
	int *output = new int[no_inputs]{0};
	int no_of_mux_inputs_lut=0;
	int no_of_select_input_lut=0;
	int x = 0;
//for calculating the number of select inputs at each LUT 
	while(x<k)
	{
	
	if(((pow(2,x-1)<(k-x)) == 1) && (((k-x)<=pow(2,x)) == 1))
	{
		no_of_mux_inputs_lut = k-x ;
		no_of_select_input_lut = x;
		break;
		}
	else
	{
		x++;
	}
}

	int no_of_LUT_stages = ceil(float(n)/float(no_of_select_input_lut));
	int* input = new int[no_of_mux_inputs_lut]{0}; // input to each LUT of size x
	int* no_LUTS = new int[no_of_LUT_stages+1]; //array holding no of LUT at each stage which is also the number of inputs to next stage
	int* final_output = new int[no_LUTS[no_of_LUT_stages+1]];
        no_LUTS[0] = no_inputs; // dummy for holding mux_inputs 
	
	for(int stage=1; stage<=no_of_LUT_stages;stage++)
	{
	no_LUTS[stage] = ceil(float(no_LUTS[stage-1])/float(no_of_mux_inputs_lut));      
	//int* output_previous = new int[no_LUTS[stage-1]];  
	//int* output_current = new int[no_LUTS[stage]];        
	int i=0;
        int m=0;
	
	while(i<no_LUTS[stage-1])
	{ 
	int* select_input_index = new int[x]{0};
	int* select_input_to_lut = new int[x]{0};
	for(int p=0;p<x;p++)
	{
	select_input_index[p] = (stage-1)*x + p;
	select_input_to_lut[p] = select_inputs[select_input_index[p]]; 
	}

	for (int l=0;l=no_of_mux_inputs_lut;l++)
	{
		
	if (stage == 1)
	input[l] = i+l;
	else
		input[l] = output[i+l];
	}
		//call for LUT function that takes this input and gives a single out depending on the select inputs 
	output[m] = single_op_LUT(input,select_input_index,select_input_to_lut, no_of_mux_inputs_lut);
	no_LUT = no_LUT + 1;
	i = i+no_of_mux_inputs_lut;
	m=m+1;
	}	
	//output_previous = output_current; 
        }

     for(int i=0;i<no_LUTS[no_of_LUT_stages];i++)
	{
 		final_output[i] = mux_input[output[i]]; 
	}
	in_OR = no_LUTS[no_of_LUT_stages];
	// Final OR
	answer = final_OR(final_output);
	
	return answer;
}

int single_op_LUT(int mux_input_index[], int select_input_index[], int select_input_to_mux[], int no_mux_inputs){
	// mux_input_index: array of size no_mux_inputs having index of inputs to LUT
	// select_input_index: array of size no_select_inputs having index of select lines to LUT
	// select_input_to_mux: array of size no_select_inputs having values of select lines to LUT
	
	// for a general case, select_inputs variable will be a selected 
	// indices of select_inputs depending in the case
	
	int answer = -1;
	int* in_binary = new int[n];
	int flag = 0;
	int m = 0;
	int temp;
	int no_select_inputs = k - no_mux_inputs;
	
	// Comparing the binary index value
	for(int j = 0; j<no_mux_inputs; j++){
		flag = 0;
		in_binary = int_to_binary(mux_input_index[j]); // n bits
		temp = select_input_index[0];
		m = 0;
		for(int i = temp; i<temp+no_select_inputs; i++){
			if(i<n){
				if (in_binary[i] == select_input_to_mux[m]){ 
					m = m+1;
				}
				else {
					flag = 1;
					break;
				}
			}
		}
		if(flag==0){
			cout << "check" << endl;
			answer = mux_input_index[j];
			break;
		}
	}
	
	return answer;
}

int OR_LUT(int input[]){ //input is k length array
	int answer = 0;
	for (int i = 0; i<k; i++){
		if(input[i]==1){
			answer = 1;
			break;
		}
	}
	return answer;
}

int* int_to_binary(int number){
	int* result = new int[n]{0};
	int temp = number;
	
	for(int i=n-1; i>=0; i--){
		if(temp>=pow(2,i)){
			temp = temp - pow(2,i);
			result[i] = 1;
			} 
		else {result[i] = 0;}
	}
	
	return result;
}

int final_OR(int result[]){
	int a = in_OR;
	int no_OR_LUT = ceil((float)(a-k)/(float)(k-1))+1;
	no_LUT = no_LUT + no_OR_LUT;
	int i = 0;
	int answer;
	while(i<no_OR_LUT){
		int* temp = new int[k]{0};
		if (i==0){ //case for 1st LUT (as this takes all the outputs from previous non-OR LUTS as inputs)
			for(int j = 0; j<k; j++){
				temp[j] = result[j];
			}
			answer = OR_LUT(temp);
		}
		else{ //case for those LUTs which take one output from the previous OR LUT as input)
			temp[k-1] = answer;
			if (i<no_OR_LUT-1){ 
				for(int j = 0; j<k-1; j++){
				temp[j] = result[(i*k)+j-(i-1)];
				}
				answer = OR_LUT(temp);
			}
			else{ //case for last LUT (as this might not have all inputs filled up)
				for(int j = 0; j<k-1; j++){
					if(((i*k)+j-(i-1))<no_inputs){
						temp[j] = result[(i*k)+j-(i-1)];
					}
					else {break;}
				}
				answer = OR_LUT(temp);
			}
			
			
		}
		i = i+1;
	}

	return answer;
}

int main(void){
	// cout << "Enter the order of mux";
	// cin >> n;
	
	int answer = mux_final(n,k);
	cout << "Final Answer: " << answer << endl;
	cout << "No. of LUTs used: " << no_LUT << endl;
	cout << "Enter the order of LUT";
	cin >> k;
	return 0;
}

