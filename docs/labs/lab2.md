# RTL Programming Review using SystemVerilog

!!! info
    - Contributors：TA 汎穎、TA 宜蓁、TA 卉蓁、TA 峻豪
    - Deadline : ==2024/XX/XX==
    - Last updated : 2024/XX/XX

---

## Chapter 1. Combinational Circuit - Radix-4 Booth Multiplier with Wallace Tree

!!! success
    關於 Two's Complement 的原理，**強烈**推薦閱讀：[解讀計算機編碼](https://hackmd.io/@sysprog/binary-representation#)、[模算術](https://hackmd.io/@YuRen-tw/modular-arithmetic)


### Two's Complement Binary to Decimal Number

通常在數位電路上實作有號數整數運算的時候，我們會使用 Two's Complement 來表示一個有號數，但你有沒有想過一個 n-bits 的有號數如何被系統性地轉換成十進位（Decimal）？

假設我們有一個 n-bits 的二進位數 $X_{\text{two}} = a_{n-1}a_{n-2}...a_0$，並且 $X_{\text{two}}$ 以二補數表示，則我們可以將其透過下面的公式轉換成十進位。

$$
\begin{equation}
X_{\text{ten}} = -a_{n-1} \times 2^{n-1} + \sum_{i=0}^{n-2}a_{i} \times 2^i
\end{equation}
$$

接下來，我們將基於這個公式來推導有號數乘法（Signed Multiplication）。

### Signed Multiplication with Baugh-Wooley Algorithm and Array Multiplier

!!! note
    在 Binary Operation 中，乘以 $2^{n}$ 代表左移 n bits（LSB補零）。至於右移操作，則必須要先區分是 Arithmetic Right-Shift 或是 Logical Right-Shift 來決定 MSB 要補 Sign-Bit 還是無條件補 0。
    如果是對一個 Signed Number 除以 $2^n$ 的話，則需要進行 Arithmetically Right-Shift，也就是必須要在 MSB 的部分補上 Sign-Bit。
    如果是對 Unsigned Number 除以 $2^n$ 的話，則要在 MSB 補零，也就是 Logically Right-Shfit。


!!! info
    提出 Baugh-Wooley Algorithm 的論文：[C. R. Baugh and B. A. Wooley, "A Two's Complement Parallel Array Multiplication Algorithm," in IEEE Transactions on Computers, vol. C-22, no. 12, pp. 1045-1047, Dec. 1973](https://ieeexplore.ieee.org/document/1672241)

假設我們有兩個 n-bits 的有號數（Signed NUmber）$X[n-1 : 0]$ 和 $Y[n-1:0]$，如果我們想要將他們相乘，則可以表示為以下形式：

$$
\begin{equation}
X \times \{\textcolor{red}{-}(Y_{n-1} \times 2^{n-1}) + (Y_{n-2} \times 2^{n-2}) + (Y_{n-3} \times 2^{n-3}) + ... + (Y_1 \times 2^1) + (Y_0 \times 2^0)\}
\end{equation}
$$

將 $X$ 乘入之後，再將 n 個**部分積**（**Partial Product**）加起來，就可以得到最終的結果。

==注意到，在有號數乘法當中，我們本來應該要對 Partial Product 進行 Sign-Extension 之後才能加總，否則會出錯==。
但是，處理 Sign-Extension 的部分會增加電路複雜度。因此，我們可以利用 **Baugh-Wooley Algorithm** 來簡化運算過程，透過特殊的技巧使我們可以不用處理 Sign-Extension 的部分。
假設我們有兩個數 $X[n-1:0]$ 和 $Y[m-1:0]$ 要相乘，則應表示為：

$$
\begin{equation}
X \times Y = (-x_{n-1} \times 2^{n-1} + \sum_{i=0}^{n-2} x_i \times 2^i) \times (-y_{m-1} \times 2^{m-1} + \sum_{i=0}^{m-2} y_i \times 2^i) = (x_{n-1}y_{m-1} \times 2^{n+m-2} + \sum_{i=0}^{n-2} \sum_{j=0}^{m-2} x_i y_j \times 2^{i+j}) - (2^{n-1} \times \sum_{i=0}^{m-2} x_{n-1}y_i \times 2^{i} + 2^{m-1} \times \sum_{i=0}^{n-2} y_{m-1}x_i \times 2^{i})
\end{equation}
$$

我們可以把上面的算式對應到下面的直式運算，特別注意到最後兩個 row 是減法運算，而非加法運算。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/cffad08d-6e51-4f45-baae-9d021e74c169.png)

