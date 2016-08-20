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
int n = 6;
int k = 3;
int no_inputs = pow(2,n);
int *select_inputs = new int[n]{0};
int *mux_input = new int[no_inputs]{0};
int no_LUT = 0;
int in_OR = 0; //number of bots to be ORed

// the implementation has been divided into 3 cases
// CASE 1: k = n+1
// CASE 2: k < n+1
// CASE 3: k > n+1
// NOTE: If the LUTs are assumed to have strictly one output, then, CASE 3 and CASE 1
// have almost similar algorithm. Because n+1 is the maximum number of inputs we can 
// use for an LUT if only single output is allowed.

// Initializing functions
int mux_final(int n, int k);
int case_1();
int case_2();
int case_3();
int single_op_LUT_case_1(int index, int mux_input, int select_inputs[]);
int single_op_LUT_case_2(int index, int mux_input, int select_inputs[], int no_levels);
int single_op_LUT_case_3(int index, int mux_input[], int select_inputs[], int stage1_LUT_no);
int * int_to_binary(int number);
int final_OR(int result[]);
int OR_LUT(int output[]);



int mux_final(int n, int k){
// n: 2^n x n MUX
// k: k-input LUTs are allowed
	int answer;
	if (k == n+1){
		answer = case_1();
		}
	if (k < n+1){
		answer = case_2();
		}
	if (k > n+1){
		answer = case_3();
		}
	return answer;
}

int case_1(){
	cout << "Case 1" << endl;
	int* output = new int[no_inputs];
	int* index = new int[n];
	int input;
	int answer;
	for(int i=0; i<no_inputs; i++){
		input = mux_input[i];
		output[i] = single_op_LUT_case_1(i, input, select_inputs);
		no_LUT = no_LUT + 1;
		cout << output[i] << endl;
		in_OR = in_OR + 1;
	}
	// Final OR
	answer = final_OR(output);
	
	return answer;
}

int case_2(){
	cout << "Case 2" << endl;
	int* output = new int[no_inputs];
	int* index = new int[n];
	int input;
	int answer;
	int no_levels = ceil(((float)n)/((float)(k-1)));
	for(int i=0; i<no_inputs; i++){
		input = mux_input[i];
		output[i] = single_op_LUT_case_2(i, input, select_inputs, no_levels);
		no_LUT = no_LUT + no_levels;
		cout << output[i] << endl;
		in_OR = in_OR + 1;
	}
	// Final OR
	answer = final_OR(output);
	
	return answer;
}


int case_3(){
	cout << "Case 3" << endl;
	int no_of_stage1_LUTs = ceil(float(no_inputs)/float(k-n));
	int* output = new int[no_of_stage1_LUTs]{0};
	int* index = new int[n];
	int answer;
	int i = 0; //for keeping track of the main loop
	int m = 0; //for re-initializing input array to the LUT every time
	int j = 0; //for keeping track of the number of times main loop is called
			   //and for assigning values to output array
	while(i<no_inputs){
		int* input = new int[k-n]{0};
		j = j+1;
		m = 0;
		for(int l = i; l<i+k-n; l++){
			input[m] = mux_input[i+m];
			m = m+1;
		}
		output[j-1] = single_op_LUT_case_3(i, input, select_inputs, j);
		no_LUT = no_LUT + 1;
		//cout << output[j-1] << endl;
		in_OR = in_OR + 1;
		i = i+k-n;
	}
	// Final OR
	if(no_of_stage1_LUTs == 1){ answer = output[0];}
	else {answer = final_OR(output);}
	
	
	return answer;
}


int single_op_LUT_case_1(int index_ip, int mux_input, int select_inputs[]){
	// for a general case, select_inputs variable will be a selected 
	// indices of select_inputs depending in the case
	int answer;
	int *in_binary;
	int flag = 0;
	in_binary = int_to_binary(index_ip);
	// Comparing the binary index value
	for(int i = 0; i<n; i++){
		if (in_binary[i] == select_inputs[i]){
		}
		else {
			flag = 1;
			break;
		}
	}
	
	//if ((std::equal(in_binary, in_binary + sizeof in_binary / sizeof *in_binary, select_inputs))){
	if (flag == 0){
		cout << "check" << endl;
		answer = mux_input;  // e.g) Pass input 1 if select pins = 000 
	}
	else {answer = 0;}
	return answer;
}

int single_op_LUT_case_2(int index_ip, int mux_input, int select_inputs[], int no_levels){
	int answer;
	int* in_binary;
	int flag = 0;
	in_binary = int_to_binary(index_ip);
	for(int i=0; i<no_levels; i++){
		//cout << "i: " << i << endl;
		int* temp1 = new int[k-1]{0};  //saves k-1 bits of index_ip
		int* temp2 = new int[k-1]{0};  //saves k-1 bits of select_inputs
		flag = 0;
		for(int j=0; j<k-1; j++){
			if(((i*k)+j-i)<n){
				temp1[j] = in_binary[(i*k)+j-i];
				temp2[j] = select_inputs[(i*k)+j-i];
			}
		}
		for(int j=0; j<k-1; j++){
			if(temp1[j] != temp2[j]){
				flag = 1;
				answer = 0;
				break;
			}
		}
		if (flag==0){
			answer = mux_input;
		}
		else { 
			break;
		}
	}
	
	return answer;
}


int single_op_LUT_case_3(int index_ip, int mux_input[], int select_inputs[], int stage1_LUT_no){
	// for a general case, select_inputs variable will be a selected 
	// indices of select_inputs depending in the case
	//int no_of_stage1_LUTs = ceil(no_inputs/(k-n));
	int answer = 0;
	int* in_binary = new int[n];
	int flag = 0;
	// Comparing the binary index value
	for(int j = 0; j<k-n; j++){
		flag = 0;
		if((index_ip+j) < no_inputs){
			in_binary = int_to_binary(index_ip+j); // n bits
		}
		for(int i = 0; i<n; i++){
			if (in_binary[i] == select_inputs[i]){
			}
			else {
				flag = 1;
				break;
			}
		}
		if(flag==0){
			cout << "check" << endl;
			answer = mux_input[j];
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
	
	mux_input[63] = 1;
	for(int i = 0; i<n; i++){
		select_inputs[i] = 1;
	}
	int answer = mux_final(n,k);
	cout << "Final Answer: " << answer << endl;
	cout << "No. of LUTs used: " << no_LUT << endl;
	return 0;
}
