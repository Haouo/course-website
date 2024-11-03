# From Verilog to SystemVerilog

!!! info
    - Contributors: TA 峻豪
    - Last updated: 2024/09/22

---

!!! success "Recommend Paper"
    推薦閱讀論文 [Synthesiing SystemVerilog - Busting the Myth that SystemVerilog is only for Verification](https://sutherland-hdl.com/papers/2013-SNUG-SV_Synthesizable-SystemVerilog_paper.pdf)，該論文詳細地介紹了 SystemVerilog 對於電路設計的好用之處。

## What is  SystemVerilog?

SystemVerilog 是一種硬體描述和驗證語言，是 Verilog 的擴展，主要目的是增強設計和驗證的功能。
Verilog 起初在 1980 年代被設計用來描述硬體，提供設計者能夠用高層次語法來描述數位電路的行為及結構。
由於其簡潔的語法，Verilog 成為了硬體設計的重要工具。然而，隨著硬體設計日益複雜，Verilog 的表達能力和測試驗證功能顯得不足。
為了滿足這些需求，SystemVerilog 在 2005 年被引入並成為 IEEE 標準（IEEE 1800）。

SystemVerilog 增加了許多現代編程語言的特性，使設計者能以更高層次的方式來描述硬體結構和行為。
例如，它引入了強型別的資料結構和多種控制語句，允許更靈活的流程控制和資料管理，從而更精確地描述硬體行為。
另外，SystemVerilog 提供了面向物件的編程功能，可以使用類別（class）來建模複雜的硬體模組與其交互行為，這在驗證過程中尤為重要，特別是當設計者需要模擬數據傳輸或狀態變遷時。

除了設計，SystemVerilog 也著重強化了驗證功能。
Verilog 本身主要用於設計硬體，缺乏有效的測試與驗證工具，而 SystemVerilog 擴展了這方面的能力，提供了高階的測試建模語法如 interfaces、assertions 和 coverage 等，適合複雜的驗證場景。
這些功能讓工程師能夠定義訊號之間的交互方式，設置斷言（assertions）來檢查系統行為的正確性，並藉由覆蓋率分析（coverage analysis）確保測試完整性。
這些增強的驗證功能讓 SystemVerilog 成為了廣泛用於硬體驗證的語言。

總的來說，SystemVerilog 是對 Verilog 的全面強化。
它保留了 Verilog 作為硬體描述語言的優勢，同時提供了現代化的編程工具和驗證功能，使設計者可以應對當今數位設計中的複雜挑戰。
今天，SystemVerilog 已被廣泛應用於芯片設計和驗證領域，尤其是在設計與測試流程高度緊密結合的情境下。

## Migrate from Verilog to SystemVerilog

基本上，**單純以電路設計來說**（這裡不討論關於驗證的部分），要從 Verilog 遷移到 SystemVerilog 其實並不會很困難，只需要多學一些好用的語法和觀念即可。
但是，正是因為這些新加入的語法特性，讓 SystemVerilog 變得比 Verilog 還要強大很多，有助於讓程式碼更簡潔、好讀。

### New Data-Type in SystemVerilog

我們最常在 Verilog 中使用到的 Data Type 應該就是 `wire` 和 `reg`，但在 SystemVerilog 出現了一個強大且好用的新資料型態：**`logic`**。

!!! note "Net vs. Variable and Vector vs. Array"
    其實不論是在 Verilog 或是 SystemVerilog 中，都把 Data Type 再細分成兩類，分別是 *Net* 和 *Variable*。

### Enumeration

Enumerated types allow variables and nets to be defined with a specific set of named values.

Enumerated types have a base data type, which, by default, is int (a 2-state, 32-bit type).
In the example above, State is an int type, and WAITE, LOAD and DONE will have 32-bit int values.
The labels in the enumerated list are constants that have an associated logic value.
By default, the first label in the list has a logic value of 0, and each subsequent label is incremented by one.
Thus, in the example above, WAITE is 0, LOAD is 1, and DONE is 2.

Designers can specify an explicit base type, allowing enumerated types to more specifically model hardware.
Designers can specify explicit values for any or all labels in the enumerated list.

> 這個要用中文我覺得很難解釋，所以我直接貼上論文中的描述了...我覺得反而比較好懂<br>----- TA 峻豪

```systemverilog linenums='1'
enum {WAITE, LOAD, DONE} State; // a variable that has 3 legal values
enum logic [2:0] {WAITE = 3’b001, LOAD = 3’b010, DONE = 3’b100}
    State, NextState; // Two 3-bit, 4-state enumerated variables with one-hot values
```

Enumerated types have stronger rule checking than built-in variables and nets. These rules include:

1. The value of each label in the enumerated list must be unique
2. The variable size and the size of the label values must be the same
3. An enumerated variable can only be assigned:
    - A label from its enumerated list
    - The value of another enumerated type from the same enumerated definition

比起在 Verilog 中我們常用 `parameter` 來達成 enumeration 的功能，使用 SystemVerilog 中的 `enum` 有很多好處，讓我們看下面兩個例子。

```systemverilog linenums='1'
// Names for state machine states (one-hot encoding)
parameter [2:0] WAITE=3'b001, LOAD=3'b010, DONE=3'b001; // FUNCTIONAL BUG

// Names for mode_control output values
parameter [1:0] READY=3'b101, SET=3'b010, GO=3'b110; // FUNCTIONAL BUG

// State and next state variables
reg [2:0] state, next_state, mode_control;

// State Sequencer
always @(posedge clock or negedge resetN) begin
    if (!resetN) state <= 0; // FUNCTIONAL BUG
    else state <= next_state;
end

// Next State Decoder (sequentially cycle through the three states)
always @(state) begin
    case (state)
        WAITE: next_state = state + 1; // DANGEROUS CODE
        LOAD : next_state = state + 1; // FUNCTIONAL BUG
        DONE : next_state = state + 1; // FUNCTIONAL BUG
    endcase
end

// Output Decoder
always @(state) begin
    case (state)
        WAITE: mode_control = READY;
        LOAD : mode_control = SET;
        DONE : mode_control = DONE; // FUNCTIONAL BUG
    endcase
end
```

讓我們用 `enum` 改寫。

```systemverilog linenums='1'
enum logic [2:0] {WAITE=3'b001, LOAD=3'b010, DONE=3'b001} // SYNTAX ERROR
    state, next_state;
enum logic [1:0] {READY=3'b101, SET=3'b010, GO=3'b110} // SYNTAX ERROR
    mode_control;


// State Sequencer
always @(posedge clock or negedge resetN) begin
    if (!resetN) state <= 0; // SYNTAX ERROR
    else state <= next_state;
end

// Next State Decoder (sequentially cycle through the three states)
always @(state) begin
    case (state)
        WAITE: next_state = state + 1; // SYNTAX ERROR
        LOAD : next_state = state + 1; // SYNTAX ERROR
        DONE : next_state = state + 1; // SYNTAX ERROR
    endcase
end

// Output Decoder
always @(state) begin
    case (state)
        WAITE: mode_control = READY;
        LOAD : mode_control = SET;
        DONE : mode_control = DONE; // SYNTAX ERROR
    endcase
end
```

本來在 Verilog 中使用 `parameter` 的寫法可能並不會在編譯過程中觸發編譯錯誤，不過當我們改成使用 `enum` 來實現相同的功能，就可以在編譯階段就及早抓出許多淺在的錯誤。
因為 syntax error 會直接觸發編譯錯誤，如果連編譯都沒辦法通過，更不用談後面的模擬。

### Structures

就像是 C 語言中的 `struct` 一樣，在 SystemVerilog 中我們也可以用 struct 來把多個不同的 data type elements 包裝在一起。

```systemverilog linenums='1'
struct {
    logic [31:0] source_addr;
    logic [31:0] dest_addr;
    logic [31:0] data;
    logic [31:0] ecc;
} packet;
```

以下是一些使用上的語法範例。

```systemverilog linenums='1'
struct packet a_packet;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        a_packet <= '{default:0};
        // also: a_packet.source_addr = 32'd0;
    end
    else begin
        a_packet <= '{old_addr, new_addr, data_in, ecc_func(data_in)};
    end
end
```

我們也可以宣告 structure 為 packed，配合 packed union 的時候很有用。

```systemverilog linenums='1'
struct packed {
    logic [1:0] parity;
    logic [31:0] data;
} data_word;
```

> **SystemVerilog Advantage**<br>
> By using structures to collect related variables together,
> the collection can be assigned and transferred to other modules as a group,
> reducing the lines of code and ensuring consistency.
> Only use packed structures when the structure will be used in a union.<br>
> ----- Synthesiing SystemVerilog - Busting the Myth that SystemVerilog is only for Verification

### Unions

在 SystemVerilog 中，我們也可以像在 C 語言中一樣使用 `union`，讓我們可以對同一筆 Data 有不同的解釋方式和定義。
但是在 SystemVerilog 中，union 分成三種，分別是普通的 union、tagged union 和 packed union。

```systemverilog linenums='1'
union packed {
    struct packed {
        logic [31:0] data;
        logic [31:0] address;
    } data_packet;
    struct packed {
        logic [31:0] data;
        logic [31:0] operation;
    } instruction_packet;
} packet_u;

always_ff @(posedge clock or negedge rstN) begin
    if (!rstN) begin
        packet_u <= {’0, ’0}; // reset
    end
    else if (op_type == DATA) begin
        packet_u.data_packet <= {d_in, addr};
    end
    else begin
        packet_u.instruction_packet <= {d_in, instr};
    end
end
```

### Packages

### The Change of `always` Block

### `case...inside`

### Unique and Priority Keywords

### Interface and Modport

### Others

#### Ending Name

#### Vector Fill Token

#### Constant Variable

#### Expression Size Function

#### for-loop and foreach
