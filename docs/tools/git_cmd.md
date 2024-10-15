!!! info
    - Contributors：TA 明堡、TA 峻豪 
    - Last updated：2024/09/25

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
> [name=高見龍 - 為你自己學 Git]

### When to commit?

> 基本上什麼時候 commit 都可以，你要把東西都完成才提交，或是一直不斷地提交都可以，但是有一套好的規則、習慣會比較好。==常見的 Commit 的時間點有==：
>
> 1. 完成一個「任務」的時候：不管是大到完成一整個電子商務的金流系統，還是小至只加了一個頁面甚至只是改幾個字，都算是「任務」。
> 2. 下班的時候：雖然可能還沒完全搞定任務，但至少先 Commit 今天的進度，除了備份之外，也讓公司知道你今天有在努力工作。（然後帶回家繼續苦命的做？）
> 3. 你想要 Commit 的時候就可以 Commit。
> 
> [name=高見龍 - 為你自己學 Git]

### Local Repo? Remote Repo?

> 可以把 Remote Repository 想像成 Local Repository 的雲端硬碟就好。<br>
> --- TA 峻豪

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

### `git init`
`git init` 用來初始化一個 Git repository。在指定的資料夾中執行後，會在該資料夾內建立一個 `.git` 資料夾，這是 Git 用來儲存版本控制的資訊。資料夾中檔案的變動都可以被追蹤。

```bash
$ git init
```
當指令執行後，應該會出現類似這樣的訊息：
```
Initialized empty Git repository in /Your/Repository/Path/.git/
```

### `git add`
`git add` 是將指定的檔案加入 Git 的暫存區，代表檔案已經被標記為將被提交到版本控制中（這時還在Staging Area）。可以選擇加入特定檔案或所有檔案。
1. 加入單一檔案：
```bash
$ git add HelloWorld.c
```

2. 加入資料夾中所有檔案：
```bash
$ git add .
```

**這個指令執行後，不會有輸出**，但檔案已經加入到暫存區，等待 `git commit` 進行提交。

### `git commit`
`git commit` 用來提交暫存區中已經加入的檔案。每個 commit 都是一個版本的快照，需要由使用者提交commit message來描述這次的變更。Commit完畢可以決定是否要push到remote，或是繼續編輯。

範例1 : 初始化檔案時，可以寫Initial commit作為commit message。
```bash
$ git commit -m "Initial commit"
```
執行後顯示：
```
[master (root-commit) 67e0e74] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 HelloWorld.c
```
這表示成功提交，並生成了一個 commit ID（如 `67e0e74`）。

!!! success
    - 補充:
        - 寫清楚的Commit Message，能快速且正確地找到想要的版本，因此鼓勵大家培養好的Git Commit Style。
    - 可以遵循以下的格式
        ```
        <type>(<scope>): <subject>

        <body>

        <footer>
        ```
        - `<type>`: 用來描述這次提交的類型
            - feat: 新功能
            - fix: 修復 Bug
            - docs: 文件變更
            - test: 增加測試
        - `<scope>`: (選寫)描述這次提交影響的範圍或模組
        - `<subject>`: 提交的簡短但明確的描述，描述本次變更做了什麼，盡量不超過 50 個字元。
        - `<body>`: (選寫)更詳細的變更描述，解釋變更的原因、背景或影響。
        - `<footer>`: (選寫) 關於Breaking Changes（讓舊版程式無法正常運作的更新） 等補充訊息。
    - **Summary**<br>
        可以在作業中寫`<type>`和`<subject>`作為練習即可。
        e.g. ```$ git commit -m "feat: add fibonacci function for instruction Fibo"``` 表示新增一個寫費波納契數列的函式。

        如果想寫更詳細可以打```git commit```直接進入文字編輯器打詳細訊息。

### `git status`
`git status` 用來檢查目前的 repository 狀態，能顯示哪些檔案已經加入暫存區，哪些檔案還未被追蹤，或者有哪些變更未被提交。

```bash
$ git status
```
當沒有變更時：
```bash
On branch master
nothing to commit, working tree clean
```
如果有未追蹤的檔案：
```bash
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        new_prog.txt
nothing added to commit but untracked files present (use "git add" to track)
```
如果檔案發生更改
```bash
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   HelloWorld.c

no changes added to commit (use "git add" and/or "git commit -a")
```

### `git remote`
`git remote` 用來管理遠端 repository，`git remote add` 可以將遠端 repository 加入到本地，並取名為 `origin`。可以用來設定和顯示遠端 repository 的 URL。

1. 新增遠端 repository：
```bash
$ git remote add origin https://gitlab.course.aislab.ee.ncku.edu.tw/貼上自己repo
```
網址可以在repository的`程式碼`按鈕點選
![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/15082f1e-d8d0-4bb9-8074-02d93d5e8d3e.png)

2. 檢查遠端 repository：
```bash
$ git remote -v
```
顯示：
```
origin  https://gitlab.course.aislab.ee.ncku.edu.tw/ta/project0.git (fetch)
origin  https://gitlab.course.aislab.ee.ncku.edu.tw/ta/project0.git (push)
```

### `git push`
`git push` 用來將本地的變更推送到遠端 repository。可以指定將變更推送到哪個遠端分支，例如 `origin` 的 `master` 分支。

```bash
$ git push origin master
```
接著請輸入自己的Username和Password
```bash
Username for 'https://gitlab.course.aislab.ee.ncku.edu.tw': 
Password for 'https://UserName@gitlab.course.aislab.ee.ncku.edu.tw'
```

### `git clone`
`git clone` 用來從遠端 repository 複製到本地，包含所有檔案和 commit 紀錄。執行後會創建一個與遠端 repository 相同的本地副本。

```bash
$ git clone https://github.com/TA/project0.git
```
執行後顯示：
```
Cloning into 'prog0'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
Receiving objects: 100% (3/3), done.
```

### `git checkout`
`git checkout` 用來切換分支或指定的 commit ID，讓工作目錄變成該版本的狀態。可以檢視指定的 commit 或切換到其他分支。

1. 切換到指定 commit：
```bash
$ git checkout f041daf7a896afd27199f2c8bd6ee55cd3654113
```
這會讓 Git 進入 "detached HEAD" 狀態，允許檢視該版本，但不影響任何分支。

2. 回到最新的 `master` 分支：
```bash
$ git checkout master
```

### `git branch`
`git branch` 用來顯示目前存在的分支，並標註目前所在的分支。還可以用來創建或切換分支。

1. 顯示目前的分支：
```bash
$ git branch
* master
```

2. 新建一個分支：
```bash
$ git branch new-feature
```

3. 切換到新建的分支：
```bash
$ git checkout new-feature
```

### `.gitignore`
當你的專案有許多冗餘的檔案時，`.gitignore` 檔案用來告訴 Git 忽略某些不需要追蹤的檔案或目錄。可以將不必要追蹤的檔案模式寫入 `.gitignore` 檔案。

例如: 在.gitignore寫入
```
# Object files
*.o
*.elf

# Executables
*.exe
*.out
*.hex

# Logs
*.log
```
Git 便會忽略掉程式編譯過程中的中間檔以及執行檔。

```bash
$ git add .gitignore
$ git commit -m "Add .gitignore"
```
執行後顯示：
```
[master 8f8e123] Add .gitignore
 1 file changed, 1 insertion(+)
 create mode 100644 .gitignore
```
這樣所有 `.log` 檔案都會被 Git 忽略。
