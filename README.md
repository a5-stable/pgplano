# pgplano

PostgreSQL の `EXPLAIN ANALYZE` 出力をビジュアライズするツールです。

## 概要

`EXPLAIN ANALYZE` の出力をブラウザ上でツリー形式で表示します。  
バックエンドは Ruby（Rack）、フロントエンドは Ruby WASM と D3.js を使用しています。

## 技術スタック

- **バックエンド**: Ruby / Rack
- **フロントエンド**: Ruby WASM / D3.js
- **データベース（開発用）**: PostgreSQL（Docker）

## セットアップ

### 必要要件

- Ruby
- Docker / Docker Compose（開発用データベースを使用する場合）

### インストール

```bash
bundle install
```

### サーバーの起動

```bash
bundle exec rackup
```

ブラウザで `http://localhost:9292` にアクセスしてください。

## 使い方

1. ブラウザで `http://localhost:9292` を開きます。
2. テキストエリアに `EXPLAIN ANALYZE` の出力を貼り付けます。
3. **Parse** ボタンをクリックすると、実行計画がツリー形式で表示されます。

### EXPLAIN ANALYZE の出力例

```
Hash Join  (cost=1.07..2.19 rows=5 width=72) (actual time=0.035..0.038 rows=5 loops=1)
   Hash Cond: (posts.user_id = users.id)
   ->  Seq Scan on posts  (cost=0.00..1.05 rows=5 width=36) (actual time=0.007..0.008 rows=5 loops=1)
   ->  Hash  (cost=1.04..1.04 rows=4 width=36) (actual time=0.015..0.015 rows=4 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on users  (cost=0.00..1.04 rows=4 width=36) (actual time=0.004..0.005 rows=4 loops=1)
```

## 開発用データベースのセットアップ

Docker を使って PostgreSQL を起動し、サンプルデータを投入できます。

```bash
# PostgreSQL コンテナの起動とシードデータの投入
bash test/setup.sh
```

起動後は以下の接続情報でアクセスできます。

| 項目 | 値 |
|------|------|
| ホスト | localhost |
| ポート | 5436 |
| ユーザー | postgres |
| パスワード | postgres |
| データベース | pgplano_development |

## プロジェクト構成

```
pgplano/
├── config.ru          # Rack アプリケーション設定
├── parser.rb          # EXPLAIN ANALYZE パーサー
├── plan.rb            # 実行計画モデル
├── nodes.rb           # ノードクラスのロード
├── nodes/             # 各ノードタイプの定義
├── scanners/          # 字句解析器
├── src/               # フロントエンド（Ruby WASM）
├── public/            # 静的ファイル（HTML / CSS / JS）
├── test/              # 開発用データベーステスト環境
├── util/              # ユーティリティ
└── docker-compose.yml # Docker Compose 設定
```
