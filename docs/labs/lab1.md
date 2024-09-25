# C Programming and Compilation Flow

!!! info
    - Contributors : TA 峻豪
    - Deadline : ==2024/XX/XX==
    - Last updated : 2024/09/22
    <!-- - Video link : <a href="https://youtube.com/" target="_blank">CO2024 Fall lab1 video</a> -->

??? tip "updates information"
    - Update 2024/08/13：新增此 block，作為更新依據
    - Update 2024/08/05：新增 Lab 1 page
    - Update 2024/09/22：撰寫部分內容
    - Update 2024/09/26：完成內容撰寫

## Chapter 1. What happens when you compiling a C program?

或許大家在大一修計算機概論的時候，有聽過上課的老師講過 C 語言的編譯流程，但也有可能，老師要求大家安裝 Visual Studio（不是 VS Code，兩個東西不一樣），然後你在 Visual Studio 上面只要按一個按鈕就可以編譯然後執行你的程式。但是，在計算機組織這們課當中，我們不能再像以往一樣忽略 C 語言的編譯流程和原理，我們必須要整個編譯的原理有基本的掌握，大家在後面的課程才能融會貫通。

<div style="text-align: center;">
    <img src="https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7b73b786-5245-4724-b354-45e07c3d2b36.png">
    <p><u>CS:APP3e Page 41</u></p>
</div>

上面這張圖描繪了經典的一個 C Program 如何從 Source Code 變成最後的可執行檔（Executable File），其中總共會經過四個階段，分別是 **Pre-Processing**、**Compiling**、**Assembling** 和 **Linking**，我們針對這四個部分分別做簡單的介紹。

### Pre-Processing

我想大部分的人一定都有打過下面這段程式碼：

```cpp linenums="1"
#include <stdio.h>
#include <stdlib.h>
```

你最直覺的想法可能會覺得說，為了要使用輸出輸入相關的 function，為了要使用一些 standard library 提供的 fucntion，我要 include 這些 header files，但你有沒有想過這背後到底怎麼運作的？

當 Preprocessor（前置處理器）看到以 `#...` 為開頭的程式碼片段時，就會知道要對其做相對應的前置處理。基本上前置處理可以理解成單純的**文本處理和替換**，並不會設計到任何和 Compling 相關的行為，但即使只是單純的文本處理，善用 Preprocessing 依然可以讓 C 語言有非常強大的擴充能力。

我們分析一個具體的例子，大家在大一的時候可能有聽過計概課的老師說，C 語言在宣告陣列的時候，不可以傳入變數作為初始陣列大小，例如：

```cpp linenums="1"
int a = 5;
int arr[a] = {};
```

這種宣告程式稱為 **Variable-length Array (VLA)**，這在 C90 標準是不被允許的，一直到 C99 才正式納入 C 語言標準規範中。但是，大家如果用常見的編譯器如 GCC 去編譯這樣的程式的話，即使你指定使用 `-std=c90`，可能還是會發現 GCC 不會出現 Compilation Error，這是因為 GCC 本身有 GNU Extension，也就是編譯器本身對於語言的擴充，使其支援 VLA 這樣的宣告。所以，我們可以嘗試使用 `gcc -Werror -std=c90 -pedantic ...` 這樣的指令去編譯，使其強制遵守 C90 的規範，就會看到錯誤訊息如下：

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/938a0cab-bfb7-4124-9ccc-1bded1da3abe.png)

但當我們修改程式碼，變成以下的形式

```cpp linenums="1"
#define a 5
int arr[a] = {};
```

我們會發現編譯錯誤消失了，這段程式碼即使在 C90 的標準下依然可以正常編譯，為什麼？這正是因為 Pre-processor 的行為所致。當我們使用 `#define a 5` 而非 `int a = 5` 的時候，差別在於，當我們使用 `#define` 時，在編譯流程中的 Pre-processing 階段，Preprocessor 就會將程式碼片段中所有的 `a` 等價替換為 `5`，因此，最後實際進入 Compiler 的程式碼片段其實會變成 `int arr[5] = {};`，因為當中的 `a` 已經被替換成 `5` 了，也就不會變成 Variable-length Array 從而觸發編譯錯誤。所以其實在這個例子中，Pre-processor 所做的工作就是文本替換。

