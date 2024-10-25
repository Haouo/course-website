!!! info
    - Contributors：TA 峻豪
    - Last Update：2024/10/09
    - Deadline: ==2024/11/03 23:59:59==

!!! success
    如果你想要讀到關於 RISC-V 最原始的資訊和定義的話，請閱讀 RISC-V ISA 規格書（Specifications）

    1. [RISC-V ISA Specifications Volume 1, Unprivileged Specification version 20240411](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view?usp=drive_link)
    2. [RISC-V ISA Specifications Volume 2, Privileged Specification version 20240411](https://drive.google.com/file/d/17GeetSnT5wW3xNuAHI95-SI1gPGd5sJ_/view?usp=drive_link)

    但**這門課並不會涉及到 Privileged Architecture（特權架構）的內容**

??? info "Simple Index"
    - Chapter 1 [What is computer](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#what-is-computer)
        - 1.1 [From the Perspective of Finite-State-Machine (FSM)](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#from-the-perspective-of-finite-state-machine-fsm)
    - Chapter 2 [Introduction to RISC-V Instruction-Set Architecture (ISA)](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#introduction-to-risc-v-instruction-set-architecture-isa)
    - Chapter 3 [What is ISA Simulator (ISS)？](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#what-is-isa-simulatoriss)
        - 3.1 [General Purpose Register (GPR)](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#general-purpose-register-gpr)
        - 3.2 [How to Distinguish Instructions From Binary (Instruction Decoding)](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#how-to-distinguish-instructions-from-binary-instruction-decoding)
            - 3.2.1 [From RV32I to RV64I](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#from-rv32i-to-rv64i)
        - 3.3 [Architecture of A Simple ISS](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#architecture-of-a-simple-iss)
        - 3.4 [Why Do We Need SYSTEM Instructions?](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#why-do-we-need-system-instructions)
        - 3.5 [ISS with Debugging Interactive Interface](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#iss-with-debugging-interactive-interface)
    - Chapter 4 [How to Compile and Run](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#how-to-compile-and-run)
    - Chapter 5 [Start to Do Assignment](https://pages.course.aislab.ee.ncku.edu.tw/ta/course-website/labs/lab2/#start-to-do-assignment)

## What is Computer？

讓我們來看看電腦最基本的抽象結構（Abstraction Layers）：

<figure markdown="span">
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/ebbb6441-034a-436d-bdcb-767b511648a1.png){ width=500 }
</figure>

大家應該有注意到我們上課使用的課本 *Computer Organization and Design RISC-V Edition: The Hardware Software Interface, 2/e*（也就是我們常說的算盤書），書名上的副標題是『==The Hardware Software Interface==』，想必這句話作為書本的副標題，一定有著舉足輕重的地位。那麼，這句話到底代表著什麼？

我們在目前的階段先忽略作業系統（Operating System）的部分，基本上 Program 也就是我們所說的 **Software**，而 Processor，又或是說 Central Processing Unit（CPU）就是我們所說的 **Hardware**。
而介於 Software 和 Hardware 之間，特別的部分，就是 Instruction-Set Architecture（ISA）。

我們所撰寫的程式（e.g. C 語言），是相對高階並且抽象的語言，接近人類所能理解的**自然語言**，這些東西如果直接丟給 CPU 去看的話，CPU 是看不懂你寫的 C 程式的，也因此上一個 Lab 我們介紹了 Compiler 的 Compilation Flow 和 GCC 的基本概念，只不過 Compiler 並不是計算機組織這堂課要討論的重點。
而在這個 Lab，我們將進入這堂課的重點之一，也就是 ISA 的部分。

ISA（Instruction-Set Architecture），基本上定義了一系列 CPU 應該要支援的指令以及對應的具體行為，確保軟體和硬體之間有一個可以相互配合的介面（Interface）。
所有在計算機系統中的軟體，最終都必須要被轉換成該系統中 CPU 所實作的 ISA 的指令，才能夠順利地運作在系統之中。

基本上，在計算機科學中，**抽象（Abstraction）**是一個非常重要的概念和技巧，ISA 其實就是一種抽象層的設計和應用。有了 ISA 的制定，如 RISC-V，程式設計師（e.g., 系統軟體）可以不用理解底層硬體的細節，只需要掌握 ISA 內所定義的指令，便可以撰寫程式。
而設計 CPU 架構的硬體架構師也不必過於關注在 ISA 之上，更高層次的 Software Stack 是如何被制定，只需要專注在 ISA-Level 的實作即可。

有了 Abstraction Layer 的概念，我們可以使計算機系統中每個重要的部分**解耦合（Decoupling）**，讓我們可以專注在個別的部分，例如 CPU 設計，又或者是作業系統等等系統軟體的設計本身，而不是全部都混雜在一起。
但是藉由 ISA 這種 Abstraction Layer 的連結，程式設計師和硬體架構師之間依然有**合適的溝通橋樑**。

### From the Perspective of Finite-State-Machine (FSM)

我們也可以從有限狀態機的觀點來看整個計算機系統的運作。基本上，Program 可以被視為式一個巨大的狀態機 $S = <\mathbf{V}, \text{PC}>$，其中 $\mathbf{V} = \{v_1, v_2, v_3, ..., v_n\}$，為整個程式中所擁有的所有變數（Variable）。
至於你在 Source Code 中的每個 statements，可以被稱為是 **Activation Event**，它會導致 Program 的狀態改變，有可能是 $\mathbf{V}$ 改變，可能是 $\text{PC}$ 改變，或是兩者都改變。
至於這些 C 語言程式原始碼中的 Statement 是根據什麼樣的規則來改變 $S$，這就是由 C 語言標準（C Standard Revision, e.g., ISO C90）來制定。

<figure markdown="span">
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a3eb3a74-1333-48db-a207-092b957543ef.png){ width=900 }
</figure>

除了我們可以將 Software（Program）視為是一個 FSM，Processor（CPU）本質上也是一個巨大的 FSM。Processor 的狀態 $S$ 可以被定義為一個集合 $S = \{\text{Values in memory elements}\}$。

<figure markdown="span">
    ![](https://media.geeksforgeeks.org/wp-content/uploads/1111-1.png){ width=500 }
</figure>

而 ISA 中定義的每條指令，其實就是 CPU 的狀態 $S$ 的 Activation Event，也就是**指令會導致 CPU 的狀態發生改變**。
對於我們接下來要實作的 ISA Simulator 來說，我們可以將其的狀態定義為 $S = \{\text{GPRs},\, \text{PC},\, \text{Memory}\}$。
對於 ISA Smulator 的狀態，視為是由 32 個 General Purpose Registers，再加上 Program Counter 和 Main Memory 所組成，而我們實作的 RV64I 指令則會去改變 ISA Simulator 的狀態 $S$。

## Introduction to RISC-V Instruction-Set Architecture (ISA)

RISC-V 被歸類為 RISC（Reduced Instruction Set Computer）指令集架構，與之相對的是 CISC（Complex Instruction Set Computer）。
CISC 的代表人物便是在桌上型電腦、伺服器上常見的 x86 架構，而 RISC 架構除了 RISC-V 以外，最常見的便是 ARM，ARM 在手機、嵌入式應用市場中有重要的地位。

必須要強調的是，RISC 和 CISC 並沒有明確的定義，不過相較於 CISC 架構，RISC 架構的指令集**通常**有以下的特色：

1. 指令的長度**固定**且編碼格式較單純
2. 每條指令所需要完成的任務較為單一（也可以想像成指令的功能比較簡單）<br>
  > 在 CISC 架構如 x86 中，單一一條 CISC 指令通常都會被轉換成多條 µOp（micro-operation）指令，而其中 µOp 其實就比較接近 RISC 指令
3. **指令通常不會直接操作 Main Memory**，而是藉由 Memory Accessing Instruction 如 Load/Store 指令來存取記憶體

RISC-V 相較於 ARM 有幾個比較鮮明的特色：

1. 如果要要使用 ARM 進行商業行為需要取得授權（就是要付錢），但 RISC-V 是開源（Open-Source）的，就是免費的意思
2. RISC-V 是模組化的設計，最小可以只包含 Base Integer Instruction Set
3. RISC-V 的指令相較於 ARM 依然更為簡單<br>
  > 許多 ARM 的 CPU 設計依然會把 ARM 的指令轉換成多個 µOp 才去執行

## What is ISA Simulator (ISS) ？

因為我們所使用的電腦幾乎都是使用 x86 架構指令集，所以不認得 RISC-V 指令，因此當我們使用 RISC-V GNU Toolchain 去把 C 程式編譯成使用 RISC-V 指令的執行檔的時候，如果我們直接執行，會出現錯誤，因為 program 本身和 Host Machine 所使用的 ISA 不同。

要隨手買來一個使用 RISC-V CPU 的機器，至少在現在看來確實不太容易，但是寫程式這件事情讓一切變得可能。
所以，我們可以設計一個程式，這個程式的任務很單純，就是**解讀 RISC-V 指令並且執行指令對應的功能**，概念上就有點類似於我們設計一個程式去模擬 RISC-V Machine，這樣我們就可以藉由這個**假的** RISC-V Machine 來執行 RISC-V Program。

!!! info
    本文中所說的 RISC-V Program 泛指被編譯成使用 RSIC-V 指令的程式。

除此之外，這個我們設計的 RISC-V ISS 甚至可以在後面我們以 RTL-Level 語言設計 CPU 的時候，在 CPU 驗證的階段派上用場！讓我們可以做 **Co-Simulation**。

為了要實作一個最基本的 ISS，我們需要模擬 Program Counter，模擬 32 個 General Purpose Register，還有 Main Memory。
因為 Register 是運算中暫存資料的最基本單位，Program Counter 負責紀錄目前執行到**哪一條**指令，而 Memory 則負責儲存我們欲執行的 RISC-V Program（包含 Instructions 和 Data）。
為了要執行一個 RISC-V Program，這三個東西缺一不可，如果缺少 Register，則指令的運算結果沒有地方可以放。
如果缺少 Program Counter，則無法知道目前到底正在執行哪一條指令。
而如果缺少 Memory 的話，我們想要執行的 RISC-V Program 所包含的指令和資料都沒有地方可以放，更不用討論要如何執行了。

### General Purpose Register (GPR)

<figure markdown="span">
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/4f59eb46-4bd4-4522-b5b9-19292f7f5677.png)
</figure>

根據 RISC-V 規格書的定義，在 RV64I 中擁有 32 個 64-bits 的**整數通用暫存器**，可以拿來存放資料，但是有一項規定是 **`$x0` 這個暫存器的數值應該永遠保持是 0**。

但是，基於種種原因，我們通常會去規範所謂的 **Application Binary Interface（ABI）**，像是 RISC-V 就有自己的 RISC-V ABI（在後面的 Lab 會介紹）。ABI 會包含許多規範，其中一個就是 **ABI Mnemonic**，也就是說雖然規格書上沒有規定 x0 ~ x31 這三十二個暫存器應該被用作什麼用途，但是 ABI 其實會去規範這些暫存器**通常**會被作為何種用途使用，並且同時給它們一個方便記憶的名子，讓我們在寫 Assembly Programming 的時候可以更方便。

不過在 Lab 2 我們只專注於 Processor State 的模擬，所以其實不用去關注 ABI 的細節。**在 ISS 的實作上，我們只要確實提供 32 個暫存器讓程式可以操作即可**。

!!! note
    讓 `$x0` 保持永遠都是 0（代表不可以被寫入任何資料）其實可以帶來很多好處，讓我們舉幾個例子：

    1. 實作 Move 指令
        - Move 指令可以把 `$rs1` 暫存器中的值複製到 `$rs2` 中
        - 利用 ADD 指令配合 `$x0` 即可實作出 Move 的功能
        - `mv t1, t0` 等價於 `add t1, x0, t0`
        - 當然，使用 ADDI 也可以：`addi t1, t0, 0`
    2. 實作 NOP 指令（No-Operation ）
        - NOP 指令就是**不做任何事情的指令**
        - 可以利用 ADDI 實作 NOP：`addi x0, x0, 0`
    3. 實作與零比較的 BRANCH 指令（Zero-Comparasion Branching）
        - `beqz`：`beq rs1, x0, offset`
        - `bnez`：`bne rs1, x0, offset`
        - `bltz`：`blt rs1, x0, offset`
        - `bgez`：`bge rs1, x0, offset`

    基本上就是因為 0 這個數字很特別，我們很常用到，所以讓 `$x0` 保持永遠是 0 可以帶來很多好處，減少很多不必要的指令。
        
### How to Distinguish Instructions From Binary (Instruction Decoding)

基本上指令被儲存在記憶體中的形式不過就是一對 0 和 1 而已，因此，我們必須要透過一些特定的方法來辨認這些 0 和 1 究竟代表著什麼意義。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7d7ea0d5-fc99-4143-b747-c83e3cfaf8cf.png)

根據 RISC-V 規格書的描述，RISC-V Base Instruction Set 總共有四種 **Base Instruction Format**（R-Type、I-Type、S-Type、U-Type），還有兩種**根據 Immediate Format 變形**而延伸的 Format（B-Type、J-Type）。

1. B-Type 由 S-Type 變形而來
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a6f5781c-6b0a-4591-9213-1d55d74056c3.png)
2. J-Type 由 U-Type 變形而來
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/2926e916-4d42-4a0e-b581-f189f6edf245.png)
    
指令分類最核心的部分是 OPCODE，根據 OPCODE 我們就可以先把指令**初步地**分群。
當我們把指令分成各個 sub-group 之後，就可以再根據其他的資訊如 Function Code（e.g., func3、func7）來進一步區分指令到底是哪一個。下圖是 RISC-V 規格書中的 OPCODE Table：

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/41d8ec10-13c2-433e-a7c5-20c8e24c55d6.png)

我們進一步探討在 **==RV32I== Base Integer Instruction** 中到底有哪些指令需要實作，並且以 OPCODE 來分類。

1. **OP Type**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/86342e61-6431-4788-90a3-48bc03f35173.png)
2. **OP-IMM Type**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7dd8da8e-f23c-4e98-b88c-07d1a6f1882e.png)
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/1801191e-b122-4c4c-b225-9ceddb1e0bae.png)
3. **JAL**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/5fac5b80-bec6-477b-9b99-6b722d9aca34.png)
4. **JALR**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/62749148-10b8-4b44-8e16-4b55bde7b964.png)
5. **BRANCH**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/b0739d10-177f-4e6a-9860-d6a3884266e5.png)
6. **LOAD/STORE**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/943f582e-59e6-46d9-95a4-3801532eb93c.png)
7. **LUI/AUIPC**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/33ce4327-2213-40af-876a-838c0dbbd9e0.png)
8. **SYSTEM**
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/bc8dc66e-5134-489e-a1f6-c8ad76ffa1fb.png)
，

