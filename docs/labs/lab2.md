# RTL Programming Review using SystemVerilog

!!! info
    - Contributors：TA 汎穎、TA 宜蓁、TA 卉蓁、TA 峻豪
    - Deadline : ==2024/XX/XX==
    - Last updated : 2024/XX/XX

---

!!! danger
    如果你還不熟悉 Verilog/SystemVerilog，請先看 [Verilog Tutorial]() 和 [SystemVerilog Tutorial]()。

## Part I. Combinational Circuit: Radix-4 Booth Multiplier with Wallace Tree

### Traditional Signed Array Multiplier

!!! info
    在 Binary Arithmetic 中，乘以 $2^{n}$ 代表左移 n bits（LSB補零）

- 兩個 n bits的有號數X[n-1 :0], Y[n-1 :0]相乘, 可表示為:

    $$
    \begin{equation}
    X \times \{(-Y_{n-1} \times 2^{n-1}) + (Y_{n-2} \times 2^{n-2}) + (Y_{n-3} \times 2^{n-3}) + ... + (Y_1 \times 2^1) + (Y_0 \times 2^0)\}
    \end{equation}
    $$

    將X分別乘入之後，原式變成n個部分積(Partial product)相加。

- 以4 bits乘法器為例，其計算過程可由 (1) 經以下過程化簡:
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/34e03dcb-1fa4-4cf4-8059-6b2fe2d31ebc.png)


- 由化簡結果可得對應的乘法器電路為:
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/ae3edcd1-9eed-42c6-9faa-7a82416a0452.png)

    - 每一列都是 Ripple-Carry Adder (RCA) 的架構，同一列中第 n+1 個 bit 的加法需等待第 n 個 bit 的 carry 算完才能進行
    - 第一個部分積與第二個部分積相加求得和後，再與第三個部分積相加...，每一列的加法都要等上一列加法完成才能進行
    - Critical path 共需要經過 9 個 Adder（2 個 Half adder + 7 個 Full adder），會造成乘法器有很長的 Delay，尤其當 Operand 的位寬增加時，Critical Path 也會隨之加長

    > 圖片來源: https://www.researchgate.net/profile/Kailiang-Chen/publication/42437163/figure/fig21/AS:669375262650375@1536602907079/4-The-block-diagram-of-a-4-bit-signed-multiplier.ppm*

以下將介紹兩種優化乘法器的效率的方法

### 2. Booth Algorithm (Radix-4)

- 前述的n bits有號數乘法 Equation (1) 可經由簡單的運算可再進一步表示為:

    $$
    \begin{equation}
    X \times \{(Y_{n-3} + Y_{n-2} - 2 \times Y_{n-1})\times 2^{n-2} + (Y_{n-5} + Y_{n-4} - 2 \times Y_{n-3})\times 2^{n-4} +\\ (Y_{n-7} + Y_{n-6} - 2 \times Y_{n-5})\times 2^{n-6} +...+ (Y_1 + Y_2 - 2 \times Y_3)\times 2^2 + (Y_{-1} + Y_0 - 2 \times Y_1)\times 2^0 \} 
    \end{equation}
    $$

    > *註：Y ~-1~=0*<br>
    > *註：由於 Equation (2) 過長，請把游標放在方程式上並且按住 Shift 同時移動滾輪，就可以查看整個算式*

    將X分別乘入之後，原式變成n/2個Partial product相加，相較於原本的n個Partial sum減少了一半，這就是Booth encoding能提升乘法器效能的原因。

- Equation (2) 可對應到下方的Radix-4 Booth編碼：

    |$Y_{i+1}$ | $Y_i$ | $Y_{i-1}$ |編碼(=X*(Y~i-1~ + Y~i~ - 2 *Y~i+1~) )|
    | :-- | :-- |:--|:--|
    |0|0|0|0|
    |0|0|1|X|
    |0|1|0|X|
    |0|1|1|2X|
    |1|0|0|-X|
    |1|0|1|-X|
    |1|1|0|-X|
    |1|1|1|0|

    以 X=4'b0010, Y=4'b1101 為例, $X\times Y = (-X)\times 2^2+ (X) \times 2^0$ = 8'b11111000 + 8'b0000010 = 8'b11111010
    