回到最一開始我們提到的 `#include <stdio.h>`，為什麼只要寫下這段 code 我們就可以使用像是 `printf()` 這類 I/O 相關的函式？TBD

!!! info
    - 關於 `-pedantic` 的描述

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/4c5d4ba0-2605-4efe-b07c-6c538e525a4c.png)
    - 關於 GNU Extension 本身對於 VLA 的支援

        ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/2b0996bc-781c-45c3-90eb-f0e83b8e6b55.png)

### Compiling

Compile 的這個過程，就是把 C Code 轉換成 Assembly 的過程，所以是從高階語言轉換到低階語言，這個過程基本上是整個編譯流程中最複雜的一件事情，原因有很多，加上目前同學還沒學完 Instruction-Set Architecture（ISA）的完整概念，所以我們在目前的階段比較難完整向大家說明 Compiler 的概念。但是，**因為 C 語言同時兼具高階語言和低階語言的特性**，也就是說，C 語言有相對抽象的語法，例如 For-loop Statement、if-else Statement、Structure、Function ... 等等諸如此類相對抽象的語法可以使用，卻也同時有低階語言的特性，例如 C 語言可以透過指標直接對記憶體進行存取。利用這個特性，我們可以避開對 ISA 內容的了解，卻也可以解釋 Compiler 的職責到底是什麼。

```cpp linenums="1"
#include <stdio.h>
int main() {
    int array[5] = {10, 20, 30, 40, 50};

    // Using a for-loop to access and print array elements
    for (int i = 0; i < 5; i++) {
        printf("%d\n", array[i]);
    }
    return 0;
}
```

以上面這段程式碼為例，我們主要使用到 Array 和 For-Loop 這兩個語法，這是相對高階（也就是相對抽象）的語法。但是，同樣是使用 C 語言，我們也可以換個方式撰寫，但同時達到一樣的效果。

```cpp linenums="1"
#include <stdio.h>
    int *ptr = alloca(sizeof(int) * 5); // allocate a memory space for integer array
    *(ptr) = 10;
    *(ptr + 1) = 20;
    *(ptr + 2) = 30;
    *(ptr + 3) = 40;
    *(ptr + 4) = 50;
    int i = 0; // loop index

start_loop:
    if (i >= 5) goto end_loop; // Check loop condition

    printf("%d\n", *(ptr + i)); // Access the array element using pointer arithmetic
    goto start_loop; // Repeat the loop

end_loop:
    return 0;
}
```

大家可以看到，經過改寫後，Array 和 For-Loop 這兩個語法都不見了，取而代之的是使用 GOTO 來達成和 For-Loop Statement 一樣的功能，和使用指標對記憶體進行操作。這是相對很低階的 C 語言寫法。（這裡的 *低階* 並不是指這樣寫很爛，而是指語法相對低階，更加接近機器所能理解的形式，而非人直覺理解的形式）

其實 Compiler 所做的事情就**類似**於上面我們做的事情，改寫這段 Code，把它從相對抽象的表示方式轉換成更接近機器所能理解的指令。

!!! info
    <div style="text-align:center">
        <img src="https://miro.medium.com/v2/resize:fit:1116/1*KmC_EtMxS5ttRKGi8VYwgg.png"><p><u>Framework of LLVM</u></p>
    </div>

    上面我們將高階的 C 語言寫法轉換成低階的 C 語言寫法，其實就很像是在把原語言轉換成 IR 的這個過程，Compiler 通常會基於 IR 做一系列的最佳化，讓程式碼的 Performance 更好，如圖片中的 LLVM Optimizer，然後再將經過優化的 IR 經過編譯器後端（Backend）轉換成目標語言，如 x86、ARM 或 RISC-V 的指令。至於這樣做的優點是什麼，就留給大家自行 STFW。

!!! warning
    - 為什麼是使用 `alloca()` 而不是更常見的 `malloc()` 來動態配置記憶體呢？你知道這兩者的差異嗎？
        - Hint: 可以利用 man 指令去查，`man alloca` and `man malloc`
    - 單純使用 GOTO 可以達成和 While-Loop 或 For-Loop 上的邏輯等價（Logically Equivalent）嗎？

### Assembling

