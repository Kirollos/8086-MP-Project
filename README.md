# 8086-MP-Project
My 8086 Microprocessor project. Submitted June 2022.

# Features

1- On reset, initialization occurs where all registers used (AX,BX and CX) are set to zeroes. Then, AX is set to 1FFh (o/p port = FFh) where right shift operation occurs till it reaches zero. This way we can confirm that the reset is successful and the microprocessor is fully functional.

2- Default mode:
- Toggleable 8 bits. The system accepts input from input port (8 bits).
- It keeps storing them in register CL (using OR operation) until the port is zero. The purpose of this step is to accept multiple bit input (uP will not easily be able to accept multiple bit input in realtime)
- Once the port is zero, a decision is taken:
    - If CL = 11h / 1 0001b -> Start incremental counter
    - If CL = 12h / 1 0010b -> Start decremental counter
    - Otherwise, Perform the toggle operation on the last stored o/p value (stored in AH register) and pass it to o/p port

3- Counter:
- Counter counts between 0 and 255, 0 and FFh, 00000000b and 11111111b.
- Counter works in both incrementally and decrementally.
- Between each count, there's a delay system (used by setting BX register to a specific value and decrement it to zero)
- Between each count, there's a check on the input port for the specific parameters:
    - If i/p = 03h / 0011b -> Terminate counting
    - If i/p = 20h / 0010 0000b -> Freeze the counter, wait for further instruction. On freezing the counter, the code will keep looping until a new instruction is given.
      - If i/p = 80h / 1000 0000b -> Increment the counter by 1, during freeze mode only.
      - If i/p = 40h / 0100 0000b -> Decrement the counter by 1, during freeze mode only.
      - If i/p = 08h / 0000 1000b -> Left shift the counter value once, during freeze mode only.
      - If i/p = 04h / 0000 0100b -> Right shift the counter value once, during freeze mode only.
      - If i/p = 30h / 0011 0000b -> Unfreeze the counter. It should continue as it was.
    - In case of incremental, upon reaching 255 (FFh), decrement mode starts to count to zero.
    - In case of decremental, upon reaching 0   (00h), increment mode starts to count to 255.

# Schematic
![image](https://github.com/Kirollos/8086-MP-Project/assets/4985416/d0e49e32-de97-462f-a41e-da65c6bef4d1)


# Demo Video

https://www.youtube.com/watch?v=UZK2iCotob4