有沒有什麼方式可以將算式變形？利用二補數的原理，比起減去一個數，**我們可以加上這個數的二補數**，對於一個數 $Z = z_{n-1}z_{n-2}...z_0$，其二補數可以表示為：

$$
-Z = -\overline{z_{i-1}} \times 2^{n} + \sum_{i=0}^{n-1} \bar{z_i} \times 2^i + 1
$$

於是對於

$$
\begin{equation}
\textcolor{red}{-}2^{n-1} \times (-0 \times 2^m + 0 \times  2^{m-1} + \sum_{i=0}^{m-2} x_{n-1}y_i \times 2^i)
\end{equation}
$$

可以改寫成

$$
\begin{equation}
\textcolor{red}{+}2^{n-1} \times (-1 \times 2^m + 1 \times  2^{m-1} + \sum_{i=0}^{m-2} \overline{x_{n-1}y_i} \times 2^i + 1)
\end{equation}
$$

於是，我們將 $X \times Y$ 改寫成

$$
\begin{equation}
X \times Y = x_{n-1}y_{m-1} \times 2^{n+m-2} + \sum_{i=0}^{n-2} \sum_{j=0}^{m-2} x_iy_j \times 2^{i+j} + 2^{n-1} \times (-2^m + 2^{m-1} + \sum_{i=0}^{m-2}\overline{x_{n-1}y_i} \times 2^i) +\\ 2^{m-1} \times (-2^n + 2^{n-1} + \sum_{i=0}^{n-2}\overline{y_{m-1}x_i} \times 2^i)
\end{equation}
$$

針對 $-2^m + 2^{m-1} + \sum_{i=0}^{m-2}\overline{x_{n-1}y_i} \times 2^i$，我們進一步變形

> Ps：大家可以把 $x_{n-1}$ 等於 0 和 1 分別代入即可確認兩者是等價的

$$
\begin{equation}
-2^m + 2^{m-1} + \sum_{i=0}^{m-2}\overline{x_{n-1}y_i} \times 2^i = -2^m + 2^{m-1} + \overline{x_{n-1}} \times 2^{m-1} + \overline{x_{n-1}} + \sum_{i=0}^{m-2} x_{n-1}\bar{y_{i}} \times 2^i
\end{equation}
$$

做這步驟的是因為，我們把原本的 $\overline{x_{n-1}y_i}$ 變成了 $x_{n-1}\bar{y}_{i}$，就可以把電路中本來需要的 NAND Gate 變成 NOT Gate。最終，我們再次將算式對應到下面的直式運算

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/2018dcf7-b206-43a9-a92b-eb5c924f8bcf.png)

上述是最原始的 Baugh-Wooley Algorithm，好處是只要把某些 term 做 NOT 運算之後，即可把所有的 Partial Products 都視為 Posotive，不用特別的減法電路來進行運算。但我們目前採用的通常都是 ==Modified Baugh-Wooley Algorithm==，以 4-bits 乘法為例：

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/34e03dcb-1fa4-4cf4-8059-6b2fe2d31ebc.png)

我們將上圖的運算過程對應（Mapping）到電路，得到如下圖的電路，稱為**陣列乘法器（Array Multiplier）**：

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/ae3edcd1-9eed-42c6-9faa-7a82416a0452.png)

