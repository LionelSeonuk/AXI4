# AXI4
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/5e10a5ee-7d96-40b4-9fd6-cf567ebe1273)
Design Zynq SoC with AXI Peripherals (Keypad, UART, 7-segment display)

# Result
### <Keypad,7-segment display>
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/1fdd015f-7fb9-4893-9cbe-9cd3bfcefab0)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/9b6ccee2-ceb1-40b2-98d0-24b3c8c29879)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/dfd32077-b8fa-4be6-8760-f8a6fde32223)

### <UART TX ,RX>
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/503a1e8e-d765-4027-a54f-870a886ddd84)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/209d2e3f-4073-4d28-b363-5fb276027508)  
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/a22b4eb9-6dcd-496f-b70f-414eaa29d589)

# How to Play
1. If you select 1, 7seg and keypad will be activated. If you press the desired number from 1-9 on the keypad, the number will be output in 7seg. If you press the alphabet, it will not output.
2. If you select 2, uart tx will be activated. Press the desired number and it will be sent from the serial term to the tera term. However, it is converted to ASCII code and must be pressed from 48. If you press 0 to 47, the garbage value will be sent.
3. If you select 3, uartrx will be activated. Press the desired number and it will be sent from tera term to serial term. However, it is converted to ASCII code and must be pressed from 48. If you press 0 to 47, the garbage value will be sent.