最後我們把**==截至目前為止==**應該要實作的指令列出來，總共應該有 38 條指令。

<figure markdown="span">
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/6c769daf-e31a-456c-8484-4e4f98d2c1e0.png)
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a81f37f7-28ef-4420-9370-2cbd81bb1113.png)
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7e9b406b-c7b5-4f1d-a63e-7786bdb35429.png)
</figure>

#### From RV32I to RV64I
    
但是，由於我們這次要實作的是 ==**RV64I**==，所以還會有幾個額外的指令要區分。如果我們要實作的指令是 RV32I 的話，那麼上述的這些指令，就大部分都是操作在 32-bits 的 Operands 上。但是，如果今天是 RV64I 的話，上述的指令就會變成操作在 64-bits 的 Operands 之上。除此之外，為了讓 RV64I 依然可以執行 32-bits 的運算，因此也會特別有幾條指令是操作在 32-bits 的 Operands。

> Most integer computational instructions operate on XLEN-bit（XLEN 指的就是 RV32 的 32 或是 RV64 的 64） values. Additional instruction variants are provided to manipulate 32-bit values in RV64I, indicated by a 'W' suffix to the opcode. These "*W" instructions ignore the upper 32 bits of their inputs and always produce 32-bit signed values, sign-extending them to 64 bits, i.e. bits XLEN-1 through 31 are equal.
> ----- RISC-V Specification Volume 1, Chapter 4.2