> 圖片來源：[link](https://www.researchgate.net/profile/Kailiang-Chen/publication/42437163/figure/fig21/AS:669375262650375@1536602907079/4-The-block-diagram-of-a-4-bit-signed-multiplier.ppm)

此外，有幾個重點我們要注意

1. 每一列都是 Ripple-Carry Adder（RCA）的架構，同一列中第 n+1 個 bit 的加法需等待第 n 個 bit 的進位（carry）算完才能進行
2. 第一個部分積與第二個部分積相加求得和後，再與第三個部分積相加，每一列的加法都要等上一列加法**部分完成後**才能進行
3. Critical Path 共需要經過 9 個 Adder（2 個 Half-Adder 再加上 7 個 Full-Adder），會造成乘法器有很長的 Logic Delay，尤其當 Operand 的 bit 數增加時，Critical path 與 Delay 也會隨之快速增長，這對效能會有很大的影響
4. 和課堂上教的乘法器有一個本質的不同是，==這個 Array Multiplier 只需要一個 Clock Cycle 即可完成運算==，而課堂上所述的是 Multi-Cycle Binary Multiplier。通常在 CPU 內部，乘法器會由 Single-Cycle 的設計加上適當的 Pipeline 來使其 Critical Path 不會太長，同時又可以在數個 cycle 內即可完成整數乘法運算

!!! warning
    請特別注意圖片上某些 AND Gate 的 Output 其實有一個小圓點，所以是 NAND Gate

為了提升乘法器的效能，我們接下來要探討兩種優化乘法器電路的演算法，分別是 Booth Algorithm 和 Wallace Tree Adder。Booth Algorithm 的目的在於**減少部分積的數量**，而 Wallace Tree 的目的在於**將多個加法平行化**。

### Radix-4 Booth Algorithm

!!! info
    當年提出 Booth Algorithm 的論文：[Booth, Andrew Donald. “A SIGNED BINARY MULTIPLICATION TECHNIQUE.” Quarterly Journal of Mechanics and Applied Mathematics 4 (1951): 236-240.](https://academic.oup.com/qjmam/article/4/2/236/1874893?login=true)

!!! note
    大家在課堂上學到的  Booth Algorithm 是 Radix-2 Booth Algorithm，這裡的 Radix-4 只是 Radix-2 的推廣而已，可以讓 Partial Product 的數量更少，但代價就是 Encoding 電路更複雜，因為 Sliding Window 會更大，並且也會有更多種 Encoding 的結果。

將算式 (1) 進一步變形，我們可以得到以下形式：

$$
\begin{equation}
X \times \{(-2 \times Y_{n-1} + Y_{n-2} + \times Y_{n-3})\times 2^{n-2} + (-2 \times Y_{n-3} + Y_{n-4} + Y_{n-5})\times 2^{n-4} +\\ (-2 \times Y_{n-5} + Y_{n-6} + Y_{n-7})\times 2^{n-6} + ... + (-2 \times Y_3 + Y_2 + Y_1) \times 2^2 + (-2 \times Y_1 + Y_0 + \times \textcolor{red}{Y_{-1}})\times 2^0 \} 
\end{equation}
$$

特別注意的是，實際上 $Y_{-1}$ 這項並不存在，因為 $Y$ 是從 $Y_0$ 開始的，會多出 $Y_{-1}$ 這項只是因為我們想要讓每對小括號中都有三個 term 而已。**所以 $Y_{-1}$ 視為 0**，這樣就不會改變原本算式的結果。

上面的算式其實**暗示**了我們一個技巧，就是我們可以以 3-bits 為一組來檢設 $Y[n-1:0]$ 中的每個 bits，所以我們會看到：

$$
\begin{equation}
-2 \times Y_{i+1} + Y_i + Y_{i-1}
\end{equation}
$$

上面的算式總共會有五種可能，分別是 $-2$、$-1$、$0$、$1$ 和 $2$，我們可以將這種形式對應到下面的 Booth 編碼，這種編碼稱為 **Radix-4 Booth Encoding**。

基於 Booth Encoding 的思想，我們就可以建構出一個 Booth Encoder 電路，這個電路會有兩個輸入，分別是 $X$ 和 $Y[i+1:i-1]$，根據 $Y[n+1:n-1]$ 的數值，配合 Radix-4 Booth Encoding 乘上 $X$ 之後得到一個 Partial Product。對於 n-bits 乘以 n-bits 的乘法器為例，我們只要建構出 $\frac{n}{2}$ 個 Booth Encoder，再配合上適當地 Left-Shift（因為還要乘以 $2^n$）即可得到所有的 Partial Products。

| $Y_{i+1}$ | $Y_i$ | $Y_{i-1}$ |編碼（$X \times (-2 \times Y_{i+1} + Y_i~ + Y_{i-1})$）|
| :-- | :-- |:--|:--|
|0|0|0|$0$|
|0|0|1|$X$|
|0|1|0|$X$|
|0|1|1|$2X$|
|1|0|0|$-2X$|
|1|0|1|$-X$|
|1|1|0|$-X$|
|1|1|1|$0$|

最後，我們只要將 $\frac{n}{2}$ 個 Partial Products **加總**，就可以得到 $X[n-1:0] \times Y[n-1:0]$ 的結果。

如果以 n 等於 64 為例，使用 Array Multiplier 進行 64-bits 的整數乘法，會需要加總 64 個 Partial Product。但是，當我們使用 Radix-4 Booth Algorithm 先將乘數進行適當編碼之後，只要加總 $64 \div 2 = 32$ 個 Partial Products，數量整整少了一半！

但是要把 32 個數字**依序**相加依然非常耗費時間，我們可以再藉由 Wallace Tree 的技巧將多數相加的過程**平行化（Parallelize）**，藉此加速運算。

### Wallace Tree

!!! info
    當年提出 Wallace Tree 的論文：[C. S. Wallace, "A Suggestion for a Fast Multiplier," in IEEE Transactions on Electronic Computers, vol. EC-13, no. 1, pp. 14-17](https://ieeexplore.ieee.org/document/4038071)

如果要介紹 Wallace Tree 的話，我們必須先知道什麼是 **Carry-Save Adder**（CSA）。當我們在做**三個**數字的相加的時候，CSA 就會特別有優勢，我們用下面的電路來解釋。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/2b0ed07d-e147-445d-9aa5-f852e90e2d90.png)

這是我們只使用 RCA 來進行三個數字的相加時，所使用的電路架構，如果分析其 Critical Path 的話，我們可以計算出其為五個 FA Delay 加上一個 HA Delay。但是當我們改成使用一級 CSA 加上一級 RCA 的時候，其 Critical Path 就會變成五個 FA Delay。可以看到使用 CSA + RCA 的混合加法器架構對於**三個以上**的整數相加的時候，會更有速度上的優勢。雖然以三個數相加來看，好像只進步一點點，不過在多個數相加的時候，CSA + RCA 的優勢就會越來越明顯，而這正是我們接下來要介紹的 **Wallace Tree**。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/78fe0707-0b21-4486-a1d4-e5a6b91fec9a.png)

Wallace Tree 的核心精神就是利用 Carry-Save Adder 的 **3-to-2 Compression** 特性，逐步將 summands 減少，一直到剩下兩個 summands 的時候，就可以使用 Ripple-Carry Adder，或甚至使用 Carry-Lookahead Adder 將兩個 summands 相加，得到最終乘法的結果。Wallace Tree 之所以可以加速多個數字的加法運算在於其將多個 summands 的**加法平行化**。

大家在上面的 Adder Tree 架構中，看到的每個小長方形的 Adder 就是 Carry-Save Adder。單一一個 CSA 的架構是將多個 Full-Adder 平行排列，**並且不將 FA 之間的 Carry-in、Carry-Out 連接起來**，取而代之的是 FA 的 Sum 和 Carry-Out 都會變成獨立的輸出。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/6cb9a3da-c42c-4aa8-8125-cb48611d47d2.png)

