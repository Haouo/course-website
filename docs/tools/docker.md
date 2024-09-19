# :fontawesome-brands-docker:{ style="color: #1c90ed"} Docker tutorial

!!! info
    - Contributors:  
    - Last updated: 

往年修課需要使用遠端連線到實驗室伺服器才能編譯或執行程式，為了方便同學寫作業，今年改成利用Docker在自在自己的電腦端架設所需環境，此頁將介紹課程中關於Docker的使用教學。

---

## Preamble

今年因為我們計劃要開源這整套教材，所以在大家所使用的開發環境上勢必得做一些調整；往年有關於電路模擬（Simulation）的部分，我們通常都是讓大家使用實驗室提供的伺服器，並且使用伺服器上安裝的 Cadence XCELIUM (`xrun` command) 或是 Synopsys VCS 來進行模擬，而這兩套工具基本上都是需要 License 的，而且非常昂貴。也因此今年我們採用不一樣的模式，我們不再提供修課同學實驗室伺服器的帳號，取而代之的是我們利用 Docker 提供同學已經設計好的開發環境，在這裡指的就是 Docker Image。同學只需要在自己的電腦上安裝 Docker，即可使用我們提供的 Docker Image 進行開發，並且 Image 中已經包含所有同學寫 Lab 會需要用到的所有 Toolchain，不需要同學在環境上多花心力去折騰。

## Introduction to Docker

### What is Docker?

> 參考：[Docker 是什麼？Docker 基本觀念介紹與容器和虛擬機的比較](https://www.omniwaresoft.com.tw/product-news/docker-news/docker-introduction/)

Docker 是容器化技術（Containerization）的一種實作，而容器化又是一種輕量級的虛擬化技術，常常和容器化拿來對比的就是虛擬機（Virtual Machine, VM）技術。我們可以參考下面這張圖

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/a31684fa-7fa2-4422-ae57-2c9203eacf20.png)

基本上 Docker 的出現讓環境的部屬變得容易很多，試想大家今天在自己的電腦上開發應用程式的時候，你會有自己的開發環境和執行環境；但是，今天如果你要把你寫的 App 開放給別人，讓別人在他們電腦上執行的時候，可能就會出現問題，因為你和別人的電腦的開發環境和執行環境不一定是完全相同的，譬如你們所使用的 Python 版本或是 Java JDK 的版本不同，這時候 Docker 就可以派上用場。利用 Docker，你可以將你的應用程式，連同執行環境打包成一個 Docker Image，別人就可以利用你提供的 Docker Image 來建立一個 Container，就可以在這個 Container 中去執行你開發的應用程式，並且避開環境問題。

簡單來說，配置環境和開發應用程式的人只需要撰寫 *Dockerfile*，就可以把這個 Dockerfile 給別人，讓別人來 build image；或甚至可以直接提供已經 build 好的 Docker Image 給別人使用。

雖然 Docker 的使用場景比較常見於和應用程式配套的環境配置，但其實我們也可以透過 Docker 來實現類似虛擬機器的功能，也就是利用 Docker 配置一個屬於我們自己的 Linux 開發環境並且安裝我們所需的工具鏈，在裡面開發程式，就像是直接在我們電腦上安裝 Linux 作業系統的感覺一樣。以計算機組織這堂課來說，助教正是利用 Docker 配置了一個同學寫作業所需的 Linux 開發環境，使用的作業系統是 Ubuntu。

### Docker Image vs. Docker Container

助教覺得 Docker Image 和 Docker Container 的關係有點類似物件導向程式設計中，Class 之於 Object (Instance) 的關係。

## How to install Docker

