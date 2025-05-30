!!! info
    - Contributors：TA 峻豪、TA 裕禾
    - Last updated：2024/09/22

---

GitLab 是程式碼託管與版本控制服務，用於實驗室或企業內部的程式碼管理與團隊協作，我們使用 Gitlab 作為課程作業的繳交區，但 Assignment Report 的部分仍需要於 Moodle 上繳交。  

為了使用 Gitlab ，需要熟悉基礎的 Git 指令，方便在 Gitlab 上進行作業專案上傳及更新

Mattermost 是搭配 Gitlab 使用的通訊軟體，本學期 Lab 討論區使用此線上群組（線上可以隨時發問），Mattermost 有網頁版，也可以下載app後登入。軟體預設通知設定應該是 only mentioned，若是想關注課程訊息，記得到設定區開啟通知。

## 如何繳交作業 & 作業批改方式

這學期批改作業的方式採用 Gitlab CI/CD Pipeline，助教會提供一個 YAML 檔案叫做 `.gitlab-ci.yml`（注意因為檔案名稱開頭的 `.` 所以會變成隱藏檔案）。
基本上大家可以把 CI/CD Pipeline 想像承自動化的腳本，只不過其執行結果會即時顯示在 Gitlab 上的你的 Repository 中。
**為了觸發 Pipeline，大家務必把這個 YAML 檔案放進自己的 Private Repo. 中。**