上圖是經典的 Ripple-Carry Adder 結構，每個 FA 之間的 Cin 和 Cout 會互相連接。但是下圖則使用了兩級的 CSA 和一級的 RCA 來進行求和運算，大家可以看到在上面兩級的 CSA 中，每個 FA 的 Cout 反而是接到下一級 CSA 中的 FA 的輸入，而非接到同一級的 FA 的 Cin。（Ps：同一個水平上的 FA 視為同一級，same stage）

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/d05930a5-699c-4cfb-afab-74fa4b8e656a.png)

### Assignment Part 1 - Fast Single-Cycle Multiplier Design

在 Assignment Part 1 的部分，大家需要實作一個**單週期、支援兩個 64-bits 有號數相乘的乘法器**，並且使用 Radix-4 Booth Algorithm 加上 Wallace Tree。
大家可以參考以下架構去實作：

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/d6ba0ef6-8ef7-4d6c-858b-11cb7d65eb35.png)

1. Booth
    ```verilog linenums="1"
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
    ```verilog linenums="1"
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
    ```verilog linenums="1"
    module Switch(
        input [127:0] p_in [31:0],
        output reg [31:0] p_out [127:0]//p0~ p127
    );
    //your code here
        
    endmodule
    ```
    純接線, 將32個128bits的Partial product轉成128個32bits的輸出