Assembling（組譯）的過程相較於 Compiling 簡單很多，因為經過 Compiling 之後，我們已經得到 Assembly-Level 的程式碼，而根據不同的 Instruction-Set Architecture（ISA），每條組合語言指令都可以**唯一**對應到一個機械碼（Machine Code），而在 Assembling 階段，Assembler 要做的事情就是將每個 Assembly Instruction 轉換成對應的 Machine Code。

### Linking

大家有沒有想過，為什麼你可以把 A Function 定義 `a.c` 中，卻還是可以在 `b.c` 中去呼叫 A Function 呢？可以達成這樣子的功能，正拜 Linker 所賜。因為 Linking 的細節，等到大家學完 RISC-V ISA 之後，再來介紹會比較好理解，我們這裡先簡單講解，就不深入 Linking 的細節。

當我們使用 `gcc -c ...` 去編譯一個 C Source File 的時候，當中的 `-c` 選項代表告訴 GCC 不要進入 Linking 的階段，也就是說，我們的編譯過程只會經過 Pre-processing、Compiling 和 Assembling，轉換成 Machine Code，但是是**尚未經過 Linking 的 Object Code**，這時候，當我們的 Source File 中有 Undefined Symbol 的時候，它會先把這個 Symbol 的位置打一個問號，而這個問號就會交由 Linker 來解決，在 Linking 階段的時候把問號的部分填入正確的記憶體位置。

!!! info
    ### What is GCC?
    
    GCC 的全名其實是 The GNU Compiler Collection，GCC 其實並不是指單純的 Compiler，GCC 其實包含了一系列的工具，有 Pre-processor、Compiler、Assembler 和 Linker ... 等等。我們可以輸入 `man gcc` 看看 GCC 的 manual。<br>   
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7fae81ea-16e1-4b78-a34d-856e3f6b1e07.png)<br>
    
    GCC 其實是所謂的 ***Compiler Driver***，也就是說，GCC 並不是指單純的 C Compiler（一開始是，但後來就不是了），當你輸入 GCC 指令試著去編譯程式的時候，其實它背後會自動地驅動一整個 Compilation Flow 會用到的工具，也就包含了前面提到的 Pre-processing、Compoling、Assembling 和 Linking，其實這四個 Stage 都用到不同的工具，Pre-processing 用到 `cpp`，compiling 用到 `cc`，Assembling 用到 `as`，而 Linking 用到 `ld`，這四個個別其實都可以作為獨立的指令使用。Driver 的意思就像是駕駛一樣，左為編譯器的駕駛，它會自動驅使編譯過程中需要用到的所有工具，以完成整個編譯流程。
    
    > GCC（GNU Compiler Collection）被稱為「Compiler Driver」是因為它不僅是一個單獨的編譯器，而是一個整合了多個編譯器和工具的系統。以下是一些主要原因：
    >
    >1. **多語言支持**：GCC 支持多種編程語言（如 C、C++、Fortran、Ada 等），這使它不僅僅是一個單一的編譯器，而是一個可以調用不同編譯器的驅動程式。
    >
    >2. **前端和後端**：GCC 的架構由前端（負責語法分析和生成中間代碼）和後端（負責生成目標機器碼）組成。它作為驅動程式，可以根據輸入的源碼和選項，選擇相應的前端和後端。
    >
    >3. **統一接口**：GCC 提供了一個統一的命令行接口，讓使用者可以方便地管理不同的編譯流程，例如編譯、連接和預處理等。這種集中管理的特性使它更像是一個「驅動程式」。
    >
    >4. **工具鏈整合**：GCC 還可以集成其他工具，如鏈接器（linker）、預處理器（preprocessor）等，使得整個編譯過程更加流暢和高效。
    >
    >因此，稱 GCC 為「Compiler Driver」是因為它在編譯過程中扮演了指揮和整合多個工具的角色，而不僅僅是單一的編譯器。
    >
    > --- ChatGPT

## Chapter 2. Some Special Parts in C Programming

### Pointer and Multidimensional Dynamic Array

!!! success
    在 C 語言中，Array **本質上**就是 Pointer + Offset！你可以把 C 語言中 Array 的語法，如 `int arr[10] = {};` 這樣子的 statement 想像成**語法糖（Syntax Sugar）**。

