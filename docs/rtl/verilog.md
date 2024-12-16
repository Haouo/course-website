!!! info
    - Contributors: TA 汎穎、TA 宜蓁、TA 峻豪
    - Last update: 2024/12/16

## 簡介

> Verilog HDL is a formal notation intended for use in all phases of the creation of electronic systems.
> Because it is both machine-readable and human-readable, it supports the development,
>  verification, synthesis, and testing of hardware designs; the communication of hardware design data; and the maintenance, modification, and procurement of hardware.
> The primary audiences for this standard are the implementors of tools supporting the language and advanced users of the language.<br>
> ----- [IEEE Standard for Verilog® Hardware Description Language](https://www.eg.bucknell.edu/~csci320/2016-fall/wp-content/uploads/2015/08/verilog-std-1364-2005.pdf)

Verilog 最初的開發目的是提供一個語言，讓設計者可以描述和模擬硬體行為，從而加速數位電路設計的過程。
這種語言的發展背景是基於數位電路的複雜性不斷增加，設計者需要一種高階的工具來取代手工設計與模擬。

Verilog 在 1995 年成為 IEEE 1364 標準的一部分，並在 2001 年和 2005 年經過了兩次主要更新，進一步增強了語言功能。
IEEE 1364-2005 是 Verilog 最重要的版本之一，包含了對語言的擴充，以支援更強大的建模功能、合成和驗證工具。

Verilog 最初的創造目的是為了電路驗證，而非設計。它最早是在 1980 年代由 Gateway Design Automation 公司開發，作為一種用來進行數位電路行為模擬的語言。
當時，設計者面臨著越來越複雜的數位電路，並需要一種高階工具來進行設計的驗證和模擬。
隨著設計工具和合成技術的進步，Verilog 開始從模擬語言逐漸演變為一個能夠描述硬體設計的語言。
設計者不僅可以用 Verilog 進行模擬，還可以用它來描述硬體的結構和行為，並進行合成，即從 Verilog 程式碼生成實際的硬體電路，但是合成（Synthesis）實際的電路的時候需要 EDA 工具的配合。

## Data Types（資料型態）

在講述如何用 Verilog 描述電路之前，我們必須先搞清楚 Verilog 這個語言中到底有哪些 Data Types。總地來說，在 Verilog 中的資料型態可以分成兩大類，分別是 **Net** 和 **Variable**。

Net 資料類型可以代表結構實體之間的物理連接，例如邏輯閘之間的連線。Net 不會儲存一個值。其值應由驅動器的值來決定，例如 continuous assignment 或邏輯閘。

Variable 是一種資料儲存元素的抽象概念。變數會從一次賦值儲存值到下一次賦值。程式中的賦值語句會作為一個 trigger，改變儲存在資料儲存元素中的值。`reg`、`time` 和 `integer` 資料類型的初始化值應為未知值 `x`。

基本上大家常用到的 `wire` 就屬於 Net Data Type，`wire` 本身不會儲存任何值，而是由 Driver 去決定 `wire` 的值，基本上概念就跟電路中的**導線**是一樣的。而另外一個常用的 Data Type `reg` 則屬於 Variable Data Type，它本身會實際地儲存一個值，並且這個值會在下一次被賦值（assign）的時候改變。

## Scalar, Vector and Array

> A net or reg declaration without a range specification shall be considered 1 bit wide and is known as ascalar. Multibit net and reg data types shall be declared by specifying a range, which is known as a vector.
> ----- IEEE 1364-2005

當 `wire` 和 `wire` 在宣告的時候如果沒有被指定 range 的話，則應該被當成 1-bit，其稱為 *Scalar*，反之如果有指定 range，如 `wire[31:0] a`，則被稱為 *Vector*，其寬度為 32-bit。Scalar 的概念大家應該不會有疑問，但是 Vector 和 Array 這兩個大家可能會搞混，Array 我們待會會介紹。至於 Vector，大家可以想成許多 bits 的集合就是 Vector。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/3294ca18-165f-47cf-aed2-2f5cfabcc899.png)