4. Wallace32
    ```verilog linenums="1"
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
6. Adder<br>
   將Wtree的c、s相加（直接用加號即可, 不用自己撰寫128'的加法器） 
7. Top
    ```verilog linenums="1"
    module Top(
        input [63:0]x, y,
        output [127:0] out
    );
        //your code here
        
    endmodule
    ```
    連接每個module<br>
    ==top module請務必遵守以下規範(注意大小寫)：==<br>
    - 檔名：Top.sv
    - module 名稱： Top
    - I/O ports名稱及位寬皆不能更動

## Chapter 2. Universal Asynchronous Receiver/Transmitter (UART)

### UART Hardware Architecture

UART 是一種傳輸介面，他的特色就是只要透過一跟導線，即把 Transmitter 的 **TX** 和 Receiver 的 **RX** 連接，即可完成資料的傳輸，成本極低，並且不需要 Clock 的同步訊號。並且，在傳輸方式上，還可以分為**單工（Simplex）**、**半雙工（Half-Duplex）** 和**全雙工（Full-Duplex）**。

由於 Transmitter 和 Receiver 之間沒有 Clock 訊號來進行同步，因此，收發雙方之間必須約定好以一個固定的頻率（**Buad Rate**）來進行傳輸。如果雙方的 Buad Rate 不同，則 Receiver 在採樣（Sampling）上就會出現問題，而無法接收到正確的資料。

<figure markdown="span">
    ![](https://vanhunteradams.com/Protocols/UART/uart_hardware.png){ align="center" }
</figure>

如上圖所示，兩個 UART 模組的 TX-RX 交錯相接，可以實現半雙工的傳輸方式，即在單一時間內，Device 1 可以向 Device 2 傳送資料，或是 Device 2 向 Device 1 傳送資料。但是在這次 Lab 的實作中，我們只實作單一的 Transmitter 和單一的 Receiver，所以在 Transmitter Module 上只會有一個 TX Output Port，而在 Receiver Module 上只會有一個 RX Input Port。

上面我們只介紹的 UART 的硬體傳輸**介面**，但是傳輸資料不但需要收發器硬體本身，也需要規範所謂的**傳輸協議**。

### Serial Communication Protocol

<figure markdown="span">
    ![](https://www.amebaiot.com/wp-content/uploads/2017/05/u1.png)
</figure>

UART 在 Idel 狀態的時候，Transmitter 會把 TX 訊號保持在 1（Logical High），當 Transmitter 決定開始傳輸資料的時候，就會把 TX 往下拉變成 0（Logic-Low），稱為 **Start Bit**。Start Bit 後面會緊接著一個 Data Packet，由 8-bits 組成（也就是一個 byte），Data Packet 由 LSB 開始傳送，一直到把 MSB 傳送完畢之後，最後再接著 Stop Bit。

:::danger
請特別注意，Start Bit 為 Logic-Low，而 Stop Bit 為 Logic High。
:::

<!-- ### ASCII Encoding

具體來說，有了 UART 的硬體和傳輸協議之後，那我們到底要傳輸什麼呢？如果我們不去定義資料的編碼格式（Encoding），那麼我們接收的資料只不過就是一堆 0 和 1 而已，並沒有任何意義。因此，我們必須要先講清楚我們到底**如何解讀資料**。

因為我們剛好使用 8-bits 作為一個 Data Packet，因此我們可以使用 **ASCII** 作為資料的編碼格式。在 ASCII 中分為**控制字元**和**可顯示字元**，在 Lab 2 當中，我們不會使用到控制字元，因此我們只需要關注可顯示字元即可。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/236d1bb1-0f25-46da-9d79-0dbba5bf5f1d.png)

除此之外，ASCII 只使用 7-bits 來傳輸，因此在 UART 傳輸的 8-bits Data Packet 當中，MSB 可以忽略，當作 Don't Care。-->

### Assignment Part 2 - UART Module Design

這個部分的實作會由三個部分組成，分別是 `transmitter.sv`、`receiver.sv` 還有 tset-bench。需要完成的是前兩個 SystemVerilog Code，而 test-bench 會將兩份 Transmitter 和 Receiver 拿來接線使用，給予 & 檢查回傳 message。

>抱歉程式可能寫的不是非常漂亮，歡迎各位多多指教!當然，這只是一個參考模板，用其他架構去寫出UART也可以的!
>另外code中會盡量把每個brench都填滿，但在這堂課的驗證中不填滿應該也不會出問題(?

1. `transmitter.sv`
    <figure markdown="span">
        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/8db43560-4856-4b34-95b4-4f41cbe7289c.png){ width=500 }
    </figure>
    在程式碼中給了兩個always block。其中一個是控制tx(輸出訊號)，另一個是控制state&bit_counter(FSM的state跳轉)與shift_reg(儲存了tx要輸出的內容)。<br>
    <font color="#A8AAAC">start_tx是testbench給的，tx_done則是給testbench的小小外部訊號</font>

    ```verilog linenums="1"
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
    
    ```verilog linenums="1"
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
2. `receiver.sv`
    <figure markdown="span">
        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/138bee48-ad24-412f-9cec-b32de69b19e1.png){ width=500 }
    </figure>

    在程式碼中給了兩個always block。其中一個是控制rx_done(輸出message)與shift_reg(接收並儲存從transmitter來的0/1訊號)，另一個是控制state&bit_counter(FSM的state跳轉)。<br>
    <font color="#A8AAAC">rx_done是給testbench的小小外部訊號</font>

    ```verilog linenums="1"
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
    
    ```verilog linenums="1"
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

## Chapter 3. How to run simulation and test-benches

在這次作業中，助教一樣提供了 Makefile 讓大家使用。這次的作業主要分成兩題，兩題各自會有自己的 test-bench。

```shell
.
├── Makefile
├── Top.sv
├── common.mk
├── mul
│   ├── Top.sv
│   ├── other .sv files
│   ├── mul.mk
│   └── sim_main.cpp
└── uart
    ├── Top.sv
    ├── other .sv files
    ├── sim_main.cpp
    └── uart.mk
