# アプリケーション名
EstimaSphere

<br>

## アプリケーション概要
EstimaSphereは、ビジネスの見積プロセスを効率化し、正確さを向上させるためのアプリケーションです。<br>
PCでアプリケーションを使用することを想定して開発を進めました。
ユーザーは簡単に見積を作成、再見積、追跡でき、クライアントとのコミュニケーションもスムーズに行えます。<br>
Estima(見積)Sphere(領域/範囲)を組み合わせた名前です。

<br>


## URL
https://estimasphere.onrender.com

<br>

## テスト用アカウント	

- Basic認証ID ：admin  
- Basic認証パスワード ：2222  
- メールアドレス :red.123@mzk.com
- パスワード :abcd1234
<br>


## 利用方法

### 見積作成機能
***

1.トップページから販売/仕入見積作成をクリックし、見積作成ページへ移動<br>
2.見積作成の必須項目(顧客名・見積依頼日・見積作成日・見積有効期限・カテゴリ・品名・数量・単位・単価)を入力<br>
任意で備考・納入日・取引条件・部署-担当者を入力し、作成ボタンを押す<br>
3.見積詳細ページへ遷移するので、"PDFをダウンロード"ボタンを押すと作成した見積書をPDF形式でダウンロードできる。<br>

<br>

### 再見積機能

***

1.既存の見積の詳細ページから、"再見積"ボタンを押すと、編集ページに移動<br>
2.必要な項目を編集の上、作成を押すと新規見積として作成することができる<br>
3.その際、見積番号は新規の番号が割り当てられる<br>

<br>

## アプリケーションを作成した背景


現職での、見積の管理はExcelベースで、ExcelVBAを用いて作成しています。<br>
ですが、Excelの弱点として、"誰かが開いていると使用できない"，"誤って数式や関数を壊してしまう"などの悩みがありました。<br>
そういった課題を解決するために、社内向けの見積管理アプリケーションを作成しようと思いました。<br>

<br>

## 洗い出した要件


https://docs.google.com/spreadsheets/d/1KH8jTvII3dGyH9HfbrC_hj9XMQGc_bzCZjA0wFs1ACs/edit?usp=sharing





## 実装した機能についての画像やGIFおよびその説明



