// simple uart_tx (moore version) //
//  uart_tx_data (SW): Down (towards the edge of the board)  --> "0"
module uart_tx (
   input clk,
   input rst,
   input wire uart_tx_en, 
   input [7:0] uart_tx_data, 
    output tx_busy,
   output reg uart_txd
);

   parameter   IDLE_ST= 4'd0,
            START_ST= 4'd1,
            D0_ST= 4'd2,
            D1_ST= 4'd3,
            D2_ST= 4'd4,
            D3_ST= 4'd5,
            D4_ST= 4'd6,
            D5_ST= 4'd7,
            D6_ST= 4'd8,
            D7_ST= 4'd9,
            STOP_ST= 4'd10;
   
   reg [3:0] state, next;
   reg [15:0] count;
   wire uart_start_pulse, transit;

   //wire uart_tx_en_wire;
   //assign uart_tx_en_wire = uart_tx_en;
    debounce debounce_inst (clk, rst, uart_tx_en, , uart_start_pulse); 
    //  assign uart_start_pulse = uart_tx_en;
      
    always @* begin
        case (state)
            IDLE_ST : if(uart_start_pulse) next = START_ST; else next = IDLE_ST; 
            START_ST : if(transit) next =  D0_ST; else next = START_ST; 
            D0_ST : if(transit) next = D1_ST; else next = D0_ST;
            D1_ST : if(transit) next = D2_ST; else next = D1_ST;
            D2_ST : if(transit) next = D3_ST; else next = D2_ST;
            D3_ST : if(transit) next = D4_ST; else next = D3_ST;
            D4_ST : if(transit) next = D5_ST; else next = D4_ST;
            D5_ST : if(transit) next = D6_ST; else next = D5_ST;
            D6_ST : if(transit) next = D7_ST; else next = D6_ST;
            D7_ST : if(transit) next = STOP_ST; else next = D7_ST;
            STOP_ST : if(transit) next = IDLE_ST; else next = STOP_ST; 
            default : next = START_ST; 
        endcase
   end

   //OUTPUT LOGIC, Moore machine
   always @* begin
      case(state) 
         IDLE_ST : uart_txd = 1;
         START_ST : uart_txd = 0;
         D0_ST : uart_txd = uart_tx_data[0];
         D1_ST : uart_txd = uart_tx_data[1];
         D2_ST : uart_txd = uart_tx_data[2];
         D3_ST : uart_txd = uart_tx_data[3];
         D4_ST : uart_txd = uart_tx_data[4];
         D5_ST : uart_txd = uart_tx_data[5];
         D6_ST : uart_txd = uart_tx_data[6];
            D7_ST : uart_txd = uart_tx_data[7];
         STOP_ST : uart_txd = 1;
         default : uart_txd = 1; 
      endcase
   end

    //baud rate: 115200bps (115200 bits / sec)
    //1bit transfer : 1/115200 sec = 8.68055us
    //1clk period = 10ns (100 MHz clk) 
    //1clk period = 20ns (50 MHz clk 사용) <------------ ps 50MHZ 사용예정 
    //8.68055us / 10ns = 868 clock cycles
    //8.68055us / 20ns = 434 clock cycles <------------ ps 50MHZ 사용시 434 clock cycle 
    // 17
   always @(posedge clk or negedge rst) begin 
        if (rst==0) count <= 0;
        else if (state == IDLE_ST) count <= 0; 
        else begin
            if (count == 867) count <=0; 
            else if (uart_start_pulse == 1'b1) count <= 0; 
            else count <= count + 1;
        end
    end
    
    assign transit = (count == 867)? 1 : 0; 
    
    assign tx_busy = (state==IDLE_ST)? 0 : 1;   
           
    always @(posedge clk or negedge rst) begin
      if(rst==0) state <= IDLE_ST;
      else state <= next; 
    end

endmodule