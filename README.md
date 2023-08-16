# README

# アプリ名
 EstimaSphere
<br>
<br>

## アプリケーションの概要

EstimaSphereは社内の見積もりを一元管理するためのWebアプリケーションです。顧客情報や見積もりに関する情報をデータベースに保存し、見積もりの作成、更新、検索などを容易に行うことができます。
Estima(見積)Sphere(領域/範囲)を組み合わせた名前です。

<br>
<br>

# URL

#### Renderによるデプロイ
https://furima-39216.onrender.com/

#### Basic認証
- ID: admin
- Pass: 2222
<br>
<br>



# 使用しているバージョン等
- ruby 3.0.2
- Rails 7.0.6
- MySQL 5.7.42


<br>
<br>

# 実装機能

<br>

## 1. はじめに
本システムは、社内の見積もり管理を効率化し、見積もり作成作業の正確性と速度を向上させることを目的としています。

<br>

## 2. システム要件
2.1 顧客管理機能
顧客コードに基づいて顧客を検索できる。
顧客コードを入力すると、関連する会社名、部署名、担当者名が自動的に反映される。
<br>
2.2 見積もり作成機能
販売見積もりと仕入れ見積もりの2種類の見積もりを作成できる。
自動的に見積もり番号を生成できる。仕入見積の形式は「PYYYYMMDD-1」（YYYYは年、MMは月、DDは日、「-1」は連番）。
自動的に見積もり番号を生成できる。販売見積の形式は「SYYYYMMDD-1」（YYYYは年、MMは月、DDは日、「-1」は連番）。
<br>
2.3 見積もり詳細表示機能
見積もりの詳細情報を表示できる。
<br>
2.4 検索機能
見積もり番号、会社名、品名のいずれかまたは全てで見積もりを検索できる。
<br>
2.5 PDF作成機能
作成した見積もりをPDF形式で出力できる。
<br>
## 3. その他の要件
顧客コードがない場合にも対応する。
提出した見積に対して成否や、コメントを付けることができる。
<br>
<br>

# ER 図

![ER図(EstimaSphere)]

<br>
<br>

# テーブル設計

### users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| last_name          | string | null: false               |
| first_name         | string | null: false               |

#### Association

- has_many :sales_quotations
- has_many :purchase_quotations
- has_many :comments


### company_infos テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| company_name       | string | null: false               |
| postcode           | string | null: false               |
| address            | string | null: false               |
| phone_number       | string | null: false               |
| fax_number         | string | null: false               |

### customers テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| customer_code      | string | null: false, unique: true |
| customer_name      | string | null: false               |
| address            | string | null: false               |
| phone_number       | string | null: false               |

#### Association

- has_many :sales_quotations
- has_many :purchase_quotations
- has_many :representatives



### representatives テーブル

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| customer_id         | integer | null: false, foreign_key: true |
| department_name     | string  | null: false                    |
| representative_name | string  | null: false                    |
| phone_number        | string  | null: false                    |
| email               | string  | null: false, unique: true      |

- belongs_to :customer

### units テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| unit_name          | string | null: false, unique: true |

#### Association

- has_many :sales_quotation_items
- has_many :purchase_quotation_items

### categories テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| category_name      | string | null: false, unique: true |

#### Association

- has_many :sales_quotation_items
- has_many :purchase_quotation_items

### sales_quotations テーブル

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| customer_id         | integer | null: false, foreign_key: true |
| user_id             | integer | null: false, foreign_key: true |
| quotation_number    | string  | null: false, unique: true      |
| request_date        | data    | null: false                    |
| quotation_date      | data    | null: false                    |
| quotation_due_date  | data    | null: false                    |
| delivery_date       | data    | null: false                    |
| delivery_place      | string  |                                |
| trading_conditions  | string  |                                |

#### Association

- belongs_to :customer
- belongs_to :user
- has_many :sales_quotation_items
- has_many :comments


### sales_quotation_items テーブル（中間テーブル）

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| quotation_id        | integer | null: false, foreign_key: true |
| category            | String  | null: false                    |
| item_name           | string  | null: false                    |
| quantity            | integer | null: false                    |
| unit_id             | string  | null: false, foreign_key: true |
| unit_price          | integer | null: false                    |
| note                | string  |                                |

| result              | string  |                                |

#### Association

- belongs_to :sales_quotation
- belongs_to :unit


### purchase_quotations テーブル

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| customer_id         | integer | null: false, foreign_key: true |
| user_id             | integer | null: false, foreign_key: true |
| quotation_number    | string  | null: false, unique: true      |
| request_date        | data    | null: false                    |
| quotation_date      | data    | null: false                    |
| quotation_due_date  | data    | null: false                    |
| delivery_date       | data    | null: false                    |
| handover_place      | string  |                                |
| trading_conditions  | string  |                                |


#### Association

- belongs_to :customer
- belongs_to :user
- has_many :purchase_quotation_items
- has_many :comments


### purchase_quotation_items テーブル（中間テーブル）

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| quotation_id        | integer | null: false, foreign_key: true |
| category            | String  | null: false                    |
| item_name           | string  | null: false                    |
| quantity            | integer | null: false                    |
| unit_id             | string  | null: false, foreign_key: true |
| unit_price          | integer | null: false                    |
| note                | string  |                                |
| result              | string  |                                |

#### Association

- belongs_to :purchase_quotation
- belongs_to :unit

### comments テーブル

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| user_id             | integer | null: false, foreign_key: true |
| quotation_id        | integer | null: false, foreign_key: true |
| comment             | text    | null: false                    |

#### Association

- belongs_to :user
- belongs_to :purchase_quotation
- belongs_to :sales_quotation