### 3. Wallace Tree
- Wallace Tree用於執行Partial product的加法，以下用8bits unsigned乘法器為例:

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/24849d17-9b17-4041-84b9-290843aaede8.png)

    > *圖片來源: https://i-blog.csdnimg.cn/blog_migrate/a3f2c99c94ebfc49f4db7c4a9f0f13b3.png*
    
    a[7:0]與b[7:0]相乘之後共產生8個Partial product，相同乘積位(同一行)的為一組，各組分別用支援8bit相加的Wallace Tree相加。

- **CSA(Carry Save Adder)**<br>
    Wallace Tree的加法主要使用的是CSA的架構，以下簡單比較RCA與CSA。
    - 以執行X, Y, Z三個4 bits數字的加法為例，採用2級RCA的電路架構如下圖:
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/2b0ed07d-e147-445d-9aa5-f852e90e2d90.png)
    如同前面提過的，同一級之間會有Carry的傳遞，需等待上一位的Carry算完才能進行下一位的加法。
    - 一樣執行X, Y, Z三個4 bits數字的加法，改採一級CSA + 一級RCA的電路架構如下圖:
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7959767e-71fc-4abc-a8d1-ff6c7f162e64.png)
組成CSA的單元和RCA一樣是全加器，相異點在於CSA的架構中，同一級之間不會有Carry的傳遞，故同級之間不需等待Carry運算，可以大幅減少delay。CSA會將運算結果的Carry和Sum部分分開儲存，並傳到下一級運算。
- 支援8bits相加的Wallace Tree電路如下圖(以乘積位07為例):
    
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7d4b3206-9eb5-4915-bc6c-4a6a2db53574.png)
    *圖片來源: https://i-blog.csdnimg.cn/blog_migrate/9b29bfc1f729564d3fa0d3a7b034a145.png*
    
    圖中每一級都是CSA的架構，用來執行"同一個乘積位"的8個bits的加法，每一級算出的Carry及Sum會分別傳到下一級(Carry要進位)。
    
- 加法平行化: 
    傳統乘法器進行部分積的加法時需要一項一項依序累加，Delay會直接正比於部分積的數量。
    Wallace Tree的樹形結構則能將部分積拆分成不同乘積位，並同時進行不同乘積位的加法，達到加法平行化（Parallelism）的效果，減少Delay。然而Wallace tree的佈線複雜度較高、占用面積及功耗也較Array multiplier大。(以空間換取時間的概念)

### 4. 小結
前面提及了兩種優化乘法器效率的方法: Booth Algorithm與Wallace Tree。Booth Algorithm利用編碼的方式使Partial product數量減少; Wallace Tree則利用加法平行化提升運算速度。
Radix-4 Booth Multiplier with Wallace Tree同時運用了兩種優化方式，利用Radix-4 Booth Encoding將Partial sum減半，再利用Wallace Tree進行Partial product的相加。

### 5. Part I 實作要求
本次Lab我們要實作的內容是支援==64bits有號數乘法==用==Booth編碼==產生Partial product, 並用==Walllace Tree累加==Partial Sum的乘法器，以下是可以參考的架構：
![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/d6ba0ef6-8ef7-4d6c-858b-11cb7d65eb35.png)

1. Booth
    ```verilog
    module Booth(
        input [127:0] x,                //multiplicand
        input [2:0] y_3,        //multiplier

        output reg [127:0] p        //partial product
    );
    //your code here
    
    endmodule
    ```
    做Radix-4 Booth Encoding, 產生Partial Product