1.トップページ
***
 [![Image from Gyazo](https://i.gyazo.com/e2d17454f2b5c784cda093da9023881c.png)](https://gyazo.com/e2d17454f2b5c784cda093da9023881c)

2.基本情報登録機能
***
[![Image from Gyazo](https://i.gyazo.com/c45486bb39868f9d44c56548231eb2c8.png)](https://gyazo.com/c45486bb39868f9d44c56548231eb2c8)

- 自社情報の登録・編集
 [![Image from Gyazo](https://i.gyazo.com/6dedfd3e56ef44b2f7f05553af9c20e3.png)](https://gyazo.com/6dedfd3e56ef44b2f7f05553af9c20e3)

- 見積カテゴリーの登録
    任意で使用するカテゴリーを自由に登録することができる。
 [![Image from Gyazo](https://i.gyazo.com/1f25973c5a3e0b96541910c4369b1fe9.png)](https://gyazo.com/1f25973c5a3e0b96541910c4369b1fe9)
 
- 単位登録
 任意で使用する単位(㎡や棹など)を登録することができる。
 [![Image from Gyazo](https://i.gyazo.com/1d2f998158a4d240e7ddd50fb03b39a6.png)](https://gyazo.com/1d2f998158a4d240e7ddd50fb03b39a6)


3.顧客情報登録機能

***

- 顧客の基本情報(社名・住所・電話番号)と担当者情報(部署・名前・メールアドレス・電話番号)を登録できる。
 [![Image from Gyazo](https://i.gyazo.com/2c0d46ece6f53ef47e155196be292fd0.gif)](https://gyazo.com/2c0d46ece6f53ef47e155196be292fd0)
 
- 顧客を一覧表示で確認することができる。
- 顧客の詳細を確認することができる。
- 案件ごとに同じ会社でも、担当部署や担当者が変わる場合もあるため、担当者の追加機能。
- 社名の変更や移転なども想定し、顧客情報の編集機能。

4.販売/仕入見積作成機能

***

- 必須項目を入力し、見積を作成することができる。

- 見積のアイテム項目は20点まで同時に見積可能。
- 自動生成で見積番号を付与。<br>
 仕入見積の形式は「PYYYYMMDD-001」（YYYYは年、MMは月、DDは日、「-001」は連番）。<br>
 販売見積の形式は「SYYYYMMDD-001」（YYYYは年、MMは月、DDは日、「-001」は連番）。<br>
- 作成した見積書はPDF形式でダウンロードできる。

[![Image from Gyazo](https://i.gyazo.com/f26822242875748b68d994c2da2f6538.gif)](https://gyazo.com/f26822242875748b68d994c2da2f6538)

5.再見積機能

- 既存の見積から再見積を行うことができる。
- 見積番号は都度、新規で付与される。
- 元データの上書きは行われない。
- 作成後、PDFでダウンロードできる。

[![Image from Gyazo](https://i.gyazo.com/3a07c2f196290eee1c394fecabde0f90.gif)](https://gyazo.com/3a07c2f196290eee1c394fecabde0f90)

6.テスト実行結果

- user
[![Image from Gyazo](https://i.gyazo.com/3ea9cddc25d4e3b9b2b030c317e174af.png)](https://gyazo.com/3ea9cddc25d4e3b9b2b030c317e174af)

- sales_quotation
[![Image from Gyazo](https://i.gyazo.com/70a9eb24dfbbecf7d0d018f4f8817e31.png)](https://gyazo.com/70a9eb24dfbbecf7d0d018f4f8817e31)

- purchase_quotation
[![Image from Gyazo](https://i.gyazo.com/856210fd2a4bcff3b069b63041daf22a.png)](https://gyazo.com/856210fd2a4bcff3b069b63041daf22a)

## 実装予定の機能	

- 見積の成否機能を実装中。

- 見積に対するコメント機能を実装予定。

- 見積作成時の顧客の選択をあいまい検索から絞り込みを行い、プルダウンリストにする機能を実装予定。


## データベース設計

***

[![Image from Gyazo](https://i.gyazo.com/f835679f0683d02d9c097f1881bc49ce.png)](https://gyazo.com/f835679f0683d02d9c097f1881bc49ce)

## 画面遷移図

***

[![Image from Gyazo](https://i.gyazo.com/f3c9769c5d4ccbba80aeb1989c8846b2.png)](https://gyazo.com/f3c9769c5d4ccbba80aeb1989c8846b2)


## 開発環境


### フロントエンド
***
- HTML

- CSS

- Bootstrap 4.5.0

### バックエンド
***
- ruby 3.0.2

- Rails 7.0.6

- JavaSript

### インフラ

***

- MySQL 5.7.42

### テキストエディタ

***

- VSCode


### タスク管理

***

- GitHub

### テスト

***
- RSPEC



## ローカルでの動作方法

***
以下のコマンドを順に実行。

% git clone https://github.com/MIZUKI-TAKAHASHI0127/estimasphere.git<br>
% cd ~/estimasphere<br>
% bundle install<br>
% yarn install<br>


## 工夫したポイント

***

- 再見積機能で"既存の見積を上書きしないで新規見積として作成"という点に力を入れました。<br>
 現職では、お客様より「再見積してほしい」といった要望をよく頂きます。<br>
 作成した見積を上書きできてしまうと、お客様と自社で保存している見積が見積番号は一緒なのに内容が違う、<br>
 といったトラブルも起きかねないと考えたからです。<br>
 ですので、再見積の際は新規で見積番号を割り当てるように作成しました。<br>

- 直感的に操作できるユーザーインターフェースを意識して作成しました。<br>
 作成した私が「わかりやすい！操作しやすい！」と思うのは当たり前だと思います。<br>
 そこで、パソコンにあまり慣れていない方が操作しやすいか、どうかといった点に目を付けました。<br>
 夫をはじめ、妹や母にも操作を依頼しヒアリングしました。<br>
 概ね、「操作しやすいし、わかりやすい」という意見でしたが、夫は「わかりやすいけど、少しダサい」という意見でした。<br>
 ですので、洗練されたレイアウトと直感的に操作できるユーザーインターフェースを両立させることが課題だと思っております。<br>


## テーブル設計

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
| result              | string  |                                |

#### Association

- belongs_to :customer
- belongs_to :user
- has_many :sales_quotation_items
- has_many :comments


### sales_quotation_items テーブル（中間テーブル）

| Column              | Type    | Options                        |
| ------------------- | ------- | ------------------------------ |
| sales_quotation_id  | integer | null: false, foreign_key: true |
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
- belongs_to :category


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
| result              | string  |                                |

#### Association

- belongs_to :customer
- belongs_to :user
- has_many :purchase_quotation_items
- has_many :comments


### purchase_quotation_items テーブル（中間テーブル）

| Column                | Type    | Options                        |
| --------------------- | ------- | ------------------------------ |
| purchase_quotation_id | integer | null: false, foreign_key: true |
| category              | String  | null: false                    |
| item_name             | string  | null: false                    |
| quantity              | integer | null: false                    |
| unit_id               | string  | null: false, foreign_key: true |
| unit_price            | integer | null: false                    |
| note                  | string  |                                |
| result                | string  |                                |

#### Association

- belongs_to :purchase_quotation
- belongs_to :unit
- belongs_to :category

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