為了幫大家複習 Pointer 的概念，助教認為最好的方式是來做一個 Case Study，在這裡我們可以來探討 `int main(int argc, char** argv)`，或是 `int main(int argc, char* argv[])` 代表的到底是什麼意思？為什麼這樣寫就可以讓我們的程式接收外部參數？TBD

<div style="text-align:center"><img src="https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/d5f4cded-a088-43d1-b5f2-6e552c4d46c1.png" width=700><p><u>Visualization of char** argv</u></p></div>


!!! warning
    為什麼 `char** argv` 和 `char* argv[]` 這兩個寫法是等價（Equivalent）的？你有辦法用你對 Pointer 的理解來解釋為什麼嗎？

### Function Pointer

Funtion Pointer 的概念基本上跟一般的 Pointer 一模一樣，關鍵在於：『==Everything about the program is stored in memory==』。大家應該可以理解變數需要被儲存在記憶體中，這是很直覺的事情，那函式呢？函式被放在哪裡？函式其實就對應到一條一條的指令，而指令也理所當然應該被存放在記憶體當中，所以有函式的指標（Pointer to a function）這件事情就變得理所當然！因為指標其實就是我們可以拿來**直接操作**記憶體的一項利器，既然函式也被存放在記憶體中，那有一個指標指向特定的函式也就相當合理。

那麼，Funtion Pointer 應該指向 Function 的哪裡？答案很間單，FUnction Pointer 應該指向特定函式的進入點（Entry Point），也就是我們呼叫函式之後，跳轉到函式的時候，執行的第一條指令的位置。

```cpp linenums="1"
int add(int a, int b) {
    return a + b;
}

#include <stdio.h>
int main(void){
    int (*func_ptr)(int, int); // declare a function pointer
    func_ptr = &add; // use address-of operator to get the address of function add()
    // func_ptr = add; is also a legal statement (address-of operator is not necessary)
    printf("Add %d and %d and we can get %d\n", 10, 20, func_ptr(10, 20));
    return 0;
}
```

上面的程式碼示範了如何宣告並且使用一個 Function Pointer。宣告 Function Pointer 的時候，要一併把函數的回傳值型態和參數型態寫完整，所以以 `func_ptr` 來說，他可以指向回傳型態是 `int` 並且帶有兩個 `int` 作為參數傳入的函式。（可能有點饒口，大家可以慢慢想 XD）

剛宣告 `func_ptr` 的時候，目前這個 Function Pointer 並未指向任何 Function，所以才會有第八行的程式碼：`func_ptr = &add`，我們利用 **Address-of Operator** 來拿到 `add()` 這個 function 的記憶體位置，並且將其 assign 給 `func_ptr`，接下來我們就可以藉由 `func_ptr` 來呼叫 `add()` 這個函式。

那麼 Function Pointer 到底有什麼用處？我們示範一個很簡單的例子，讓同學看到 Function Pointer 可以被應用在怎樣的場景。

```cpp linenums="1"
typedef int (*calculate_func_t)(int, int);

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }
int div(int a, int b) { return a / b; }

int calculate(int a, int b, calculate_func_t cal_func){
    return cal_func(a, b);
}

int main() {
    int a, b, choice, result;
    
    // Array of function pointers
    calculate_func_t operations[4] = {add, sub, mul, div};
    const char *operation_names[4] = {"Addition", "Subtraction", "Multiplication", "Division"};

    // User input
    printf("Enter two integers: ");
    scanf("%d %d", &a, &b);
    
    printf("Choose an operation:\n");
    for (int i = 0; i < 4; i++) {
        printf("%d. %s\n", i + 1, operation_names[i]);
    }
    printf("Enter your choice (1-4): ");
    scanf("%d", &choice);

    // Validate user input
    if (choice < 1 || choice > 4) {
        printf("Invalid choice.\n");
        return 1; // Exit with error
    }

    // Use the function pointer from the array based on user choice
    result = calculate(a, b, operations[choice - 1]);
    printf("The result is: %d\n", result);

    return 0;
}
```

適當的使用 Function Pointer 可以讓程式碼變得更簡潔，同時不失可讀性。

### String Manipulation

大家對於字串的操作可能會比較熟悉 C++ 中的 iostream 和 string 這兩個 Standard Library，但是，這堂課除了 RTL Testbench 的撰寫會使用 C++ 以外，我們一律都是使用 C 語言來撰寫我們的程式。所以，這在個部分我們會介紹在 C 語言當中我們該如何進行一些常見的字串操作。

