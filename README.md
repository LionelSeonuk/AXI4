# AXI4
Design Zynq SoC with AXI Peripherals (keypad, UART, 7-segment display)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/5e10a5ee-7d96-40b4-9fd6-cf567ebe1273)

<7segment & keypad>

![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/1fdd015f-7fb9-4893-9cbe-9cd3bfcefab0)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/9b6ccee2-ceb1-40b2-98d0-24b3c8c29879)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/dfd32077-b8fa-4be6-8760-f8a6fde32223)

<UART TX ,RX>
  
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/503a1e8e-d765-4027-a54f-870a886ddd84)
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/209d2e3f-4073-4d28-b363-5fb276027508)  
![image](https://github.com/LionelSeonuk/AXI4/assets/167200555/a22b4eb9-6dcd-496f-b70f-414eaa29d589)

# How to play
1. If you select 1, 7seg and keypad will be activated. If you press the desired number from 1-9 on the keypad, the number will be output in 7seg. If you press the alphabet, it will not output.
2. If you select 2, uart tx will be activated. Press the desired number and it will be sent from the serial term to the tera term. However, it is converted to ASCII code and must be pressed from 48. If you press 0 to 47, the garbage value will be sent.
3. If you select 3, uartrx will be activated. Press the desired number and it will be sent from tera term to serial term. However, it is converted to ASCII code and must be pressed from 48. If you press 0 to 47, the garbage value will be sent.

# Code Explain
```