<figure markdown="span">
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/8aab9da2-3bab-4571-b945-74b1c4cb098d.png)
</figure>

大家可以從上圖看出，從 RV32I 轉換到 RV64I，必須多實作**十五條指令**。其中指令後綴（suffix）多了 *W* 的代表是操作在 64-bits register 的低 32-bits，忽略高 32-bits，並且將運算後的結果做 sign-extension 到 64-bits 之後再存回 `$rd` 暫存器。

!!! note
    這裡說「多實作十五條指令」其實有點不太精確，事實上，真正**多出來**的指令應該只有十二條，因為 SLLI/SRAI/SRLI 這三條指令是 RV32I 中本來就有的，只是到 RV64I 中它們的格式會有一點點變化。

<figure markdown="span">
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/36d4aac7-cfc6-4df2-aef6-5e2628ef0826.png)
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/141f49eb-817b-40bc-85ab-f528768cabad.png)
</figure>

針對 SLLI/SRLI/SRAI 這三個指令，shamt（Shift-Amount）會從本來的 5-bits 變成 6-bits。取而代之的是 SLLIW/SRLIW/SRAIW 這三個指令的 shamt 才會是 5-bits。

<figure markdown="span">
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a5b98c48-267a-41e3-b22a-9374a5b148d1.png)
</figure>