2. Partial_prod
    ```verilog
    module Partial_prod(
        input [127:0] x, y,
        output reg [127:0] p_out[31:0]
    );
    //your code here
        
    endmodule
    ```
    將32個Booth封裝成一個module。
    hint：要注意各Partial product的位數, 也就是（*式2*） 中各項的2^次方^
3. Switch
    ```verilog
    module Switch(
        input [127:0] p_in [31:0],
        output reg [31:0] p_out [127:0]//p0~ p127
    );
    //your code here
        
    endmodule
    ```
    純接線, 將32個128bits的Partial product轉成128個32bits的輸出
4. Wallace32
    ```verilog
    module Wallace32(
        input [31:0] in,
        input [28:0] cin,
        output s,cout,
        output [28:0] cout_group
    );
    //your code here
        
    endmodule
    ```
    Wallace tree, 將同一乘積位的32bits、上一個乘積位傳入的cin相加, 以下是參考架構

    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/c7e44883-a642-4d4d-b63f-f33f2f435d7a.png)

5. Wtree
    ```verilog
    module Wtree(
        input [31:0] in [127:0],
        output [127:0] s, c
    );
        //your code here
        
    endmodule
    ```
    封裝128個不同乘積位的Wallace Tree
6. Adder
   將Wtree的c、s相加（直接用加號即可, 不用自己撰寫128'的加法器） 
7. Top
    ```verilog
    module Top(
        input [63:0]x, y,
        output [127:0] out
    );
        //your code here
        
    endmodule
    ```
    連接每個module
    ==top module請務必遵守以下規範(注意大小寫)：==
    >1. 檔名：Top.sv
    >2. module 名稱： Top
    >3. I/O ports名稱及位寬皆不能更動
    
## Part II. Sequential Circuit: UART

### 1.介紹
- 嵌入式系統間傳輸資訊的常見方式。
除了UART，也有i2c、SPI等。
- 高低電位(0/1) ⬌ 欲傳遞之資訊

- 分成transmitter與receiver兩端
如何轉換與解讀(與錯誤偵測)即為UART等傳輸協議在規範的
  - transmitter : 將message轉換成0/1訊號並送出訊號
  - receiver : 接收0/1訊號並解讀message