# Code Explain
```verilog
wire [6:0] dec_out1, dec_out2, dec_out3, dec_out4, dec_out5, dec_out6;
wire [3:0] dec_in1, dec_in2, dec_in3, dec_in4, dec_in5, dec_in6;

dec7 inst1(dec_in1,dec_out1);
dec7 inst2(dec_in2,dec_out2);
dec7 inst3(dec_in3,dec_out3);
dec7 inst4(dec_in4,dec_out4);
dec7 inst5(dec_in5,dec_out5);
dec7 inst6(dec_in6,dec_out6);
```
### 7segment instance
Dec_in and Dec_out were used to pass register values to the 7-segment display decoder.
<br>
Each input (dec_in) was assigned the lower 4 bits of the corresponding register and provided as input to 7-segment decoder instances (inst1 to inst6).
<br>
```verilog
// Users to add ports here
output wire [7:0] seg_data,
output wire [5:0] seg_com, 
////////////////////////
.seg_data(seg_data),
.seg_com(seg_com)
```
### 7segment port
```verilog
always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        3'h0   : reg_data_out <= slv_reg0;
	        3'h1   : reg_data_out <= slv_reg1;
	        3'h2   : reg_data_out <= slv_reg2;
	        3'h3   : reg_data_out <= slv_reg3;
	        3'h4   : reg_data_out <= slv_reg4;
	        3'h5   : reg_data_out <= slv_reg5;
	        3'h6   : reg_data_out <= slv_reg6;
	        3'h7   : reg_data_out <= slv_reg7;
	        default : reg_data_out <= 0;
	      endcase
	end
assign dec_in1 = slv_reg1[3:0];
   assign dec_in2 = slv_reg2[3:0];
   assign dec_in3 = slv_reg3[3:0];
   assign dec_in4 = slv_reg4[3:0];
   assign dec_in5 = slv_reg5[3:0];
   assign dec_in6 = slv_reg6[3:0];
```
### 7segment register
Depending on the AXI address (axi_araddr), data from other registers (slv_reg0 to slv_reg7) were selectively assigned to reg_data_out, and the default set the output to 0.
<br>
```verilog
always @ (posedge clk_600hz) begin
if(S_AXI_ARESETN==0) seg_com = 6'b100000;
else begin
seg_com <= { seg_com[0], seg_com [5:1] };
end
end
```
### 7segment seg_com
This block runs every posedge of the 600Hz clock. 
<br>
When S_AXI_ARESETN is reset, seg_com is set to the initial value, otherwise seg_com is cycled to activate each display sequentially.
<br>
```verilog
always @ (seg_com) begin
        case (seg_com)
            6'b100000: begin
                seg_data = {dec_out1, 1'b0};
            end
            6'b010000: begin
                seg_data = {dec_out2, 1'b0};
            end
            6'b001000: begin
                seg_data = {dec_out3, 1'b0};
            end
            6'b000100: begin
                seg_data = {dec_out4, 1'b0};
            end
            6'b000010: begin
                seg_data = {dec_out5, 1'b0};
            end
            6'b000001: begin
                seg_data = {dec_out6, 1'b0};
            end
            default: seg_data = 8'b0;
        endcase
    end
endmodule
```
### 7segment decoder
Depending on the state of seg_com, the dec_out value corresponding to the activated display was passed to seg_data to set the data to be output to the segment. (1'b1 is illuminated in dots, while 1'b0 is not illuminated in dots.)
<br>
```verilog
always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        2'h0   : reg_data_out <= slv_reg0;
	        2'h1   : reg_data_out <= {28'b0,data_register};
	        2'h2   : reg_data_out <= {31'b0,data_valid};
	        2'h3   : reg_data_out <= slv_reg3;
	        default : reg_data_out <= 0;
	      endcase
	end

reg [3:0] data_register; 
reg data_valid; 
assign read_signal = slv_reg0[0];
```
### Keypad register
The data_register stores the value of the keypad reliably, and the data_vailed is set to '1' when the new keypad value is stored, indicating that the data is ready for use.
<br>
read_signal is a signal that reads data and, when activated, resets data_vailed.
<br>
```verilog
always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
    if (!S_AXI_ARESETN) begin
        data_register <= 0;
        data_valid <= 0;
    end else if((data_valid==0) && keypad_out_pulse) begin
            data_register <= keypad_out_pulse[3:0]; 
            data_valid <= 1;
        end
        else if (read_signal) begin
            data_valid <= 0; 
        end
        else begin end
    end
```
### Keypad data register & control register logic 
This block responds to the rising edge of the system clock or the falling edge of the reset. When the system is reset, initialize data_register and data_valid to zero.
<br>
Update data_register and set data_valid to 1 when a new keypad value is entered (keypad_out_pulse) and data is not yet valid (data_valid == 0).
<br>
When read_signal is enabled, reset the data_valid.
<br>
```verilog
always @(*)
   begin
         // Address decoding for reading registers
         case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
           2'h0   : reg_data_out <= slv_reg0;
           2'h1   : reg_data_out <= {24'b0, tx_data_reg};
           2'h2   : reg_data_out <= {31'b0, rxd_reg};
           2'h3   : reg_data_out <= {24'b0, rx_data_reg};
           default : reg_data_out <= 0;
         endcase
   end
reg rxd_reg; 
assign uart_rxd = rxd_reg;
wire  [7:0] uart_rx_data;
reg   [7:0] rx_data_reg;
assign uart_rx_data = rx_data_reg;
```
### UART register
```c
#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

int dec7_data=0;
int tx_data;
int rx_data;
int i;
int tx;

int main() {

   int sel;

   printf("select 1 or 2 or 3\n");
   scanf("%d",&sel);

   if(sel == 1) {

      printf("System Ready...\n");
          printf("Press a key on the Keypad\n");

          while(1) {
             read_keypad();
             display_number();
          }
   }
   else {

   }
   if(sel==2){
     printf("System Ready...\n");
                printf("Press a number on the Keyboard-Vitis Serial Terminal\n");

    while (1) {
       printf(" UART_TX로 보낼 데이터 입력  \n\r");
       scanf("%d",&tx_data);
       Xil_Out32(((XPAR_MYIP_UART_0_S00_AXI_BASEADDR)+4),(u32)tx_data);
       tx=Xil_In32((XPAR_MYIP_UART_0_S00_AXI_BASEADDR)+4);
       printf("tx에서 받은 데이터 output=%d \n", tx);

    }}
    else {

    }
   if (sel==3){
	   printf("System Ready...\n");
	                   printf("Press a number on the Keyboard-Tera Term\n");
             while (1) {
             printf(" UART_RX로 보낼 데이터 입력  \n\r");
             rx_data=Xil_In32((XPAR_MYIP_UART_0_S00_AXI_BASEADDR)+12);
             printf("rx에서 받은 데이터 output=%d \n", rx_data);
   }}
   else {

       }
    printf("Finish \n\n\r");
    return 0;
}

void display_number(){
   printf("dec %d \n", dec7_data);//출력 확인용
   for (i=1; i<7; i++){
      printf("%d -  %d \n", dec7_data, i);//출력 확인용
   Xil_Out32(( XPAR_MYIP_7SEG_0_S00_AXI_BASEADDR + (i*4)),dec7_data);
  }
}
void read_keypad(){
   while(Xil_In32(XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR + 8) == 0) { }
   printf("%d \n", dec7_data);//출력 확인용
   dec7_data = Xil_In32((XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR) + 4);
   printf("%d \n", dec7_data);//출력 확인용
   Xil_Out32((XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR),(u32)1);
   Xil_Out32((XPAR_MYIP_KEYPAD_0_S00_AXI_BASEADDR),(u32)0);
}
```
### 7segment 
It was implemented to write the dec_data of the address of reg using the for statement.
<br>
### Keypad 
1. I read the address of reg2 and implemented it to keep waiting until the value is not 0.
2. Pressing the keypad button leaves the standby loop above and outputs the current value of the dec7_data variable to the console. This value may not have changed in the initial state, so it was used for output verification.
3. Read new data from the keypad. Read 32-bit data {28'b0,data_register} from the reg1 address and store it in the dec7_data variable.
4. The first Xil_Out32 call writes 1 in the register to reset the keypad interface. On the second Xil_Out32 call, the register was set back to zero to implement the normal state of the keypad interface.
### UART_TX
1. It prompts you to enter data for UART transmission. Use the scanf function to receive data in integer form from the user and store it in the tx_data variable.
2. We designed the data to be sent to UART by writing the received data (tx_data) to the reg1 {24'b0, tx_data_reg} address.
3. Use the Xil_In32 function to reread the data just sent. Data read is designed to be stored in a tx variable.
4. It is designed to output the values stored in the tx variable to TeraTerm.
### UART_RX
1. When the module receives the data by reading the data from the UART receive register, it is stored in reg3{24'b0, rx_data_reg}.
2. The read data is stored in the rx_data variable, which is then designed to be output via a serial terminal via a message.
