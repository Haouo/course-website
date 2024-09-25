# Basic Linux command

!!! info
    - Contributors：TA 裕禾、TA 峻豪  
    - Last Updated：2024/09/22

---

!!! success
    Directory : It's a file system concept, like 'folder' in Windows. In computing, a directory is a file system cataloging structure which contains references to other computer files, and possibly other directories.

## Basic Linux Concepts

為了流暢使用 Linux 作為你的開發環境，你至少需要知道下面幾個觀念

- **當前路徑**
    - 輸入指令 `pwd` 可以得到當前的絕對路徑
- **移動目錄 (相對路徑與絕對路徑)**
    - 絕對路徑 - 皆由根目錄為起點，輸入指令 `cd + 絕對路徑` 可以前進到目標目錄
    - 相對路徑 - 子目錄與父目錄，該目錄上一層的目錄為父目錄，下一層的為子目錄
    - 舉例來說，若當前目錄路徑為 `/c/Users/user/example_dir`
        - 前進父目錄 - `cd ..` -> 進入 `c/Users/user`
        - 前進子目錄 - `cd CO2024/lab0` -> 進入 `c/Users/user/example_dir/CO2024/lab0`
` 
- **查看上一個 Command 的 Return Value**
    - 基本上你在 CLI 中輸入的每個命令都應該要有他的 Return Value；但是，當你執行完某個命令的時候，他的回傳值並不會直接顯示在畫面上，所以你必須使用特定的命令來查看這個回傳值
    - `echo $?`
- **I/O Redirection**（I/O 重定向） & **Pipe**（管道）
    在 Unix 系統中，重定向和管道的出現體現了 Unix 哲學中的幾個核心理念，特別是「小而專注的工具」和「將工具鏈接在一起」。
    - Unix 哲學
        Unix 的設計理念是創建一系列小而專注的程序，每個程序完成特定的任務。這些程序可以被組合使用，形成更複雜的功能。這樣的設計促進了靈活性和可重用性。
    - I/O Redirection
        I/O 重定向允許使用者將輸入和輸出從預設的來源或目的地轉向其他地方。這符合 Unix 的理念，因為它讓單一命令能夠以不同的方式工作。使用者可以輕鬆地將輸出寫入文件、從文件中讀取輸入，或將錯誤信息單獨處理。例如：
        ```bash
        echo "Hello, World!" > output.txt
        ```
        這條命令不僅簡化了輸出處理，還使得日誌記錄變得容易，強調了工具的靈活性。
        ```bash
        echo "Hello, World!" >> output.txt
        ```
        雙箭頭 `>>` 代表的是附加在檔案尾端，而不是覆寫（Override）。
    - Pipe
        管道則進一步體現了 Unix 的哲學，允許將多個小工具串聯在一起，讓它們協同工作。使用管道，使用者可以將一個命令的輸出直接傳遞給另一個命令，形成數據處理的流水線。例如：
        ```bash
        ls -l | grep "txt" | sort
        ```
        這條命令串聯了三個工具，依次執行：列出文件、過濾包含 "txt" 的行、然後排序結果。這種方法不僅提高了效率，還使得命令的組合變得靈活，強調了「**組合小工具以完成複雜任務**」的理念。

## Common Linux Commands

- `pwd` - 顯示當前工作目錄
- `cd` - 使用相對路徑或絕對路徑切換目錄
- `mv` - move, 移動或重新命名檔案或目錄
- `ls` - list, 顯示當前目錄的子目錄及檔案。
    - 語法：`ls [OPTIONS] [FILES]`
    - 常用options：`-a`(顯示隱藏檔案), `-l`(顯示詳細資訊)
- `mkdir` - 創建一個新的目錄。
    - 語法：`mkdir [OPTIONS] DIRECTORY`
    - 範例：`mkdir new_folder`
- `touch`：建立空檔案或更新檔案的修改時間。
    - 語法：`touch [OPTIONS] FILE`
    - 範例：`touch newfile.txt`
- `cp`：複製檔案或目錄。
    - 語法：`cp [OPTIONS] SOURCE DEST`
    - 範例：`cp file1.txt /backup/`
- `rm`：刪除檔案或目錄。
    - 語法：`rm [OPTIONS] FILES`
    - 範例：`rm lab0.c`、`rm -r directory_name`(`-r` - 刪除目錄底下的子目錄與檔案)
- `rmdir`：刪除空目錄。
    - 語法：rmdir [OPTIONS] DIRECTORY
    - 範例：rmdir empty_folder
- `man`：查看命令的手冊。
    - 語法：man COMMAND
    - 範例：man ls
- `grep`：搜尋文本中的字串。
    - 語法：grep [OPTIONS] PATTERN [FILE...]
    - 範例：grep "search_term" file.txt
- `find`：在檔案系統中搜尋檔案。
    - 語法：find [PATH] [OPTIONS] [EXPRESSION]
    - 範例：find /home/user -name "*.txt"
- `cat`：顯示檔案內容或將多個檔案串接。
    - 語法：cat [OPTIONS] [FILE...]
    - 範例：cat file1.txt file2.txt
- `echo`：顯示文字或變數的值。