### 2.UART訊號形式規範
![UARTsignal](https://www.amebaiot.com/wp-content/uploads/2017/05/u1.png)
由左至右，每格都是1cycle
- start bit (low)
- data bits 0~7
- stop bit (high)
> 來自峻豪學長提供的參考資料（包括錯誤偵測等詳細內容的完整文件）：
> [https://www.ti.com/lit/sprugp1](https://www.ti.com/lit/sprugp1)
> [https://wiki.csie.ncku.edu.tw/embedded/USART](https://wiki.csie.ncku.edu.tw/embedded/USART)


### 3.Verilog實作程式相關

這個部分的實作會由三個部分組成，分別是transmitter .sv、receiver .sv、testbench。需要完成的是前兩個 .sv的程式。testbench將兩份 .sv程式碼當作兩塊circuit拿來接線使用，給予&檢查回傳message。

>抱歉程式可能寫的不是非常漂亮，歡迎各位多多指教!當然，這只是一個參考模板，用其他架構去寫出UART也可以的!
>另外code中會盡量把每個brench都填滿，但在這堂課的驗證中不填滿應該也不會出問題(?

1.transmitter .sv
![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/8db43560-4856-4b34-95b4-4f41cbe7289c.png)
在程式碼中給了兩個always block。其中一個是控制tx(輸出訊號)，另一個是控制state&bit_counter(FSM的state跳轉)與shift_reg(儲存了tx要輸出的內容)。
<font color="#A8AAAC">start_tx是testbench給的，tx_done則是給testbench的小小外部訊號</font>

```sh
always @(posedge clk or posedge reset) begin
    if(reset) begin
        ...
        tx_done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                ...
                tx_done <= 1'b0;
            end
            START: begin
                ...
                tx_done <= 1'b0;
            end
            DATA: begin //bit_counter 0~5
                ...
                tx_done <= 1'b0;
            end
            STOP: begin
                ...
                tx_done <= 1'b1;
            end
        endcase
    end
end
```

```sh
always @(posedge clk or posedge reset) begin
    if(reset) begin
        ...
    end else begin
        case (state)
            IDLE: begin
                if(start_tx) begin
                    ...
                end else begin
                    state <= state;
                    shift_reg <= 6'b0;
                end
                bit_counter <= 3'b000;
            end
            START: begin
                ...
            end
            DATA: begin //bit_counter 0~5
                ...
                if(bit_counter == 3'b101) begin
                    ...
                end else begin
                    state <= state;
                    bit_counter <= bit_counter + 1'b1;
                end
            end
            STOP: begin
                ...
            end
        endcase
    end
end
```

2.receiver .sv
![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/138bee48-ad24-412f-9cec-b32de69b19e1.png)
在程式碼中給了兩個always block。其中一個是控制rx_done(輸出message)與shift_reg(接收並儲存從transmitter來的0/1訊號)，另一個是控制state&bit_counter(FSM的state跳轉)。
<font color="#A8AAAC">rx_done是給testbench的小小外部訊號</font>

```sh
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ...
        rx_done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                ...
                rx_done <= 1'b0;
            end
            DATA: begin
                ...
                rx_done <= 1'b0;
            end
            STOP: begin
                if (rx == 1'b1) begin//stop bit
                    ...
                    rx_done <= 1'b1;
                end else begin
                    data_out <= 6'b0;
                    rx_done <= 1'b0;
                    shift_reg <= 6'b0;
                end
            end
        endcase
    end
end
```

```sh
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ...
    end else begin
        case (state)
            IDLE: begin
                if(rx==1'b0) begin
                    ...
                end else begin
                    ...
                end
                bit_counter <= 3'b000;
            end
            DATA: begin
                if(bit_counter == 3'b101) begin
                    ...
                end else begin
                    state <= state;
                    bit_counter <= bit_counter + 1'b1;
                end
            end
            STOP: begin
                ...
            end
        endcase
    end
end
```

最難的部分應該剩下shift_reg的寫法。可以想像一下transmitter發出訊號和receiver接收訊號的順序，會像是...沒錯!FIFO(先進先出)的queue。可以滾動調整shift_reg中的資料，每次固定取最低位的資料出來到tx/rx就行了。

## Part III. 編譯與執行Testbench

### 示範
- 以下示範使用Radix-4 Booth Multiplier with Wallace Tree 為例

#### 1. 先將要使用的testbench放入資料夾，位置與Top.sv同層

![圖片](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/21c879d9-fd5e-471c-96a1-67d6ac0115c5.png)



#### 2. 執行 verilator 產生 top module的 C++ class 和 head file
```sh
$ verilator --cc Top.sv --exe tb.cpp --trace
```
> - 之後會產生一個 obj_dir 資料夾裡面包含了所有Top.sv轉換成 cpp的 class (Top.cpp), head file (VTop.h), Makefile (VTop.mk)
>
> - 如出現warning提示可忽略

>
#### 3. 產生 VTop 執行檔
```sh
$ make -C obj_dir -f VTop.mk
```

#### 4. 執行產生的模擬檔 VTop
```sh
$ ./obj_dir/VTop
```
>模擬成功畫面
> ![圖片](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/d1f643f7-ae76-4b44-9716-8fa12835a112.png)

#### 5. 使用gtkwave查看波型
```sh
$ gtkwave wave.vcd
```
>點擊左方SST欄位中的Top，下方欄位會出現訊號 x , y, out，點擊2下波型就會出現在右方欄位
![圖片](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/791713f1-588f-460c-aac3-e7324c29768f.png)

>如果要執行不同testbench，參考上方例子並修改指令中的檔案名稱即可
