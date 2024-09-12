# How To Ask Questions The Smart Way

!!! info
    <!-- - Video link : <a href="https://youtube.com/" target="_blank">CO2024 Fall lab1 video</a> -->
    - Contributors : TA 峻豪
    - Deadline : ==2024/09/20==

??? tip "updates information"
    update 240911: 新增此頁面
    update 240912: 完成此頁面內容

## Preamble

首先，非常歡迎各位同學選修蔡家齊教授開設在大學部的計算機組織課程，今年的內容相較於去年會變得更加豐富，雖然去年的難度其實已經非常高，但今年並非把 Lab 變得更難，而是在不超綱的前提之下，盡量教給同學越多的知識（畢竟成大電機所目前沒有開設計算機結構 QQ），讓同學對整個計算機系統本身有更充分的了解。有鑒於助教去年教學的經驗，助教發現大部分的學生並不知道如何『正確地提問』，許多人往往無法精確地表達自己的問題，以至於助教常常必須花更多時間了解同學的問題到底是什麼，才能給出正確的答覆。因此，今年特別多了 Lab 0，希望可以讓同學有所收穫。

Lab 0 大部分的內容參考自文章：[How To Ask Questions The Smart Way](https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way) 和 [北京大學 編譯實踐線上文件](https://pku-minic.github.io/online-doc/#/preface/facing-problems)，助教擷取當中助教認為比較重要的部分，同學若有興趣也可以自行閱讀全文。

## 面對問題的態度

在做實驗和寫作業的過程中，你可能會常常遇到下面的問題

1. 不清楚某個 Toolchain 的用法
2. 不知道怎麼實作某個 Function
3. 看不懂 Compiling/Linking Time 出現的警告或是錯誤訊息
4. 對 Runtime Error 毫無頭緒
5. 就算程式或是電路可以正常運作，但是結果和你所想的相去甚遠
6. 其他各式各樣的問題...

與其說遇到問題是一件很正常的事情，不如說...你如果在過程中都沒遇到問題的話，你反而該懷疑一下自己（？

助教希望同學們在做 Lab 的過程中，不要懷抱著以下的心態

1. 出問題的時候隨便改改自己的程式碼，反正能跑出預期的結果、能過 Test-bench 就好，對問題發生的原因和來由一無所知
2. 遇到問題馬上想著抱大腿，求助厲害的同學或是助教，而沒有**自己嘗試**理解問題
3. 用毫無意義的方式提出問題，例如：
    - 為什麼我的程式沒辦法通過編譯？
    - 為什麼我沒辦法通過測資？
4. 即使你上網嘗試尋找 solution，但你對網路上的內容**全盤相信**，完全沒有自我思辨和過濾內容的能力，看到許多劣質的內容，甚至錯誤的資訊都渾然不知（對 ChatGPT 來說也是，你不該覺得 ChatGPT 講的就是聖旨，甚至還覺得我都照做了怎麼還是不行...）

取而代之的是，你應該要

1. 不要放過任何**理解問題**的機會
2. **獨立思考**的能力
3. 不要害怕嘗試解決問題，不要害怕遇到錯誤，你會在過程中學到超多東西
4. **STFW** (Search The F… Fantastic Web), **RTFM** (Read The Fantastic Manual), **RTFSC** (Read The Fantastic Source Code)
5. Try to search your problems by using english instead of chinese，嘗試使用英文搜尋專業問題，你會發現另一片天
6. **嘗試閱讀第一手文件**（e.g., 規格書），而不是過度依賴所謂的「教學」或是「懶人包」

## 在你提問之前

在你準備向助教或是其他同學提問之前，請先問問你自己你是否已經做到了下面這些事情：

1. 你 Google 過了嗎？你知道你該搜尋那些關鍵字嗎？
2. 你問過 ChatGPT 了嗎？
3. 你仔細看過你的 Source Code 了嗎？你仔細看過 Error Message 了嗎？
4. 你嘗試過把 Error Message 中的關鍵字丟到搜尋引擎裡面了嗎？
5. 你試圖分析過原因了嗎？你理解整個問題的脈絡了嗎？

## 關於 Large Language Model (LLM)

這個部分是助教今年特別加進來的，因應目前大型語言模型相關的服務（e.g, ChatGPT, ClaudeAI, LLAMA, Google Gemini, Github Copilot）的能力越來越強，助教也希望大家可以善用 GPT 而不是排斥、完全不使用 GPT。但是，在去年的教學經驗中，助教發現有些人不只是使用 GPT，而是把 GPT 當成 Problem Solver 來使用。助教曾經遇到有同學問助教：「助教，我已經照著 ChatGPT 的指示操作了，為什麼還是不行？」，助教反而才想反問同學，為什麼你會覺得 ChatGPT 說的方式是正確的？你確定它懂你在問什麼嗎？你確定你自己懂它在說什麼嗎？

在助教的觀點中，LLM 確實可以幫我們解決很多問題、可以正確地回答越來越多複雜的問題，但是，助教會希望同學們吧 LLM 當成是你的私人顧問，也就是 Consultant，你可以向它提問，和它討論甚至是糾正它，但請不要預設它說的話是對的。如果你有這種心態的話，那你真的很有可能會被 AI 取代。

## How To Ask Questions?

根據助教的經驗，大部分的同學問問題的方式會像是下面這樣

> 助教，為什麼 XXX 跑不起來？為什麼 XXX 編譯會失敗？

同學很崩潰，助教聽到同學的問題也崩潰了...助教哪會知道為什麼啊？？

請大家不要再用這種方式問問題了，這類的問題對你我來說都沒有任何價值。舉例來說，有人可能會問助教：「RISC-V Assembly 如果寫 `addi x0, x0,x0` 是合法的嗎？」，這種問題與其花時間問別人，你不如自己試試看，把它丟給 Compiler 去編譯，讓 Compiler 幫你檢查就好。

助教希望同學可以

1. **提問前先好好思考**，自己是否可以做一些嘗試（Attempt）來解決這個問題
2. **學習正確提問的方式**，閱讀 [How To Ask Questions The Smart Way](https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way) 或 [Stop Ask Questions The Stupid Way](https://github.com/tangx/Stop-Ask-Questions-The-Stupid-Ways/blob/master/README.md)

如果你還是不知道怎麼提問，請參考以下模板

> 我的編譯器在輸入為 XXX 的時候出現了 YYY 問題（附完整的錯誤信息或截圖）。\
> 我嘗試 AAA，發現 BBB，我認為這代表 CCC。\
> 我還嘗試 DDD，發現 EEE，我認為這代表 FFF。\
> 綜上所述，我覺得問題可能出在 GGG，但之後我就沒有思路了，請問我的分析是否正確？問題的具體原因是什麼呢？

## 助教不會回答 & 協助的問題

1. 和課程無關的問題
2. 任何不經過思考就提出的問題
3. 可以通過你自己 debug 解決的問題
4. 能在 Document 裡面找到的問題