首先，我們必須先在電腦上安裝 Docker Engine；為了簡化安裝過程，我們可以直接在電腦上安裝 [Docker Desktop](https://www.docker.com/products/docker-desktop/)，如果是使用 Mac 的話，助教推薦安裝 [OrbStack](https://orbstack.dev/)。

:::info
### Windows Subsystem For Linux (WSL)

> 參考：[如何使用 WSL 在 Windows 上安裝 Linux](https://learn.microsoft.com/zh-tw/windows/wsl/install)

如果想要在 Windows 上使用 Linux 操作系統的話，以往常常需要使用諸如 VirtualBox 之類的虛擬機軟體來安裝和配置虛擬機，但現在 Windows 上有一個內建功能叫做 WSL（目前已經到 WSL2），可以讓我們不用安裝虛擬機就可以很方便地配置 Linux 開發環境。如果你是使用 Windows 作業系統的話，助教推薦你可以安裝 WSL 這個功能，不論是作為日常開發環境或是拿來取代 MobaXterm 都非常好用。配套的終端機軟體助教推薦使用 *Windows Terminal*，而 Linux Distribution 助教推薦安裝 Ubuntu 22.04 或是 Ubuntu 24.04。至於字體的部分，助教推薦 JetBrainsMono Nerd Font。

#### How to install WSL2 on your Windows PC

1. 請先使用**系統管理員**身份開啟 PowerShell
2. 啟用 WSL 所需系統功能
    ```shell=
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    ```
3. 安裝並且更新 WSL，然後安裝 Linux Distribution `Ubuntu-24.04`
    ```shell=
    wsl --install --web-download
    wsl --update --web-download
    wsl --set-default-version 2
    wsl --install Ubuntu-24.04 --web-download
    ```
4. 完成 `Ubuntu-24.04` 的安裝之後，應該就會接著提示輸入你想要的 Username 和 Password，請輸入你自己想要的使用者名稱和密碼之後，就完成設定，即可開始使用 Windows Subsystem for Linux (WSL)
:::

### Install Docker Desktop on Windows

#### Installation Method

:::danger
請同學務必先安裝 WSL 之後再安裝 Docker Desktop，否則 Docker 會無法正常運作。
:::

> 參考：[在 WSL 2 上開始使用 Docker 遠端容器](https://learn.microsoft.com/zh-tw/windows/wsl/tutorials/wsl-containers)

在 Windows 上安裝 Docker 最快的方式是直接下載 Docker Desktop 並安裝。

安裝完 Docker Desktop 之後，你可以開啟剛剛安裝的 WSL 的 Ubuntu，然後輸入 `sudo docker run hello-world:latest` 看看是否可以成功執行 Docker。如果出現以下畫面，恭喜你 WSL 和 Docker 都順利安裝完成！

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/7482a2a8-01b4-4d91-85aa-bdfde95216c5.png)

#### Test X11 Forwarding

因為在後面的 Lab 我們會用到 GTKWave 這個 Waveform Viewer 來觀察電路的波形，而這個程式是一個 GUI App，所以我們必須確認我們的 WSL 可以正常執行 X11 Forwarding 的功能。

1. 首先，先安裝必要的 packages（==此步驟是在 Host 端操作，也就是 WSL，並非進入 Container 內操作==）
    ```shell=
    $ sudo apt update
    $ sudo apt install -y x11-utils x11-xserver-utils x11-apps
    ```
2. 接著輸入以下指令
    ```shell=
    $ xhost +local:docker
    $ xclock
    ```
3. 如果你有看到一個小視窗出現，代表 X11 功能正常運作！
    ![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/28367fa9-1f23-485b-9d49-3f99f2a2e170.png)
4. 請執行 `run.sh` 進入 container 之後，一樣執行 `xclock` 看看是否也有正常出現小時鐘視窗

### Install OrbStack on MacOS

請直接到 OrbStack 的官網下載然後安裝即可使用。使用 Mac 的人一樣可以開啟系統內建的 Terminal，然後輸入 `sudo docker run hello-world:latest` 看看是否可以成功執行。

MacOS 要使用 X11 Forwarding 的功能的話，請下載並安裝 [XQuartz](https://www.xquartz.org/)。欲使用 X11 Forwarding 時，請保持 XQuartz App 為開啟狀態，否則會導致視窗開啟失敗。

## How to use the course Docker Image

我們採用直接下載 Docker Image 的方式，而非使用 Dockerfile 來建構 Docker Image，原因是因為我們會用到 RISC-V GNU Toolchain，在建構 Image 的過程中會去下載該 Toolchain 的 repository，如果大家所在的環境的網路速度不理想的話，建構 image 的過程可能會耗費數小時以上，甚至會 build fail。為了下載助教提供的 image，我們需要使用 `docker pull` 指令。

詳細來說，因為我們還會使用到助教額外撰寫的 Shell Script，所以整個過程總共需要兩個步驟，分別是下載助教指令的 Reposiroty 和下載助教提供的 Docker Image。下載完之後，就可以執行腳本（`run.sh`）來啟動並且進入 container 中，以使用我們為課程設計的程式開發環境。接下來我們說明詳細的操作步驟：

1. 請先 Clone 這個 [Repository](https://gitlab.course.aislab.ee.ncku.edu.tw/113-1/docker-env)
    ```bash=
    $ git clone https://gitlab.course.aislab.ee.ncku.edu.tw/113-1/docker-env
    ```
2. 進入 docker-env 資料夾，接著登入我們的 Container Registry 之後，再 Pull 助教提供的 Docker Image
    ```bash=
    $ sudo docker login registry.course.aislab.ee.ncku.edu.tw # 請輸入你登入 Gitlab 所使用的帳號、密碼
    $ sudo docker pull registry.course.aislab.ee.ncku.edu.tw/113-1/docker-env/co2024-docker
    ```
3. 幫我們的 Container 建立 Docker Volume
    ```bash=
    $ sudo docker volume create co2024_volume
    ```
4. 執行 `run.sh` 後即可進入 Container 內部，便可以開始使用課程所需的開發環境
    ```bash=
    ./run.sh
    ```

進入 Container 之後，你可以輸入 `id` 命令來查看自己的 Username、UID 和 GID，你應該會看到自己的 Username 是 `co2024`，而 UID 和 GID 都是 `1234`。除此之外，當你要使用 sudo 命令的時候，會提示需要輸入密碼，而密碼也是 `1234`。

### Docker Volume & Workspace

最後，我們需要討論 Docker 對於管理檔案的特性。當你使用某個 Docker Image 去開啟一個 Container 的時候，Docker 會在這個 Container 的最上層加上一層可寫層（Writable Layer）。你對這個 Container 最的所有更改都會被紀錄在可寫層當中，被 Docker 暫存起來。但是，今天一旦這個 Container 被刪除的話，你做的所有更改就會被刪除，當你下次再用相同 Image 開啟 Container 的時候，一切就會恢復原狀，彷彿你從未做過任何操作一樣。但這樣對我們來說就會有一個很大的問題，因為我們將這個 Docker Container 作為我們開發程式的環境，也就代表我們有儲存程式碼的需求，需要持久性（Persistent）的儲存，最好不要因為 Container 被刪除就跟著不見。因此，我們會需要使用到一個東西，叫做 **Docker Volume**。

![](https://hedgedoc.course.aislab.ee.ncku.edu.tw/uploads/954e66b8-161c-476a-aad8-f31755a62248.png)

Docker Volume 又分成兩種模式，分別是 Bind Mount 和 Volume。Bind Mount 就像是卦載硬碟的概念，或是當你使用虛擬機如 VirtualBox 的時候，把電腦本地端的某個 Path 卦載到虛擬機上，讓虛擬機內部也可以看到本地端的資料夾，藉此在本地端和虛擬機之間儲存和傳輸檔案。Volume 的話這邊就不贅述，大家有興趣的話可以去看 Docker 官方的文件。

在這堂課中，我們會使用 Bind Mount 的方式，首先先在 `docker-env` 資料夾底下建立一個新的資料夾 `workspace`，然後把他 卦載到 container 上，這樣當我們進入 container 之後，就可以把我們的程式碼放在 `workspace` 底下，即使我們離開 container 後，程式碼也不會不見，達到持久性的儲存。
