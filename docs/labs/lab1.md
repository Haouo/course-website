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

## What happens when you compiling a C program?

或許大家在大一修計算機概論的時候，有聽過上課的老師講過 C 語言的編譯流程，但也有可能，老師要求大家安裝 Visual Studio（不是 VS Code，兩個東西不一樣），然後你在 Visual Studio 上面只要按一個按鈕就可以編譯然後執行你的程式。

## Some Special Parts in C Programming

### Function Pointer

大家如果有寫過 C++ 的話，應該都有使用過指標（Pointer），像是動態陣列（Dynamic Array）的使用，如果我們不依賴 STL 中的 vector 的話，就必須使用指標來建立和操作動態陣列。

### String Manipulation

大家對於字串的操作可能會比較熟悉 C++ 中的 iostream 和 string 這兩個 Standard Library，但是，這堂課除了 RTL Testbench 的撰寫會使用 C++ 以外，我們一律都是使用 C 語言來撰寫我們的程式。所以，這在個部分我們會介紹在 C 語言當中我們該如何進行一些常見的字串操作。

## Simple Interactive Program Design

在 Lab 3 中我們會練習去實作一個 ISA Simulator（ISS），這個程式的功能是模擬指令集的行為，簡單來說同學可以理解成模擬一個 Single-Cycle CPU，更多細節我們在 Lab 3 會詳細解說。這個 ISS 使用起來會想是 GDB 一樣，有一個互動式介面（Interactive Interface），簡單來說就是這個程式會印出一個 Prompt，然後等待使用者輸入指令。當街收到特定的指令之後，就會去做對應的事情。