我們可以把許多個 Scalar 或是許多個 Vector 再集合起來，這時候就會變成 *Array*。

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

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/f603ddfd-a216-4b86-a76a-191b2a7b11c4.png)

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

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/25c61cf8-0369-420f-b650-477648e2a215.png)

    > 圖片來源 : https://tomorrow0w0.gitbooks.io/nand2tetris-homework/content/assets/FullAdder.png
    
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
        
        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7853b2eb-cb09-4cc7-9e01-9db4ec3c3c92.png)
        
        ==hint: 通常n bits會用 [n-1: 0]來編號==
        
        - reference to one of the wires/ regs in a vector
            ```verilog
            wire [1:0] a;
            wire [0:2] b;
            wire [-2:0] c;

            and and0(a[0], b[1], c[-2]);
            ```
            
            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/b24940bf-fd07-40c1-b5b0-1749c4ab2847.png)
            
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
            
            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/3218a199-e7dc-4cf3-a6fc-0e352e56f08e.png)
    3. Array: A lot of scalars/ vectors
        ```verilog
        wire arr_scalar [0:7];
        wire [3:0] arr_vector [0:7];
        ```
        
        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/014e37e9-8ae6-42f6-aa08-23a4bdd1e07c.png)
        
        - reference to a single line in an array
            ```verilog
            wire arr_scalar [0:7];
            not not0(arr_vector[0][2], arr_vector[7][1]);
            ```

            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/8fea8ac4-8c78-4ae2-850c-209abcb732f6.png)

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
    
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/04771113-c2d2-4009-aaef-3f6c38d25d07.png)
    
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
        
        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/1615c777-6762-4f64-8c78-f4a2e2828ec8.png)
    3. Reduction
        ```verilog
        wire [3:0] op1;
        assign op1=4'b1011;

        wire g, h;

        assign g=&op1; //(1&0&1&1)=0
        assign h=^op1; //=1
        ```
        Reduction將input vector中的所有bits一起運算，運算結果只有0或1兩種(eg: 下圖的xor)

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/8b65c1e6-a7a1-4964-8765-7b0f32d681fc.png)
    4. Conditional(Ternary)
        ```verilog
        wire sel;
        wire [3:0], in0, in1, out;
        assign out=sel? in1: in0; //condition? if true: if false
        ```
        跟Cpp中的Ternary operator差不多，對應到數位電路上基本上就是MUX

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/db512cc4-6d7e-43f1-84c2-448cfad7a4d8.png)
    5. Replication and concatenation
        ```verilog
        wire [7:0] byte;
        wire [15:0] halfword;
        assign halfword = {{4'd8{byte[7]}}, byte};
        ```
        - Replication: {op1{op2}}即將op2複製op1次
        - Concatenation: 並排多個input

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/738afcc2-1296-40a5-8c90-cdaed57e5e7d.png)
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

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/fbee2eb9-db7d-4d6d-b100-ff1843353233.png)
    
    > 圖片來源 : https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Full-adder.svg/825px-Full-adder.svg.png
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

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/10a0ce35-b9b9-4c35-89da-8113023a94be.png)
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

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/372736e5-b0d8-41c9-af2f-4154780c48fc.png)
        
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

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/dffad851-0099-4662-a132-b9d26495f386.png)

## Sequential Circuit
- Latch, Flip-Flop(FF), Register
    1. Clock: 
    
        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/cb037322-ec90-40f7-8725-39a658235a91.png)
        
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

            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a7dd97e2-6669-4e39-b140-b9fa4631ebad.png)

            eg: D-Latch
            
            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/255031ea-e394-48db-a369-e0415b486261.png)
            
            | clk | Q         | Q bar     |
            |:--- |:--------- |:--------- |
            | 0   | No Change | No Change |
            | 1   | D         | ~D        |
            
            電路狀態在Clock level為high時可改變。
        - FF:
            Edge triggered, 在Control input的Rising edge(Active high)或Falling edge (Active low)時，電路狀態可改變。

            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/ec033ae7-9796-4170-a794-1fb018775f40.png)

            eg: D-FF

            ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/26785bbf-f298-4540-ba65-1e0cc16cdb77.png)

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

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/afd1548e-5788-419f-ac0f-af8b251ed065.png)
    
    2. Sequential Circuit
        有Memory element,會記住上個時刻的電路狀態。電路狀態由當下的input及上個時刻的電路狀態決定。

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/1fceff8e-b964-4ddb-878f-cba47b5f5e33.png)
    
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

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/34f891d7-bb92-4a27-b56d-46105bf0d493.png)
        
        範例:

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a138bd12-6f23-4a3e-95e8-398a5da94f5d.png)

        
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

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/9fa97086-2b8d-4217-9797-85bc29e02ce6.png)

        
    2. Mealy Machine
        - current state==及input==共同決定output。
        - current state和input共同決定next state。
    
        Mealy machine的電路架構:

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/3ac9ec07-17f4-46da-9b85-fcce9f7ee6d2.png)
        
        範例:

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a0585bb0-7b21-4c58-bbf3-d05d3873ec19.png)

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

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/44a5976a-c7ea-47cf-ae7b-d586b2f6edee.png)