而至於 OPCODE 為 OP Type 這類的指令，則多出了 ADDW、SLLW/SRLW、SUBW/SRAW 這些指令。

> LUI (load upper immediate) uses the same opcode as RV32I. LUI places the 32-bit U-immediate into register rd, filling in the lowest 12 bits with zeros. The 32-bit result is sign-extended to 64 bits.
> 
> AUIPC (add upper immediate to pc) uses the same opcode as RV32I. AUIPC is used to build pc-relative addresses and uses the U-type format. AUIPC forms a 32-bit offset from the U-immediate, filling in the lowest 12 bits with zeros, sign-extends the result to 64 bits, adds it to the address of the AUIPC instruction, then places the result in register rd.
>
> ----- RISC-V Specification Volume 1, Chapter 4.2.1

根據規格書的描述，LUI 這條指令一樣是將 `imm[31:12]` 後面補 12-bits 的 0 之後，再做 sign-extension 到 64-bits，然後再存回去 `$rd` 暫存器。
而 AUIPC 則是將 `imm[31:12]` 的後面一樣補 12-bits 的 0 之後，先做 sign-extension 到 64-bits，再和當前的 PC 相加，最後將 64-bits 的運算結果存回 `$rd` 暫存器。

最後則是 LOAD/STORE 指令，因為 General Purpose Register 已經被擴充到 64-bits 的寬度，所以理所當然多了 LD/LDU 和 SD 這三個指令，而其中的 D 代表的是 **Double Word（64-bits）**。

