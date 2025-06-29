# Proxmox VM Infrastructure with Terraform

## 概要

このプロジェクトは、[Terraform](https://www.terraform.io/) を使用して [Proxmox VE](https://www.proxmox.com/en/proxmox-ve) 上に仮想マシン（VM）群を自動でプロビジョニングするためのものです。

Kubernetesクラスタ（コントロールプレーン1台、ワーカー2台）、PostgreSQLサーバー、NFSサーバーといった、一般的なWebアプリケーション基盤を想定した構成をコードで定義し、再現性の高い環境を迅速に構築することを目的とします。

## アーキテクチャ

このTerraformコードによって、以下の仮想マシンがProxmox上に展開されます。

* **仮想化基盤**: Proxmox VE
* **プロビジョニングツール**: Terraform + bpg/proxmox Provider

### 作成される仮想マシン

| 用途                       | 台数 | 想定構成                                 |
| -------------------------- | ---- | ---------------------------------------- |
| Kubernetes Control Plane   | 1台  | k3s, kubeadm等でクラスタを管理するノード |
| Kubernetes Worker Node     | 2台  | コンテナアプリケーションを実行するノード |
| PostgreSQL Server          | 1台  | データベースサーバー                     |
| NFS Server                 | 1台  | 永続ボリュームを提供するストレージサーバー |

## 特徴

* **Infrastructure as Code (IaC)**: インフラ構成をコードで管理することで、バージョン管理、レビュー、再利用が可能になります。
* **再現性**: 手作業による設定ミスを排除し、いつでも同じ構成の環境を構築できます。
* **カスタマイズ性**: `terraform.tfvars` ファイルを編集するだけで、VMのスペック（CPU, メモリ, ディスク）やIPアドレスを簡単に変更できます。
* **自動化**: Cloud-Init連携により、VM作成時にホスト名、ネットワーク、SSHキーなどの初期設定を自動で行います。

## 前提条件

このプロジェクトを利用するには、以下の準備が必要です。

1.  **Terraform**: `v1.5.0` 以上がインストールされていること。
    ```bash
    # バージョン確認
    terraform --version
    ```
2.  **Proxmox VE 環境**: Proxmoxサーバーが稼働しており、ネットワークに接続されていること。
3.  **Proxmox APIトークン**: TerraformがProxmoxを操作するためのAPIトークン。
    * Proxmox UIの `データセンター > パーミッション > APIトークン` から作成します。
    * 作成した **Token ID** と **Secret** を控えておいてください。
4.  **VMテンプレート**: Cloud-Initに対応したVMテンプレートがProxmox上に存在すること。
    * Ubuntu Server 22.04 LTSなどのCloudイメージから作成することを推奨します。
    * テンプレートには `qemu-guest-agent` をインストールしておくと安定性が向上します。
    * テンプレート名は `terraform.tfvars` で指定します。

## セットアップ

1.  **リポジトリのクローン**:
    ```bash
    git clone <this-repository-url>
    cd proxmox-infra
    ```

2.  **設定ファイルの準備**:
    `terraform.tfvars.example` ファイルを `terraform.tfvars` という名前でコピーします。
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```

3.  **変数の設定**:
    コピーして作成した `terraform.tfvars` ファイルをエディタで開き、ご自身の環境に合わせて値を設定してください。

    ```hcl
    # Proxmox API Credentials
    proxmox_url                = "[https://192.168.1.100:8006/api2/json](https://192.168.1.100:8006/api2/json)"
    proxmox_api_token_id     = "terraform@pve!my-token"
    proxmox_api_token_secret = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    # Network Configuration
    network_gateway = "192.168.1.1"

    # SSH Public Key for VM access
    ssh_public_key = "ssh-rsa AAAA..."

    # Virtual Machine Definitions
    vms = {
      # ... VMごとの設定 ...
    }
    ```
    > **セキュリティ警告**: `terraform.tfvars` にはAPIトークンなどの機密情報が含まれます。このファイルは`.gitignore`に含まれていますが、絶対にバージョン管理システムにコミットしないでください。

## 使用方法

### 1. 初期化

Terraformプロバイダをダウンロードするため、最初に以下のコマンドを実行します。

```bash
terraform init
```

### 2. 実行計画の確認

どのようなインフラが作成・変更されるかを確認します。意図しない変更が含まれていないか、ここで必ず確認してください。

```bash
terraform plan
```

### 3. インフラの構築

計画に問題がなければ、以下のコマンドで実際にVMを作成します。

```bash
terraform apply
```
実行の途中で確認を求められたら `yes` と入力します。

### 4. インフラの破棄

作成したリソースが不要になった場合は、以下のコマンドで全て削除できます。

```bash
terraform destroy
```

## ディレクトリ構成

```
.
├── main.tf              # メインのVMリソース定義
├── variables.tf         # 変数の定義
├── outputs.tf           # 出力値の定義
├── versions.tf          # プロバイダとTerraformのバージョン指定
├── terraform.tfvars.example  # 変数設定ファイルのサンプル
└── README.md            # このファイル
```