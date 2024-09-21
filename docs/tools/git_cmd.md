# Git 指令教學

!!! info
    - Contributors: TA 峻豪 
    - Last updated: 2024/09/22

!!! success
    推薦閱讀高見龍撰寫的關於 GIt 的系列文章：[為你自己學 Git](https://gitbook.tw/)

---


!!! danger
    告誡各位同學，學會 Git 基本上是大家以後作為工程師的基本能力，使用 Git 也是多人專案合作最常見的管理方案。現在不學，就是等著以後進公司被電到起飛。

## Introduction to Version Control System: Git

什麼是版本控制系統（Version Control System）？為什麼需要做專案的版本控制？試想，當你今天滿心期待的寫好心 Function 之後，結果 Test 一跑，X！一個 Test Case 都沒過。於是，你狠下心想要打掉重來，卻發現你沒有事先備份修改前的 Code，也沒有作版本控制，於是你只能開始思考該把哪些新加上的 Code 刪掉...。當然，這只是一個情況非常簡單的例子，實際上還有更多理由可以說明為什麼版本控制對於專案開發來說是非常重要的事情，像是多人合作的時候，如果沒有適當地進行版本控制，一定會引發大災難。

此外，大家有沒有想過所謂程式碼的雲端硬碟？相信大家多多少少都聽過看過 Github 或是 Gitlab 這兩個網站，Git 作為常見的版控系統，基本上所有的版本控制資訊都是儲存在**本地端**，也就是我們常說的 Local Repository。大家如果在你的 Local Repo 資料夾底下輸入 `$ ls -a` 指令，應該會看到一個資料夾叫做 `.git`，這個資料夾底下就是 Git 用來紀錄目前專案的版本控制資訊的文件。因此，請大家務必不要隨便刪除 `.git` 這個資料夾，除非你有把你的 Repo 放到 Remote 端。

而所謂 Remoet Repository，就是當我們使用諸如 Github 或是 Gitlab 這類的線上版控服務時，我們把我們的 Local Repository 利用 `git push` 指令上傳到 Github 或是 Gitlab 上。以計算機組織這堂克來說，助教架設了這堂課斯有的 Gitlab 服務供同學使用，

## Basic Git Concepts

為了讓大家不要只是死記硬背 Git 的指令，而是真的理解 Git 的基本觀念，我們必須要理解 Working Directory、Staging Area、Local Repository 和 Remote Repository 這四個名詞分別代表什麼，以及他們彼此之間的關係。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/aa038345-166d-4288-9d91-3caa3145bc6b.png)

> 你可以想像你有一個倉庫，在倉庫門口有個小廣場，這個廣場的概念就像暫存區一樣，你把要存放到倉庫的貨物先放到這邊（`git add`，staging area），然後等收集的差不多了就可以打開倉庫門，把在廣場上的貨物送進倉庫裡（`git commit`，local repo），並且記錄下來這批貨是什麼用途的、誰送來的。
>
> --- 高見龍 - 為你自己學 Git

### When to commit?

> 基本上什麼時候 commit 都可以，你要把東西都完成才提交，或是一直不斷地提交都可以，但是有一套好的規則、習慣會比較好。==常見的 Commit 的時間點有==：
>
> 1. 完成一個「任務」的時候：不管是大到完成一整個電子商務的金流系統，還是小至只加了一個頁面甚至只是改幾個字，都算是「任務」。
> 2. 下班的時候：雖然可能還沒完全搞定任務，但至少先 Commit 今天的進度，除了備份之外，也讓公司知道你今天有在努力工作。（然後帶回家繼續苦命的做？）
> 3. 你想要 Commit 的時候就可以 Commit。
> 
> --- 高見龍 - 為你自己學 Git

### Local Repo? Remote Repo?

TBD

## Common Git Commands

- `git init`
- `git add`
- `git commit`
- `git status`
- `git remote`
- `git push`
- `git clone`
- `git checkout`
- `git branch`
- `git reset`
- `git rebase`
- `.gitignore` file