### Architecture of A Simple ISS

在實作上，我們可以簡單地用 C 語言的 struct 來建立一個的資料結構，裡面包含了所有我們需要模擬出來的 Processor States。

```cpp linenums="1"
#include <stdint.h>
#include <bool.h>

#define MEM_SIZE 0x10000 (64-KiB)

typedef struct {
    uint64_t current_pc, new_pc; // Program Counter
    uint64_t regs[32];           // General Purpose Registers
    uint8_t  mem[MEM_SIZE];      // Main Memory
    bool  halt; // Halt signal
} cpu_state_t;

cpu_state_t* processor_ptr; // define the pointer of the processor state (main part of ISS)
```

要表示 Processor 的狀態，我們需要 PC、32 個暫存器還有 Main Memory。PC 會指向目前正在執行的指令**在記憶體中的地址**，而暫存器則是 Processor 最基本用來暫存運算結果的單位。至於一個程式的指令和資料本身，則都會被儲存在 Main Memory 中，Processor 會透過 LOAD/STORE 指令來存取 Main Memory，包含讀取指令、還有存取 data。

接下來，我們利用特殊的技巧（**Union + Bit-Field**）來定義指令的格式：

!!! danger
    注意，雖然我們實作的是 RV64I，但是每條指令**本身**都是 32-bits（4-bytes）。

```cpp linenums="1"
#include <stdint.h>
typedef union {
    struct {
        uint32_t opcode : 7;
        uint32_t rd : 5;
        uint32_t func3 : 3;
        uint32_t rs1 : 5;
        uint32_t rs2 : 5;
        uint32_t func7 : 7;
    } R_TYPE;
    struct {
        uint32_t opcode : 7;
        uint32_t rd : 5;
        uint32_t func3 : 3;
        uint32_t rs1 : 5;
        int64_t imm_11_0 : 12;
    } I_TYPE;
    struct {
        uint32_t opcode : 7;
        uint64_t imm_4_0 : 5;
        uint32_t func3 : 3;
        uint32_t rs1 : 5;
        uint32_t rs2 : 5;
        int64_t imm_11_5 : 7;
    } S_TYPE;
    struct {
        uint32_t opcode : 7;
        uint32_t rd : 5;
        int64_t imm_31_12 : 20;
    } U_TYPE;
    struct {
        uint32_t opcode : 7;
        uint64_t imm_11 : 1;
        uint64_t imm_4_1 : 4;
        uint32_t func3 : 3;
        uint32_t rs1 : 5;
        uint32_t rs2 : 5;
        uint64_t imm_10_5 : 6;
        int64_t imm_12 : 1;
    } B_TYPE;
    struct {
        uint32_t opcode : 7;
        uint32_t rd : 5;
        uint64_t imm_19_12 : 8;
        uint64_t imm_11 : 1;
        uint64_t imm_10_1 : 10;
        int64_t imm_20 : 1;
    } J_TYPE;
    uint32_t raw;
} riscv_inst_t;
```

然後再利用 C 語言中的 `enum` 來定義 OPCODE 和 function code，方便我們用來辨認不同的指令。

