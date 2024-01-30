# なでりー

「いいね」の代わりに「なで」るSNS

すごいことはなでて褒めて、悲しいことはなでて慰める

そんな感じです

## 開発言語とバージョン

- Ruby 2.6.3-p62 (x86_64-linux)
- Rails 5.2.8.1

## 何ができるの？

なでりーは汎用SNSです。
特徴は「いいね」が「なで」であることと、タイムラインが複数作れることです。

なでりーでは、基本的に何かしらのタイムラインで投稿をします。

話したい内容に合わせて、タイムラインを切り替えて使います。

もの静かに暮らしたかったら、ホームで投稿することもできます。

現時点(v2024.01.30)でできることは以下の通り:

- タイムライン
  - 作成/編集/削除
  - 譲渡
- 投稿
  - タイムラインで
  - ホームで
  - 削除
- なで (いわゆる、いいね)
- フォロー
  - アカウントを
  - タイムラインを
- 通知
  - お知らせ
  - タイムラインの譲渡
- 検索

## なでりー運用に必要な設定

なでりーを運用する前に、管理者などを設定する必要があります。

### 管理者の設定

管理者はシステム用ユーザーとして、なでりーで使用されます。

**管理者ユーザーは１ユーザーのみに設定してください。(複数のユーザーを管理者にしないでください。)**

まず、通常のアカウントの作成と同じように、アカウントを作成します。

その後コンソール(`rails console`)で、そのユーザーを取得し、`is_administrator`を`true`に指定してください。

```
$ rails c
Running via Spring preloader in process XXXX
Loading X environment (Rails 5.2.8.1)
2.6.3 :001 > User.find_by(username: "XXXXXX").update(is_administrator: true)
```

**管理者ユーザーで、投稿、なで、フォローなどを行わないでください。**

### ホーム投稿用のタイムラインの設定

ホーム投稿用にタイムラインを１つ作成しておく必要があります。

**管理者ユーザーと同様、ホーム投稿用のタイムラインは１つのみにしてください。**

上記で作成した管理者ユーザーでログイン後、通常のタイムライン作成と同じように、タイムラインを作成します。

その後コンソール(`rails console`)で、そのタイムラインを取得し、`is_dummy`を`true`に指定してください。

```
$ rails c
Running via Spring preloader in process XXXX
Loading X environment (Rails 5.2.8.1)
2.6.3 :001 > Timeline.find_by(timelinename: "XXXXXX").update(is_dummy: true)
```

**ホーム投稿用のタイムラインは、管理者ユーザーであっても閲覧することはできません。**

編集などはURLから遷移してください。


上記の2つ設定を行うと、なでりーの機能を全て使えるようになります。

## 将来的に実装したいもの

- ミュート/ブロック
- 画像投稿
- 投稿のピン留め
- タイムラインからユーザーのブロック設定
- など