我們先介紹 String 在 C 語言中的基本概念；基本上，大家可以把 String 看作是一個由字元（Character）組成的陣列（Array）， 

在 C 語言當中，我們最常使用 `string.h` 這個 C 標準函式庫來進行字串相關的操作，我們可以在 terminal 中輸入 `man string` 來查看關於這個函式庫的基本資訊。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/e93816db-fa75-45fe-abab-4294f80a265c.png)

!!! success
    請善用 `man` 指令，可以讓你即時查到很多東西，也可以練習並且養成讀英文文件的習慣。

在這個 Lab 中，我們可能會用到下面這幾個 function：

- `strcpy` 和 `strncpy`
- `strcmp`
- `strcat`
- `strlen`
- `strtok`

至於這些函數怎麼使用，這是你應該去查的！（STFW、RTFM）


## Chapter 3. Simple Interactive Program Design

在 Lab 3 中我們會練習去實作一個 ISA Simulator（ISS），這個程式的功能是模擬指令集的行為，簡單來說同學可以理解成模擬一個 Single-Cycle CPU，更多細節我們在 Lab 3 會詳細解說。這個 ISS 使用起來會想是 GDB 一樣，有一個互動式介面（Interactive Interface），簡單來說就是這個程式會印出一個 Prompt，然後等待使用者輸入指令。當接收到特定的指令之後，就會去做對應的事情。

因為我們並還沒教大家 RISC-V ISA，所以在 Lab 1 當中，我們只是練習實作這樣的 Interactive Interface，而這個程式的功能則和 ISS 無關，取而代之的是，我們實作一個 **Graph Analyzer**。

!!! info
    ### What is Graph?
    
    > 大家應該在資料結構這門課會第一次學到 Graph 這個資料結構，Graph 在真實世界中的應用非常廣泛，最常見的 Social Network Analysis、EDA Tool、Network Flow Analysis ... 等等，就連最近的 LLM 甚至也有 Graph 相關的應用，真的可以說 Graph is everywhere。所以才想說在 Lab 1 提早讓大家接觸到 Graph 這個資料結構，雖然大家可能都沒學過，但是現在 ChatGPT 太強大了，相信大家要把作業寫出來應該是彈指間的功夫而已。<br>
    > --- TA 峻豪
    
    在計算機科學中，**Graph** 是一種由節點（或稱為頂點）和邊組成的數據結構。它用於表示物件之間的關係。圖可以是有向的或無向的，根據邊的方向來分類。
    
    <div style="text-align:center"><img src="https://cdn-images-1.medium.com/max/800/1*dX9TdlR6wD5lkPnWG1h80g.png"></div>
    
    #### 兩種常見的圖的表示資料結構
    
    1. **鄰接矩陣（Adjacency Matrix）**
        - 這是一個二維數組，大小為 $V \times V$，其中 $V$ 是圖中的節點數。
        - 如果存在從節點 $i$ 到節點 $j$ 的邊，則矩陣的 $(i, j)$ 位置為 1（或邊的權重），否則為 0。
        - **優點**：查詢兩個節點是否相連的操作非常快速，時間複雜度為 $O(1)$。
        - **缺點**：空間效率較低，尤其是對於稀疏圖（邊數遠少於節點數的情況），因為需要 $O(V^2)$ 的空間。
    2. **鄰接表（Adjacency List）**
        - 這是一組鏈表或數組，其中每個節點都有一個列表，該列表包含與其相連的所有節點。
        - 通常，每個節點的列表中存儲相鄰節點的編號（及可選的邊的權重）。
        - **優點**：在稀疏圖中更節省空間，因為只存儲實際存在的邊，空間複雜度為 $O(V + E)$，其中 $E$ 是邊的數量。
        - **缺點**：查詢兩個節點是否相連的操作較慢，最壞情況下需要 $O(V)$。
    3. **常見的 Graph Algorithm**
        - Depth-First Search (DFS)
        - Breadth-First Search (BFS)
        - Kruskal's Algorithm (for Minimal-Spinning Tree)

### Graph Analyzer with Interactive Interface