```cpp linenums="1"
/*
 * The name without any suffix (e.g., _FUNC3) represents the OPCODE type
 */
typedef enum {
    /* 12 types in total */
    OP = 0b0110011,
    OP_32 = 0b0111011,
    OP_IMM = 0b0010011,
    OP_IMM_32 = 0b0011011,
    LOAD = 0b0000011,
    STORE = 0b0100011,
    BRANCH = 0b1100011,
    JAL = 0b1101111,
    JALR = 0b1100111,
    AUIPC = 0b0010111,
    LUI = 0b0110111,
    SYSTEM = 0b1110011,
} OPCODE;

typedef enum {
    ADD_SUB_FUNC3 = 0b000,
    SLL_FUNC3 = 0b001,
    SLT_FUNC3 = 0b010,
    SLTU_FUNC3 = 0b011,
    XOR_FUNC3 = 0b100,
    SRL_SRA_FUNC3 = 0b101,
    OR_FUNC3 = 0b110,
    AND_FUNC3 = 0b111,
} ARITHMETIC_FUNC3;

typedef enum {
    BEQ_FUNC3 = 0b000,
    BNE_FUNC3 = 0b001,
    BLT_FUNC3 = 0b100,
    BGE_FUNC3 = 0b101,
    BLTU_FUNC3 = 0b110,
    BGEU_FUNC3 = 0b111,
} BRANCH_FUNC3;

typedef enum {
    SB_FUNC3 = 0b000,
    SH_FUNC3 = 0b001,
    SW_FUNC3 = 0b010,
    SD_FUNC3 = 0b011,
} STORE_FUNC3;

typedef enum {
    LB_FUNC3 = 0b000,
    LH_FUNC3 = 0b001,
    LW_FUNC3 = 0b010,
    LD_FUNC3 = 0b011,
    LBU_FUNC3 = 0b100,
    LHU_FUNC3 = 0b101,
    LWU_FUNC3 = 0b110,
} LOAD_FUNC3;

/*
 * Note that the SYSTEM type instructions use the I-Type format
 */
typedef enum {
    ECALL_FUNC12 = 0b000000000000,
    EBREAK_FUNC12 = 0b000000000001,
} SYSTEM_FUNC12;
```

!!! question
    你有注意到**至少目前**看到的所有 OPCODE 種類的 least significant 2-bits 都是 `0b11` 嗎，你知道原因是什麼嗎？（Hint：RISC-V C-Extension）

有了對於 Processor States 定義的資料結構之後，我們就可以開始思考要如何模擬 Processor 的運作。
ISA Simulator 的任務很簡單，就是**週而復始地讀取並執行指令**。
我們可以定義一個函式，作為 ISS 執行指令的最小單位，也就是**==每次呼叫這個函式只會執行一條指令==**。

```cpp linenums="1"
void execute_one_inst(cpu_state_t* proc_ptr) {
    const rsicv_inst_t *inst_ptr = (riscv_inst_t*)(&processor_ptr->mem[processor_ptr->pc]);
    OPCODE opcode = *inst_ptr & 0b1111111; // bitwise-AND
    switch (opcode) {
        case OP: {
            handle_OP(proc_ptr, inst_ptr);
            break;
        }
        case OP_32: {
            handle_OP_32(proc_ptr, inst_ptr);
            break;
        }
        case OP_IMM: {
            handle_OP_IMM(proc_ptr, inst_ptr);
            break;
        }
        case OP_IMM_32: {
            handle_OP_IMM_32(proc_ptr, inst_ptr);
            break;
        }
        case LOAD: {
            handle_LOAD(proc_ptr, inst_ptr);
            break;
        }
        case STORE: {
            handle_STORE(proc_ptr, inst_ptr);
            break;
        }
        case BRANCH: {
            handle_BRANCH(proc_ptr, inst_ptr);
            break;
        }
        case JAL: {
            handle_JAL(proc_ptr, inst_ptr);
            break;
        }
        case JALR: {
            handle_JALR(proc_ptr, inst_ptr);
            break;
        }
        case LUI: {
            handle_LUI(proc_ptr, inst_ptr);
            break;
        }
        case AUIPC: {
            handle_AUIPC(proc_ptr, inst_ptr);
            break;
        }
        case SYSTEM: {
            handle_SYSTEM(proc_ptr, inst_ptr);
            break;
        }
        default: {
            Panic("Unsupported instruction: %x\n", inst_ptr->raw);
        }
    }
    /* update program counter */
    proc_ptr->current_pc = proc_state->new_pc;
}
```

