#include <stdio.h>
#include <string.h>
int gyo=1;
int inst;
char instchar[32][4];

void nop(int opcd){
	inst = 0x04000000;
return ;
}

void I(int opcd){
	int rs, rt, address;
	scanf("%d %d %d",&rs, &rt, &address);
	inst = opcd + (rs<<21) + (rt<<16) + address;
	instchar[gyo][1] = (char)rs;
	instchar[gyo][2] = (char)rt;
	instchar[gyo][3] = (char)address;
return ;
}

void calc(int opcd){
	int rs, rt, rd;
	scanf("%d %d %d",&rs, &rt, &rd);
	inst = opcd + (rs<<21) + (rt<<16) + (rd<<11);
	instchar[gyo][1] = (char)rs;
	instchar[gyo][2] = (char)rt;
	instchar[gyo][3] = (char)rd;
return ;
}

void shift(int opcd){
	int rt, rd, shamt;
	scanf("%d %d %d",&rt, &rd, &shamt);
	inst = opcd + (rt<<16) + (rd<<11) + (shamt<<6);
	instchar[gyo][1] = (char)rt;
	instchar[gyo][2] = (char)rd;
	instchar[gyo][3] = (char)shamt;
return ;
}

void J(int opcd){
	int address;
	scanf("%d",&address);
	inst = opcd + address;
	instchar[gyo][1] = (char)address;
return ;
}


void Reopcd(char *op){
  int opcd;
  if(!strcmp(op,"add")){	
  	opcd=0x00000020;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"sub")){
  	opcd=0x00000022;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"and")){
  	opcd=0x00000024;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"or")){
  	opcd=0x00000091;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"nor")){
  	opcd=0x00000092;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"xor")){
  	opcd=0x00000093;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"slt")){
    opcd=0x000000a2;
  	calc(opcd);
  	return ;
  }else if(!strcmp(op,"load")){
  	opcd=0x8c000000;
  	I(opcd);
  	return ;
  }else if(!strcmp(op,"store")){
  	opcd=0xac000000;
  	I(opcd);
  	return ;
  }else if(!strcmp(op,"beq")){
  	opcd=0x00000000;
  	I(opcd);
  	return ;
  }else if(!strcmp(op,"sll")){
  	opcd=0x00000001;
  	shift(opcd);
  	return ;
  }else if(!strcmp(op,"srl")){
  	opcd=0x00000002;
  	shift(opcd);
  	return ;
  }else if(!strcmp(op,"sra")){
  	opcd=0x00000003;
  	shift(opcd);
  	return ;
  }else if(!strcmp(op,"jump")){
  	opcd=0x02000000;
  	J(opcd);
  	return ;
  }else if(!strcmp(op,"nop")){
  	opcd=0x04000000;
  	nop(opcd);
  	return ;
  }else{
  	printf("エラー：") ;
  	return ;
  }
}

int main(void) {
  char op;

  printf("constant M0 : std_logic_vector(31 downto 0) := x\"04000000\"; --nop\n");  
  while (scanf("%s ",&op) != EOF) {
  inst = 0x00000000;
   instchar[gyo][0] = op;
		Reopcd(&op); 
		if(!strcmp(&op,"nop"))
			printf("constant M%d : std_logic_vector(31 downto 0) := x\"04000000\"; --nop\n", gyo);
		else		    
    		printf("constant M%d : std_logic_vector(31 downto 0) := x\"%08x\"; --%s %d %d %d\n", gyo, inst, &op, (int)instchar[gyo][1], (int)instchar[gyo][2], (int)instchar[gyo][3]);
		gyo++;
  }
  return 0;
}