```

這次助教提供的 Sample code 的檔案結構如上所示，如同 Lab 1，同學如果要編譯你已經完成的 Code，只要在 `lab-2` 資料夾底下，輸入 `make`（同時編譯 Multiplier 和 UART）、`make mul`（只編譯 Multiplier）或是 `make uart`（只編譯 UART），不需要進入到子資料夾當中。

而如果要執行 simulation 的話，一樣停留在 `lab-2` 資料夾底下，輸入 `./mul/obj_dir/VTop` 即可執行 Multiplier 的 test-bench。而輸入 `./uart/obj_dir/VTop` 即可執行 UART 的 test-bench。

## Start to do the assignment

1. Clone the sample code
    - 先確定自己已經打開課程開發環境（Container），並且在環境中的 `workspace` 底下
    - 下載助教提供的 Sample Code <br> `git clone https://gitlab.course.aislab.ee.ncku.edu.tw/113-1/lab-2.git`
    - 進入資料夾 <br> `cd lab-2`
2. Create a private repo
    - 如同 Lab 1 所述，在 Gitlab 上面創建個人 Repo，並且命名為 `Lab 2`，請不要勾選 *Initialize the repository with READNE*
    - 確認 branch 的名稱為 main 而非 master <br> `git branch -M main`
    - 新增自己的 Private Gitlab Repo 為 Remote Source <br> `git remote add private <HTTPS URL of your private repo>`
3. Push codes to your private repo
    - `git push -u private main`
4. Notes
    - 因為在**預設**情況之下，只要 Gitlab Repo 中包含 `.gitlab-ci.yml` 檔案就會觸發 CI/CD Pipeline，如果你在前期尚未完成作業的時候不想觸發 Pipeline，可以先在 Gitlab 你的 Private Repo 中的設定將 CI/CD 功能關閉，待完成作業之後再打開
