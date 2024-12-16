!!! info Update Info
    - Contributor: TA 峻豪
    - Last update: 2024/12/15

!!! note "What Every Programmer Should Know About Memory"
    本文的內容大量參考自 Ulrich Drepper 撰寫的論文 [What Every Programmer Should Know About Memory](https://people.freebsd.org/~lstewart/articles/cpumemory.pdf)，
    本論文亦有中文翻譯 [每位程式開發者都該有的記憶體知識](https://sysprog21.github.io/cpumemory-zhtw/)。

## Introduction to Memory Hierarchy

## Random Access Memory (RAM)

> The first interesting details are centered around the ques-tion why there are different types of RAM in the samemachine.
> More specifically, why are there both staticRAM (SRAM5) and dynamic RAM (DRAM). The for-mer is much faster and provides the same functionality.
> Why is not all RAM in a machine SRAM? The answeris, as one might expect, cost. SRAM is much more ex-pensive to produce and to use than DRAM.
> Both thesecost factors are important, the second one increasing inimportance more and more. To understand these differ-ences we look at the implementation of a bit of storagefor both SRAM and DRAM.
>
> ----- What Every Programmer Should Know About Memory, Chapter 2.1

### RAM Types

#### Static RAM

#### Dynamic RAM

### DRAM Access Technical Details

## CPU Cache

## Virtual Memory
