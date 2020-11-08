/*
Program 1: Big Boy Computer - contains code to simulate file 
*/
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

typedef struct {
	int opcode;
	int operand;
} Cmd;

typedef unsigned char byte;
typedef unsigned short word;

//-----------Core Processing
char RAM[4096] = {0}; 	// RA Memory
short Acc = 0 ;			// Accumulator aka Calc
int PC = 0; 			//Program Counter in range of [0, 4095];
int running = 1;		//false if halt


//Intructions
const short HLT = 0, NOT = 1, SHL = 2, SHR = 3, INC = 4, DEC = 5, JMP = 6, JAZ = 7,
LDA = 8, STA = 9, ADD = 10, AND = 11, ORR = 12, XOR = 13, OUT = 14, INP = 15;


//-----------BBC Component implementations

short ReadAcc(){
	return Acc;
}

void WriteAcc(word val){
	val &= 0xffff;
	Acc = val;
}

int ReadPC(){
	return PC;
}

void WritePC(int val){
	if(val >= 0 && val < 4096){
		PC = val;
	}
}

//---------------Load - Store
short Load(short addrs){
	addrs &= 0xfff;
	
	short toAcc;
	
	byte b1 = RAM[addrs];
	byte b0 = RAM[addrs + 1];
	
	toAcc = b0 << 8 | b1;
	return toAcc;	
}

void Store(int addrs, word fromAcc){
	addrs &= 0xfff;
	fromAcc &= 0xffff;
	
	byte b0 = fromAcc >> 8;
	byte b1 = fromAcc & 0xff;
	
	RAM[addrs] = b1;
	RAM[addrs + 1] = b0;
}

//----------Fetch, Decode, Execute
word fetch(){
	word pc = Load(ReadPC());
	WritePC(ReadPC() + 2);
	return pc;
}

Cmd decode(short inst) {
	Cmd cmd;
	cmd.opcode = 0;
	cmd.operand = 0;
	
	cmd.opcode = inst >> 12 & 0xf;
	cmd.operand = inst & 0xFFF;
		
	return cmd;
}

void execute(int opcode, int operand) {
	switch (opcode) {
		case HLT:
			running = 0;
			break;
		case NOT:
			WriteAcc(~Acc);
			break;
		case SHL:
			WriteAcc(Acc << operand);
			break;
		case SHR:
			WriteAcc(Acc >> operand);
			break;
		case INC:
			WriteAcc(Acc + 1);
			break;
		case DEC:
			WriteAcc(Acc - 1);
			break;
		case JMP:
			WritePC(operand);
			break;
		case JAZ:
			if(ReadAcc() == 0){
				WritePC(operand);
			}
			break;
		case LDA:
			WriteAcc(Load(operand));
			break;
		case STA:
			Store(operand, ReadAcc());
			break;
		case ADD:
			WriteAcc((ReadAcc() + Load(operand)));
			break;
		case AND:
			WriteAcc((ReadAcc() & Load(operand)));
			break;
		case ORR:
			WriteAcc((ReadAcc() | Load(operand)));
			break;
		case XOR:
			WriteAcc((ReadAcc() ^ Load(operand)));
			break;
		case OUT:
			switch(operand){
				case 0:
					printf("%x", Acc);
					break;
				case 1:
					printf("%d", Acc);
					break;
				case 2:
					printf("%c", Acc);
					break;
				default:
					break;
			}
			break;
		case INP:
			switch(operand){
				case 0:
					scanf("%x", &Acc);
					break;
				case 1:
					scanf("%d", &Acc);
					break;
				case 2:
					scanf("%c", &Acc);
					break;
				default:
					break;
			}
		default:
			break;
			
	}
}

//Step and Run
void step(){
	word instr = fetch();	
	Cmd cmdn = decode(instr);
	execute(cmdn.opcode, cmdn.operand);
}

void run(){
	do{
		step();
	}while(running == 1);
}

void reset() {
	Acc = 0;
	PC = 0;
}

//retricts ASCII char range and interprets the hex value
char asciiToNyble(char value) {
	if (value >= '0' && value <= '9'){
		return value - '0';
	}
	else if (value >= 'a' && value <= 'f'){
		return value - 'a' + 10;
	}
	else if (value >= 'A' && value <= 'F'){
		return value - 'A' + 10;
	}
	return 0;
}

//-----------Miscellaneous Commands 

void hexdump(int start, int len){
	for(int i = start; i < len; ++i){
		byte b = RAM[i];
		
		if(i%0x10 == 0){
			printf("\n %03x   ", i);			
			printf("%02x ", b);
		}else{
			printf("%02x ", b);
		}		
	}
	printf("\n");
}

void edit(word addr, byte val){
	val &= 0xff;
	addr &= 0xfff;
	
	RAM[addr] = val;
}

int main(int argc, char *argv[]) {
	//------------------------File Input
	if(argc != 2){
		printf("Usage: prog1name <filename>");
		exit(1);
	}
	
	FILE *readfile = fopen(argv[1], "r");
	
	if(readfile == NULL){
		printf("Cannot find file. Please check your directory.");
		exit(1);
	}	
	
	int i = 0;
	char first, second;
	while(fscanf(readfile, "%c", &first) != EOF){
		fscanf(readfile, "%c", &second);
		RAM[i / 2] = (asciiToNyble(first) << 4) | asciiToNyble(second); // combines the nyble and assign it to its right place.
		i += 2;
	}

	//---------------------Console Commands
	char prmpt;	
	printf("Prompt> \n");
	
	while(prmpt != 'q'){
		printf("\n? ");
		scanf("%c", &prmpt);
		printf("\n");
		
		switch(prmpt){
			case 'd':
				int strt, len;
				scanf("%x", &strt);scanf("%x", &len);
				hexdump(strt, len);
				break;
			case 'e':
				int addr, val;
				scanf("%x", &addr);scanf("%x", &val);
				edit(addr, val);
				break;
			case 'a':
				printf("Acc: %#x\nPC: %#x\n", ReadAcc(), ReadPC());
				break;
			case 's':
				step();
				break;
			case 'r':
				run();
				break;
			case 'q':
				exit(1);
				break;
			case 'h':
				printf("Commands:\n  Hex Dump: d <start> <length>\n  Edit Address: e <address> <value>\n  Print Acc & PC contents: a\n  Step: s\n  Run: r\n  Quit: q\n  Help: h\n");
			}
	}
	
	fclose(readfile);
}