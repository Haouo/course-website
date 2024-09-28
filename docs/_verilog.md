# Introduction to Verilog

!!! info
    - Contributor：TA 汎穎、TA 宜蓁
    - Last Update：2024/09/22

---

## 簡介
- 硬體描述語言(HDL), 用來描述電路的行為及架構
    ![](/uploads/06aa8f3ad28bd1c1cbb134925.png)

## Gate Level

- Constructing a module (by primitive gate)
    範例: Half Adder

    ```verilog linenums="1"
    module HA /*module name*/ (
      input A,B,
      output S,C
    );
    
    xor xor0(S, A, B); //gate_name instance_name (out, in1, in2,...);
    and and0(C, A, B);
    
    endmodule
    ```

    ![](/uploads/06aa8f3ad28bd1c1cbb134947.png)

    1. I/O port就是HA的input及output, 沒有特別宣告的話都是wire, 如果有需要也可以宣告成output reg 。
    2. Verilog 中有"原生邏輯匣(primitive gate)"(eg: not, and, or, nand,...)可以直接使用, 第一格接的是邏輯匣的output。
- Connecting Your own module
    寫好一個module之後，就可以像使用一個封裝好的元件一樣直接使用。
    範例: Full Adder

    ```verilog
    `include "halfadder.sv"
    module FA(
        input A,B,Cin,
        output Cout,S
    );
    
    wire c0,c1,s0;
    
    HA ha0(A, B, s0, c0); //module_name instance_name ports (by order list)
    HA ha1(.A(s0), .B(Cin),
           .S(S), .C(c1)); //module_name instance_name ports (by name)
    or or0(Cout, c0, c1);
    
    endmodule
    ```

    ![](/uploads/06aa8f3ad28bd1c1cbb134927.png)
    *圖片來源:https://tomorrow0w0.gitbooks.io/nand2tetris-homework/content/assets/FullAdder.png*
    
    連接module的I/O portz方式大致可分成: 
    1. by ordered list: 依照HA中的I/O port順序, 將要接到HA的線填在對應接口; 原生邏輯匣只能用by ordered list的接法。
    2. by name: 先寫HA的port name, ()中填要接到HA的線。
- Scalar, Vector, Array
    1. Scalar: A single wire/ reg
    2. Vector: A bunch of wires/ regs
        ```verilog
        wire [1:0] a;
        wire [0:2] b;
        wire [-2:0] c;
        wire [3:0] d;
        wire [2:0] e;
        ```
        ![](/uploads/06aa8f3ad28bd1c1cbb13492a.png)
        ==hint: 通常n bits會用 [n-1: 0]來編號==
        
        - reference to one of the wires/ regs in a vector
            ```verilog
            wire [1:0] a;
            wire [0:2] b;
            wire [-2:0] c;

            and and0(a[0], b[1], c[-2]);
            ```
            ![](/uploads/06aa8f3ad28bd1c1cbb134929.png)
        - reference to multiple lines continuously in a vector
            ```verilog
            module Adder2bits(
                input [1:0] in0, in1;
                output [1:0] sum,
                output cout
            );

            //...

            endmodule
            ```
            ```verilog
            ///...
            wire[3:0] operand0, operand1;
            wire[1:0] sum0;
            wire cout0;

            Adder2bits adder0(.in0(operand0[1:0]), .in1(operand1[1:0]), .sum(sum0), .cout(cout0);
            //adding lower 2 bits of operand1 and operand2
            ```
            ![](/uploads/06aa8f3ad28bd1c1cbb13492b.png)
    3. Array: A lot of scalars/ vectors
        ```verilog
        wire arr_scalar [0:7];
        wire [3:0] arr_vector [0:7];
        ```
        ![](/uploads/06aa8f3ad28bd1c1cbb13492d.png)
        
        - reference to a single line in an array
            ```verilog
            wire arr_scalar [0:7];
            not not0(arr_vector[0][2], arr_vector[7][1]);
            ```
            ![](/uploads/06aa8f3ad28bd1c1cbb13492e.png)

            First index: selecting the corresponding vector.
            Second index: selecting the line in the vector.
- 在電路比較複雜時，用Gate level的寫法會變得很麻煩，所以以下介紹更Behavioral的寫法。
## Continuous Assignment
- 基本寫法
    ```verilog
        assign 左 = 右;
    ```
   - 其中右值可以是常數, x(unknown), z(high impedance), 另一條wire/reg(s), 或expression,...; 將右邊的signal接到左邊。
   - 多個Continuous assignment之間“沒有”先後順序關係
    ```verilog
    wire a, b, c;
    wire highzee;

    assign a = b & c;
    assign highzee =1'bz;
    ```
    ![](/uploads/06aa8f3ad28bd1c1cbb13492f.png)
    
- 右值為常數, x, z
    1. Data can have different bit length. (Default: 32 bits).
    2. Data can be expressed in different format. (Default: decimal)
    3. 可以在數字之間加underscore("_")(第一個digit不可以是underscore)
    ```verilog
    wire [31:0] a, b;
    wire [7:0] c;
    wire [3:0] d,e;

    assign a=15; //32bits decimal 15
    assign b='h837FF; //32 bits hexidecimal 837FF
    assign c=8'b11_0010 //8 bits binary 110010
    assign d=4'b10; //4 bits binary 10
    assign e=4'b01x; //4 bits number, with LSB unknown
    ```
    ==hint: assign的時候最好讓左右值的bit length相同==
- 右值為Expression (operand, operator)
    | Operator           | Description        | Usage               |
    | ------------------ | ------------------ | ------------------- |
    | +, -, *, /, %      | Arithmetic         | op1 + op2           |
    | !                  | Logical negation     | !op                 |
    | &&, \|\|, ==, !=   | Logical operator   | op1&&op2            |
    | <<, <<<, >>, >>>   | Shift operator     | op1<<op2            |
    | {}                 | Concentation       | {op1, op2, ...}     |
    | &, \|, ^, ^~       | Bitwise operation  | op1 &op2            |
    | ~                  | Bitwise negation   | ~op                 |
    | &, ~&, \|, ~\|, ^~ | Reduction operator | &op                 |
    | ?:                 | Conditional        | condition? op1: op2 |
    | {{}}               | Replication        | {op1{op2}}          |
    Further explanation
    1. Logical
       ```verilog
        wire [3:0] op1, op2, op3;
        assign op1=4'b1011;
        assign op2=4'b0010;
        assign op3=4'b0;

        wire a, b, c;

        assign a=!op3; //1
        assign b=!op1; //0
        assign c=op1&&op2; //1
        ```
        Logical的運算結果只可能有0或1兩種
    2. Bitwise
        ```verilog
        wire [3:0] op1, op2, op3;
        assign op1=4'b1011;
        assign op2=4'b0010;
        assign op3=4'b0;

        wire [3:0] d ,e ,f, g;

        assign d=~op1; //4'b0100
        assign e=~op3; //4'b1111
        assign f=op1&op2; //and, 4'b0010
        assign g=op1^op2; //xor, 4'b1001
        ```
        Bitwise會對每一個bit分別運算(eg: 下圖的Bitwise negation)
        ![](/uploads/06aa8f3ad28bd1c1cbb134930.png)
    3. Reduction
        ```verilog
        wire [3:0] op1;
        assign op1=4'b1011;

        wire g, h;

        assign g=&op1; //(1&0&1&1)=0
        assign h=^op1; //=1
        ```
        Reduction將input vector中的所有bits一起運算，運算結果只有0或1兩種(eg: 下圖的xor)
        ![](/uploads/06aa8f3ad28bd1c1cbb134931.png)
    4. Conditional(Ternary)
        ```verilog
        wire sel;
        wire [3:0], in0, in1, out;
        assign out=sel? in1: in0; //condition? if true: if false
        ```
        跟Cpp中的Ternary operator差不多，對應到數位電路上基本上就是MUX
        ![](/uploads/06aa8f3ad28bd1c1cbb134933.png)
    5. Replication and concatenation
        ```verilog
        wire [7:0] byte;
        wire [15:0] halfword;
        assign halfword = {{4'd8{byte[7]}}, byte};
        ```
        - Replication: {op1{op2}}即將op2複製op1次
        - Concatenation: 並排多個input
        ![](/uploads/06aa8f3ad28bd1c1cbb134934.png)
- 範例: Full adder (Continuous assignmaet)
    ```verilog
    module FA(
        input A,B,Cin,
        output Cout,S
    );
    
        assign Cout = (A&B) | (Cin & (A^B));
        assign S=Cin^A^B;
    endmodule
    ```
    ![](/uploads/06aa8f3ad28bd1c1cbb134935.png)
    *圖片來源:https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Full-adder.svg/825px-Full-adder.svg.png*
## Procedural Block
- 分成always block和initial block, 後者通常用在Testbench中。以下都先以always block為主。
- 更"program-like", 但還是要記得自己是在寫"電路"。
- 基本寫法
    ```verilog
    reg a, b;
    always @(sensitive list) begin
        a = .....;
        b = .....;
    end
    ```
    1. 用begin, end 包起來。
    2. Sensitive list: 
        每當sensitive list中任一個signal改變時，會trigger 該always block 執行一次，並update左值。若sensitive list 中的signal沒有改變, 左值就會維持不變。
        如果希望寫出continuous assignment的效果，則sensitive list中要包含always block內的所有右值, 可以直接寫成
    ```verilog
    always @(*) begin
        a = .....;
        b = .....;
    end
    ```
    3. always block中的左值一定要宣告成reg型態 (在always block沒被trigger時, 左值要"維持") , 但合成後不一定會是register。
    
    範例: Full adder
    ```verilog
    module FA(
        input A,B,Cin,
        output reg Cout,S 
    );
    
    always @(A, B, Cin) begin    //always @(*) begin    
       Cout = (A&B) | (Cin & (A^B));
       S=Cin^A^B; 
    end
        
    endmodule
    ```
- Blocking assignment
    在Procedural Block中可以分成Blocking assignment(=)跟Non-Blocking assignment(<=)(Non-blocking的部分Sequential再細講)。
    Blocking assignmen跟cpp, c,...比較類似, 會一行一行依序執行。
    範例： Full adder
    ```verilog
    module FA(
        input A,B,Cin,
        output reg Cout, S
    );
        
    always @(*) begin
        {Cout, S} = A; //execute first
        {Cout, S} = {Cout, S}+B;
        {Cout, S} = {Cout, S}+Cin; //execute last
    end
        
    endmodule
    ```
- case
    - 跟switch case很像, 比對條件之後執行對應的statement(s)
    - 建議都要寫default case, 避免遺漏, 如果要合成也比較不會出現多餘的Latch
    
    範例：4 to 1 MUX
    ```verilog
    module MUX(
        input in00, in01, in10, in11,
        input s0, s1, //select
        output reg out
    );
        
    always @(*) begin
        case ({s1, s0})
            2'b00: begin
                out=in00;
            end
            2'b01: begin
                out=in01;
            end
            2'b10: begin
                out=in10;
            end
            2'b11: begin
                out=in11;
            end
            default: begin
                out=1'b0;
            end
        endcase
    end
        
    endmodule
    ```
    ![](/uploads/06aa8f3ad28bd1c1cbb134940.png)
- if/else
    - 跟cpp等的if/else很像
    - 建議最後都要寫else, 也是為了避免遺漏跟合成出多餘的Latch
    
    範例： 4 to 1 MUX
    ```verilog
    module MUX(
        input in00, in01, in10, in11,
        input s0, s1,
        output reg out
    );
        
    always @(*) begin
        if(s0==1'b0) begin
            out= s1?in01:in00;
        end
        else if(s0==1'b1) begin
            out= s1?in11:in10;
        end
        else out=1'b0;
    end
        
    endmodule
    ```
- for loop
    verilog中for loop內的statement會被展開成多個==並行==的硬體結構(==不是迭代執行==, 使用時要特別注意)。
    - index通常會宣告成integer型態
    - verilog沒有"i++"這種寫法，要寫成i=i+1。
    
    範例1:
    ```verilog
    reg[9:0] a;
    integer i;
    always @(*)begin 
        for(i=0; i<10; i=i+1) begin
            a[i]=1'b0;
        end
    end
    ```
    ![](/uploads/06aa8f3ad28bd1c1cbb134955.png)

        
    範例2: 此例會生成10個乘法器，而不是用同一個乘法器依序執行10次乘法。
    ```verilog
    integer i;
    reg[9:0] a,b,c;
    always @(*)begin 
        for(i=0; i<10; i=i+1) begin
            a[i]=b[i]*c[i];
        end
    end
    ```
## 補充: generate block
經常配合for loop使用，用來生成多個相同的元件。
- 用generate, endgenerate包起來。
- for loop的index部分必須宣告成genvar型態。
- for loop最好要加label(範例1中的"BLOCK1", 範例2的FA_BLOCK)。
- generate block中要用continuous assignment，左值可為wire或reg。
- generate block中也可以配合if else, case的語法，依據特定條件選擇要生成的元件。
    
範例1: 與前面for loop的範例1做的事一樣

```verilog
wire[9:0] a;
genvar i;
generate 
    for(i=0; i<10; i=i+1) begin: BLOCK1 //label
        assign a[i]=1'b0;
    end
endgenerate
```

範例2: 用4個FA組成的RCA
```verilog
`include "FA.sv"
module RCA(
    input [3:0] X, Y,
    output [3:0]S,
    output Cout
);
wire[4:0] c;
assign Cout=c[4];
assign c[0]=1'b0;

genvar i;
generate
    for(i=0; i<4; i=i+1) begin: FA_BLOCK
        FA fa(.x(X[i]), .y(Y[i]), .cin(c[i]), .cout(c[i+1]), .s(S[i]));
    end
endgenerate
endmodule
```
![](/uploads/06aa8f3ad28bd1c1cbb134956.png)

## Sequential Circuit
- Latch, Flip-Flop(FF), Register
    1. Clock: 
    
        ![](/uploads/06aa8f3ad28bd1c1cbb134942.png)
        
        - Clock period (i.e. Cycle time): 兩個Rising edge的時間間隔。(second/cycle)
        - Clock frequency: 每秒有幾個Cycle, Clock period的倒數。(cycle/second)
        - Clock width: 一個Cycle中Clock signal為high的時間長度。
        - Duty cycle: Clock width/ Clock period。
        - Active high: 電路的狀態在Clock為High或Rising edge時改變。
        - Active low: 電路的狀態在Clock為Low或Falling edge時改變。
    2. Latch & FF
        Latch和FF都是電路中的儲存裝置，電路的狀態會隨control signal(常為clock)改變。
        - Latch:
            Level triggered, 在Control input為high(Active high)或low(Active low)時，電路狀態可改變。
            ![](/uploads/06aa8f3ad28bd1c1cbb134945.png)

            eg: D-Latch
            ![](/uploads/06aa8f3ad28bd1c1cbb134943.png)
            
            | clk | Q         | Q bar     |
            |:--- |:--------- |:--------- |
            | 0   | No Change | No Change |
            | 1   | D         | ~D        |
            
            電路狀態在Clock level為high時可改變。
        - FF:
            Edge triggered, 在Control input的Rising edge(Active high)或Falling edge (Active low)時，電路狀態可改變。
            ![](/uploads/06aa8f3ad28bd1c1cbb134946.png)

            eg: D-FF
            ![](/uploads/06aa8f3ad28bd1c1cbb134944.png)
            
            | clk         | Q         | Q bar     |
            |:----------- |:--------- |:--------- |
            | Rising edge | D         | ~D        |
            | Others      | No Change | No Change |
            
            電路狀態只在Clock的Rising edge可改變，High level, Low level及Falling edge時都維持不變。
            
            *edge trigger的verilog寫法:*
            ```verilog
                input clk; //clock
                
                //Rising edge:
                always @(posedge clk) begin
                    //...
                end
            ```
            ```verilog
                input clk; //clock
                //Falling edge:
                always @(negedge clk)begin
                    //...
                end
            ```
        - 相較於Latch, FF電路狀態可改變的時間較短，故較為穩定，實作Sequential circuit通常都會用FF(也就是Edge triggered的寫法)，盡量避免使用Latch。
    3. Synchronous & Asynchronous Reset
        電路在剛通電時通常需要設定初始值, 稱為Reset
        - Synchronous reset:
            ```verilog
                input clk; //clock
                input rst; //reset
                output reg out;
        
                always @(posedge clk) begin
                    if(rst) 
                        out<=1'b0;
                    else
                        //...
                    
                end
            ```
            以Rising edge triggered的電路為例，要在Rising edge==且==reset訊號為active時才能進行reset。
        - Asychronous reset:
            ```verilog
                input clk; //clock
                input rst; //reset
                output reg out;
        
                always @(posedge clk or posedge rst) begin
                    if(rst) 
                        out<=1'b0;
                    else
                        //...
                    
                end
            ```
            Reset不受clock的影響，不須等待clock edge即可進行。
- Combinational v.s. Sequential
    1. Combinational Circuit
        電路狀態由只由當下的input決定。
    ![](/uploads/06aa8f3ad28bd1c1cbb134948.png)
    2. Sequential Circuit
        有Memory element,會記住上個時刻的電路狀態。電路狀態由當下的input及上個時刻的電路狀態決定。
    ![](/uploads/06aa8f3ad28bd1c1cbb134949.png)
    
    *常見的Memory element: 
        Register, Counter(計數器), Register file, Memory, Queue, Stack...* 
- Blocking v.s. Non-Blocking
    如同前面提過的，多個Blocking assignment(=)之間會依序執行。多個Non-Blocking assignment(<=)之間則沒有先後順序關係，會同時執行。
    eg: 假設a, b初始值分別為0, 1
    - Blocking assignment: 
        ```
        a=b; //a=0
        b=a; //b=0
        ```
        先執行a=b: a值變為0。再執行b=a: b值也變為0。
    - Non-Blocking:
        ```
        a<=b; //a=0
        b<=a; //b=1
        ```
        同時執行兩行, a值變為0, b變為1。(兩行順序可對調，不影響執行結果)
    - 注意事項
        1. Combinational circuit中通常用Blocking assignment
        2. Sequential circuit中通常用Non-Blocking, 在Clock edge時同步進行所有reg的update。
        3. 兩種assignment都要寫在Procedural block中。
        4. 同一個Procedural block中不要混用Blocking跟Non-Blocking。
- Finite State Machine (FSM)
    會依據特定的輸入，在有限多個狀態(State)之間轉換(Transition)。
    
    FSM可再依據output的決定方式分成Moore machine及Mealy machine。
    1. Moore Machine
        - current state直接決定output。
        - current state和input共同決定next state。
        
        Moore machine的電路架構:
        ![](/uploads/06aa8f3ad28bd1c1cbb13494a.png)
        
        範例:
        ![](/uploads/06aa8f3ad28bd1c1cbb134951.png)

        
        | Current state | Next state (in=1) | Next state (in=0) | Output |
        | ------------- | ----------------- | ----------------- | ------ |
        | S0            | S1                | S0                | 0      |
        | S1            | S2                | S0                | 1      |
        | S2            | S0                | S2                | 2      |

        Code:
        ```verilog
        module Moore(
            input clk, rst,
            input in,
            output reg[2:0] out
        );
        parameter S0=2'd0, S1=2'd1, S2=2'd2;
        reg [1:0] cs, ns; //current state, next state

        //State register
        always @ (posedge clk) begin
            if(rst) 
                cs<=S0;
            else
                cs<=ns;
        end

        //next state logic
        always @(*) begin
            if(cs==S0) 
                ns=in?S1:S0; //in為1=>S1, in為0=>S0
            else if(cs==S1)
                ns=in?S2:S0;
            else if(cs==S2)
                ns=in?S0:S2;
            else
                ns=2'd3;
        end

        //output logic
        always@(*) begin
            if(cs==S0)
                out=3'd0;
            else if(cs==S1)
                out=3'd1;
            else if(cs==S2)
                out=3'd2;
            else
                out=3'd3;
        end

        endmodule
        ```
        
        Waveform:
        ![](/uploads/06aa8f3ad28bd1c1cbb134953.png)

        
    2. Mealy Machine
        - current state==及input==共同決定output。
        - current state和input共同決定next state。
    
        Mealy machine的電路架構:
        ![](/uploads/06aa8f3ad28bd1c1cbb13494d.png)
        
        範例:
        ![](/uploads/06aa8f3ad28bd1c1cbb134952.png)

        | Current state | Next state (in=1) | Next state (in=0) | Output (in=1) | Output (in=0) |
        | ------------- | ----------------- | ----------------- | ------------- | ------------- |
        | S0            | S1                | S0                | 1             | 0             |
        | S1            | S2                | S0                | 3             | 2             |
        | S2            | S0                | S2                | 5             | 4             |

        Code:
        ```verilog
        module Mealy(
            input clk, rst,
            input in,
            output reg[2:0] out
        );
        parameter S0=2'd0, S1=2'd1, S2=2'd2;
        reg [1:0] cs, ns; //current state, next state

        //State register
        always @ (posedge clk) begin
            if(rst) 
                cs<=S0;
            else
                cs<=ns;
        end

        //next state logic
        always @(*) begin
            if(cs==S0) 
                ns=in?S1:S0; //in為1=>S1, in為0=>S0
            else if(cs==S1)
                ns=in?S2:S0;
            else if(cs==S2)
                ns=in?S0:S2;
            else
                ns=2'd3;
        end

        //output logic
        always@(*) begin
            if(cs==S0)
                out=in?3'd1:3'd0;
            else if(cs==S1)
                out=in?3'd3:3'd2;
            else if(cs==S2)
                out=in?3'd5:3'd4;
            else
                out=2'd6;
        end

        endmodule
        ```
        
        Waveform:
        ![](/uploads/06aa8f3ad28bd1c1cbb134954.png)