至於怎麼實作這些 Handler Function，這就是本次作業的一大重點了，大家就參考助教提供的 Sample Code 吧！
助教在範例中只實作了 `addi` 和部分 `ecall` 指令的功能，並且用這兩條指令 Demo 了和經典的程式 `printf("Hello, World!\n")` 相同的效果，剩下的指令就需要靠大家自行完成。

當我們實作好對**執行一條指令**這個行為的函式封裝之後，我們就可以基於 `execute_one_inst()` 來控制整個 ISS。譬如，我可以再這之上建構一個函式 `void execute_insts(unsigned inst_count)`：

```cpp linenums="1"
void execute_insts(unsigned long inst_count) {
    for (unsigned i = 0; (i < inst_count) && (!processor_ptr->halt); i++){
        execute_one_inst();
    }
}
```

!!! question
    大家如果觀察助教提供的 Sample Code 當中可以發現，助教對於 interactive interface 的 `c` 指令的實作方式就是呼叫 `execute_insts(-1)`，你是否可以解釋為什麼要傳入 -$1$ 呢？

### Why Do We Need SYSTEM Instructions?

大家一定要有下面這張圖的觀念：

<figure markdown="span">
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/c0e133d1-756c-4243-bc8f-4ee472bf039c.png){ width=500 }
</figure>

我們所使用的測試程式，是經由 RISC-V GNU Toolchain 編譯器編譯，最終變成使用 RISC-V 指令的可執行檔案，而我們在 Lab 2 所設計的 RISC-V ISA Simulator，則是一支**不折不扣的 x86 程式**。
也就是說，我們的 ISS 是直接跑在我們自己的電腦之上（這邊先忽略作業系統），但是測試程式的 RISC-V Program 則不是。因為 RISC-V Program 使用的是 RISC-V 指令，我們的 x86 電腦不認得這些指令，所以必須經由我們設計的 ISS 做轉換，才有辦法**看起來**可以直接在我們的電腦上執行。

!!! note
    其實我們所設計的 ISA Simulator，就有點類似編譯器領域當中所謂的直譯器（Interpreter），它可以動態地解析 RISC-V 指令並且執行指令所被定義的行爲。

我們首先有一件非常重要的事情需要探討，那麼就是當我們的 RISC-V Program 需要有 I/O 的功能的時候（e.g., `printf` and `scanf`），我們該怎麼d實作？
會需要探討這個問題是因為，以我們最常用的輸出輸入裝置，鍵盤（輸入）和螢幕（輸出）來說，這些裝置是接在我們的電腦上，但是 RISC-V Program 並不是**直接**運行在我們的電腦上，而是中間還隔了一個 ISS。
如果我們的 RISC-V Program 需要輸出輸入的功能的話，必須向自己所處的執行環境（Eexcution Environment）發起服務請求（**Service Request**），以目前的情境來看，對 RISC-V Program 來說 Execution Encironment 就是我們的 ISS。
根據 RISC-V 規格書上的描述，SYSTEM 這類的指令的功能是：

> SYSTEM instructions are used to access system functionality that might require privileged access and
are encoded using the I-type instruction format. The ECALL instruction is used to make a service request to the execution environment.<br>
> ----- RISC-V Specification Volume 1

也因此我們可以藉由實作 ECALL 指令，讓 RISC-V Program 有能力向 ISS 發出請求，委託其幫忙處理關於 I/O 的任務。

所以我們必須去定義 **Execition Environment Interface（EEI）**，當 ECALL 指令被執行的時候，我們該如何辨別目前 RISC-V Program 到底發出了什麼類型的請求？

最常見的做法是，我們可以規定當執行到 ECALL 指令的時候，必須觀察暫存器 `$a0` 中的值，來決定 RISC-V Program 發出的 service request type。

- ==當執行到 ECALL 的時候，首先觀察 `$a0` 暫存器中的數值==
    1. `$a0 == 0`<br>
        代表程式已經執行結束，應該將 Processor State 中的 `halt` 設為 true
    2. `$a0 == 1`<br>
        代表程式向執行環境發出 `putchar` 的請求，其中需要被印出的 character 的值會被放在暫存器 `$a1` 當中

### ISS with Debugging Interactive Interface

延續在 Lab 1 當中我們利用 *readline* library 實作的 interactive interface，我們在實作 ISS 的時候，可以效仿類似 GDB 的 C language debugger，提供一系列我們定義好的指令，讓 ISS 的使用者可以藉由這些指令直接操作 ISS，方便使用者 debug。

