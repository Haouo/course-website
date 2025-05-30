!!! info
    - Contributors：TA 裕禾
    - Last Update：2024/09/22

---

**原文連結: [Markdown語法大全](https://hackmd.io/@eMP9zQQ0Qt6I8Uqp2Vqy6w/SyiOheL5N/%2FBVqowKshRH246Q7UDyodFA?type=book)**

> 有些Markdown的語法沒辦法用在這裡，可以在這頁進行對照

!!! tip "Example tip block"
    example.
    12345

```
!!! tip "Example tip block"
    example.
    12345
```

!!! note "Example note block"
    example.
    12345

!!! info "Example info block"
    example.
    12345

!!! danger "Example danger block"
    example.
    12345

!!! warning "Example warning block"
    example.
    12345


MarkDown語法大全
===

[Toc]

@copyright MRcoding筆記

---

主標題
===
>標題的語法

```
標題
===
```

---

副標
---
>副標的語法

```
副標
---
```

---

字體大小
---
>字體大小的示範
># H1
>## H2
>### H3
>#### H4
>##### H5


```
# H1
## H2
### H3
#### H4
##### H5
```

---

字體效果
---
*斜體字*
**粗體字**
***斜粗體***
~~刪除線~~
_斜體2_
__斜粗2__
正常^上標^
正常~下標~
++底線++
==螢光標記==

```
*斜體字*
**粗體字**
***斜體兼粗體***
~~刪除線~~
_斜體2_
__斜粗2__
正常^上標^
正常~下標~
++底線++
==螢光標記==
```

---

引文
---
>縮排語法
>第一層
>>第二層
>>>第三層

```
>縮排語法
>第一層
>>第二層
>>>第三層
```

---

標號
---
1. 數字標號
2. 數字標號
3. 數字標號
- 其他標號
+ 其他標號
* 其他標號

```
1. 數字標號
2. 數字標號
3. 數字標號
- 其他標號
+ 其他標號
* 其他標號
```

---

縮排+換行
---

    
    縮排
換行  

```MD
[Tab]縮排
行末按兩個空格  産生斷行 (．↲)。
```

---

巢狀標號
---

- 無序清單
- 無序清單
    - 無序清單子清單
        - 無序清單子子清單

1. 有序清單
2. 有序清單
    1. 有序清單子清單
        1. 有序清單子子清單

```MD
- 無序清單
- 無序清單
    - 無序清單子清單
        - 無序清單子子清單

1. 有序清單
2. 有序清單
    1. 有序清單子清單
        1. 有序清單子子清單
```

---

定義清單
---

名詞1
: 解釋1

名字2
: 解釋2

名詞 3
~ 定義 3
~ 定義 3

```
名詞1
: 解釋1

名字2
: 解釋2

名詞 3
~ 定義 3
~ 定義 3
```

連結
---
>[連結名稱](https://google.com "游標顯示")

```
[連結名稱](https://google.com "游標顯示")
```

---

簡易超連結
---
><https://google.com>
><text@email.com>

```md
<網址或mail>
```

---

分隔線
---
1.

---
2.
***
3.
- - -
4.
* * *

```
1.
空行
---
2.
***
3.
- - -
4.
* * *
---
```

程式碼
---
```cpp
#include <stdio.h>

int main(){

    printf("Hello World");

    return 0;
}
```
```cpp=
#include <stdio.h>

int main(){

    printf("Hello World");

    return 0;
}
```


\```程式類型
程式碼
\```

\```程式類型=
行號+程式碼
\```

---

標籤連結
---
[Google][1]
[Yahoo][2]
[MSN][3].

  [1]: http://google.com/        "游標顯示"
  [2]: http://search.yahoo.com/  "游標顯示"
  [3]: http://search.msn.com/    "游標顯示"
```
[Google][1]
[Yahoo][2]
[MSN][3]

  [1]: http://google.com/        "游標顯示"
  [2]: http://search.yahoo.com/  "游標顯示"
  [3]: http://search.msn.com/    "游標顯示"
```

---

圖片
---
![圖片](https://i1.wp.com/mrcodingroom.freesite.host/wp-content/uploads/2019/01/Drawing.png "哈")

```md
![圖片名稱](連結 "游標顯示")
```

---

圖片連結
---
[![圖片](https://i1.wp.com/mrcodingroom.freesite.host/wp-content/uploads/2019/01/Drawing.png)](https://mrcodingroom.freesite.host/)

```md
[![圖片](圖片網址)](連結網址)
```

---

表格
---
| 欄位1 | 欄位2 | 欄位3 |
| :-- | --: |:--:|
| 置左  | 置右 | 置中 |
| $100 | $100 | $100 |
| $10 | $10  | $10 |
| $1  | $1  | $1 |

```
| 欄位1 | 欄位2 | 欄位3 |
| :-- | --: |:--:|
| 置左  | 置右 | 置中 |
```

---

短區塊
---
>`內容`

\`內容`

---

CheckBox
---
> - [ ] uncheck
> - [x] check

```md
 - [ ] uncheck
 - [x] check
```



---

跳脫字元
---
\##
\```

```md
\+任意符號
```

###### tags: `MarkDown教學` `HackMD新手教學`