關於基本的 Interactive Interface 的 code framework 助教已經有提供，所以其實同學只要擴充這個助教給的框架，加入指定的指令，使其變成一個完整的 Graph Analyzer 即可。具體來說，這個 Analyzer 應該要支援下面這些指令：

1. `read <file name>`
    - 我們實做的是無向圖（Undirected Graph），並且每個邊都會有對應的權重（Weight）
    - 讀取定義 Graph 的檔案，這個檔案的第一行是一個數字，表示總共有幾個 Vertex，緊接著一個二維陣列 $M$，使用 Adjacency Matrix 表示 Graph 的 Vertex 和 Edge 的關係
    - $M[i, j]$ 代表 $V_i$ 和 $V_j$ 之間 Edge 的權重（Weight），如果是 0 的話表示 $V_i$ 和 $V_j$ 之間不存在 Edge
    - Example File
        ```shell linenums="1"
        5
        0 5 4 0 1
        0 0 1 2 1
        1 7 0 0 3
        0 2 0 0 6
        0 4 0 6 0
        ```
2. `minpath <v1> <v2>`
    - 計算 $V_1$ 和 $V_2$ 之間的**最短路徑**的距離，輸出為一個自然數 $N$
    - 如果 $V_1$ 和 $V_2$ 不存在路徑的話，則輸出 $-1$
3. `canreach <v1> <v2>`
    - 判斷 v1 和 v2 之間是否存在路徑（Path），輸出 `true` 或 `false`
4. `mst`
    - 輸出 Graph 的 Minimal-Spanning Tree 的所有 edge 的 weighted-sum
    - 輸出為一個自然數 $N > 0$
5. `help [command]`
    - 輸出指令的詳細資訊和使用方法
    - 若使用者輸入 `help`，後面沒有跟著其他 argument 的話，則輸出所有**支援的**指令的資訊
    - 若使用者輸入 `help cmd1` 的話，則只要輸出 cmd1 的資訊即可
6. `quit`
    - 退出程式

==如果 Graph Analyzer 尚未讀取檔案的話==，則 `minpath`、`canreach` 和 `mst` 指令都應該直接輸出 `Please read the file first` 這段文字。

!!! info
    `[...]` 內的東西代表是可有可無的參數，而 `<...>` 內的東西代表示必要參數。

### Start to Do The Assignment

1. 請先創建一個個人的 Repository，命名為 `Lab 1`，並把權限設定為 Private，並且請**不要**勾選 <u>Initialize repository with README</u>
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/3a054c9a-6e1a-446c-a868-4cd396999404.png)
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/e608c988-c8f7-40d6-b0ae-22bde2627abd.png)
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/37633adc-3f47-44e2-baa7-8e365e2d2ee0.png)
2. 下載助教提供的 Sample Code，裡面包含前面提到的 Interactive Interface Framework，並且新增 Remote Repository
    ```shell linenums="1"
    $ git clone https://gitlab.course.aislab.ee.ncku.edu.tw/113-1/lab-1.git
    $ git remote add private <URL of your private repo>
    ```
    Ps: 助教提供的 Code Framework 只是**參考用**，不一定要沿用助教給的程式碼。
3. Assignment Report 請使用 HedgeDoc 撰寫，並且使用助教提供的 [Assignment 1 Report Template](https://hedgedoc.course.aislab.ee.ncku.edu.tw/aMbIiUSfS7-o2-fjzDBhzg?view)<br>進入 HedgeDoc 之後，可以看到右上角有一個**建立筆記**的按鈕，按下去之後即可建立一個新的筆記，並請複製 Template 的內容然後撰寫你的報告
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/25eba9a2-96c9-4137-bcc0-cfd100df5e07.png)
4. 當你準備 Push 的時候，應該要先新增你自己的 Remote Repository 為新的 Remote
    ```shell linenums="1"
    $ git remote add private <URL of your private remote repo>
    $ git push -u private main
    ```
    請不要 Push 到助教提供的 Remote Repo 上 :)
5. **如何編譯程式**
    - 基本上你可以先使用助教所提供的 Makefile 來編譯程式，只要輸入 `make` 命令即可自動編譯
    - 你應該要嘗試讀懂助教提供的 Makefile，這樣可以讓你對 GCC 的用法有基本的認識，也可以知道基本的 Makefile 該如何撰寫
