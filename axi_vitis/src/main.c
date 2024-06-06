#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"


int dec7_data=0;
int tx_data;
int rx_data;
int i;
int tx;

// 메인 함수
int main() {

   int sel;

   printf("select 1 or 2 or 3\n");
   scanf("%d",&sel);

   if(sel == 1) {

      xil_printf("System Ready...\n");
          xil_printf("Press a key on the Keypad\n");


          while(1) {
             read_keypad();
             display_number();

          }
   }

   else {

   }

   if(sel==2){
	   xil_printf("System Ready...\n");
	             xil_printf("Press a number on the computer\n");

    while (1) {
    	printf(" UART_TX로 보낼 데이터 입력  \n\r");
    	scanf("%d",&tx_data);
    	Xil_Out32(((XPAR_MYIP_UART_0_S00_AXI_BASEADDR)+4),(u32)tx_data);
    	//Xil_Out32((XPAR_MY_UART_V1_0_0_BASEADDR+4),tx_data);
    	//while(Xil_In32(XPAR_MY_UART_V1_0_0_BASEADDR + 8) == 0) { }
    	//tx_data=Xil_In32((XPAR_MY_UART_V1_0_0_BASEADDR)+4);
    	Xil_Out32((XPAR_MYIP_UART_0_S00_AXI_BASEADDR),1);
    	Xil_Out32((XPAR_MYIP_UART_0_S00_AXI_BASEADDR),0);
    	tx=Xil_In32((XPAR_MYIP_UART_0_S00_AXI_BASEADDR)+4);
    	printf("tx에서 받은 데이터 output=%d \n", tx);

    }}
    else {

    }
   if (sel==3){
	   printf(" UART_RX로 보낼 데이터 입력  \n\r");
	       	while (1) {
	       	rx_data=Xil_In32((XPAR_MYIP_UART_0_S00_AXI_BASEADDR)+12);
	       	printf("rx에서 받은 데이터 output=%d \n", rx_data);
   }}
   else {

       }

    printf("End of Test!!\n\n\r");
    return 0;
}


void display_number(){
	printf("dec %d \n", dec7_data);
   for (i=1; i<7; i++){
	   printf("%d -  %d \n", dec7_data, i);
   Xil_Out32(( XPAR_MYIP_7SEG_0_S00_AXI_BASEADDR + (i*4)),dec7_data);
   //slv_reg1
  }
}

void read_keypad(){
   while(Xil_In32(XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR + 8) == 0) { }//slv_reg2 bit0 = signal
   printf("%d \n", dec7_data);
   dec7_data = Xil_In32((XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR) + 4);
   printf("%d \n", dec7_data);
   Xil_Out32((XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR),(u32)1);
   Xil_Out32((XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR),(u32)0);
   //in이 레지스터값긁어오는거고 out이 레지스터값 쓰는거
}

/*void uart_tx() {
	Xil_Out32((XPAR_MY_UART_V1_0_0_BASEADDR+4),tx_data);
	//while(Xil_In32(XPAR_MY_UART_V1_0_0_BASEADDR + 8) == 0) { }
	tx_data=Xil_In32((XPAR_MY_UART_V1_0_0_BASEADDR)+4);
	Xil_Out32((XPAR_MY_UART_V1_0_0_BASEADDR),(u32)1);
	Xil_Out32((XPAR_MY_UART_V1_0_0_BASEADDR),(u32)0);
}

// UART RX 함수: 문자 수신
void uart_rx() {
	Xil_Out32(((XPAR_MY_UART_V1_0_0_BASEADDR)+12),rx_data);
	rx_data=Xil_In32((XPAR_MY_UART_V1_0_0_BASEADDR)+8);
}*/