!!! note
    請特別注意，這裡所說的方便 Debug 並不是只方便我們 Debug ISS 本身，而是方便我們之後用 ISS 跑我們自己寫的 RISC-V Program 的時候，可以方便 Debug RISC-V Program 本身

具體來說，我們應該要讓我們的 ISS 支援以下總共**九條**指令：

| Command | Format                         | Example                         |
|:-------:|:-------------------------------|:--------------------------------|
| help    | help [command]                 | help <br> help quit             |
| quit    | quit                           | quit                            |
| c       | c                              | c                               |
| si      | si [N]                         | si <br> si 5                    |
| break   | b [Inst. Address]              | break <br> break 0x10           |
| watch   | watch <expression>             | watch <br> watch ($a0 == 10)    |
| disable | disable <b or w\> <number\>    | disable b 1 <br> disable w 0    |
| reg     | reg <pc or gpr\>               | reg pc <br> reg gpr             |
| mem     | mem <N\> <Base Address in Hex\>| mem 4 0x10                      |

每條指令的功能敘述如下：
    
1. **help**<br>
  > 印出支援的指令和對應的訊息
2. **quit**
  > 離開 Simulator
3. **c**
  > 持續執行指令直到遇到 breakpoint、watchpoint 或是程式退出
4. **si**
  > 執行 $N$ 條指令，其中 $N$ 是大於零的正整數（如果沒有傳入 $N$ 則預設 $N$ 等於 $1$）
5. **break**
  > 列出目前所有 breakpoint（編號從零開始），或是設置新的 breakpoint
6. **watch**
  > 列出目前所有 watchpoint（編號從零開始），或是設置新的 watchpoint（只要支援對 Register 設定 watchpoint 即可）
7. **disable**
  > **以編號**來刪除現有的 breakpoint 或是 watchpoint
8. **reg**
  > 查看 PC 或是 GPR 的值（Ps：GPR 應該要把 32 個暫存器全部都 show 出來）
8. **mem**
  > 查看 Main Memory 的內容，以 Hex 的格式印出，可以指定要輸出 $N$ 個 word（32-bits）

## How to Compile and Run

如同 Lab 1，在 Lab 2 中助教一樣已經提供 Makefile 讓大家可以直接使用，只要在 `lab-2` 路徑底下輸入 `make` 即可編譯 ISS 本身還有在 `lab-2/src/test-prog` 底下的測試程式。

如果你想要使用 ISS 執行測試用的 RISC-V Program 的話，以 `lab-2/src/test-prog/hello.c` 為例，你可先 `make` 之後，進入 `build` 資料夾，然後輸入 `./main.elf hello.elf`，進入 ISS 之後再輸入 `c` 讓 ISS 持續執行直到 RISC-V Program 結束為止。
正常來說，你應該會看到如下的輸出：

<figure markdown="span">
  ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/5a5b4e6a-dbfc-47fc-9649-8914e4800a2b.png){ width=750 }
</figure>

> 更多測資，待助教完成後會**再**更新 Chapter 4 的內容。

## Start to Do Assignment

1. Clone the sample code
    - 先確定自己已經打開課程開發環境（Container），並且在環境中的 `workspace` 底下
    - 下載助教提供的 Sample Code
      > `git clone https://gitlab.course.aislab.ee.ncku.edu.tw/113-1/lab-2.git`
    - 進入資料夾
      > `cd lab-2`
2. Create a private repo
    - 如同 Lab 1 所述，在 Gitlab 上面創建個人 Repo，並且命名為 `Lab 2`，請不要勾選 *Initialize the repository with README*
    - 確認 branch 的名稱為 main 而非 master
      > `git branch -M main`
    - 新增自己的 Private Gitlab Repo 為 Remote Source
      > `git remote add private <HTTPS URL of your private repo>`
3. 將程式碼 Push 你的 Private Repository
    - 請記得是推到 `private` 而非 `origin`
      > `git push -u private main`
4. Notes
    - 因為在**預設**情況之下，只要 Gitlab Repo 中包含 `.gitlab-ci.yml` 檔案就會觸發 CI/CD Pipeline，如果你在前期尚未完成作業的時候不想觸發 Pipeline，可以先在 Gitlab 你的 Private Repo 中的設定將 CI/CD 功能關閉，待完成作業之後再打開
5. **請記得依據 [Assignment Report Template](https://hedgedoc.course.aislab.ee.ncku.edu.tw/UBTl2mSKSRSW11GQXuOKTA?view) 撰寫本次作業的報告，並且繳交報告連結到成大 Moodle 作業繳交區上**
