# Jupyter Notebook for *Literate Computing for Reproducible Infrastructure* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/yacchin1205/Jupyter-LC_docker/codt2020-demo)

Cloud Operator Days Tokyo 2020向けのデモ環境です。
このデモ環境ではJupyterのインタフェースを使って、運用作業の一例としてのログ分析や、我々のチームがLC4RIの実践のために開発している各種Extensionを使ってみるといった体験ができます。

# 使用方法

このデモ環境を使用する方法としては、以下の2種類があります。

## Binderサービスを使用する

[Binder](https://mybinder.readthedocs.io/en/latest/)サービスを使用すると、手元に計算環境がなくても、この環境を試すことができます。
以下のURLにアクセスしてください。

https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/yacchin1205/Jupyter-LC_docker/codt2020-demo
<img src="./sample-notebooks/images/demo.png" align="right" width="25%" />

なお、この環境ではNotebookを自由に作成、編集することができますが、Notebookに対する変更等は、 **保存されません** 。この環境は[Binder](https://mybinder.readthedocs.io/en/latest/)サービスの上でデプロイされており、一定時間が経過すると自動的に削除されます。編集したNotebookなどの情報は失われますのでご注意ください。

## Dockerを使用する

手元にDocker環境がある場合は、以下のコマンドでデモ環境を利用することができます。

```
$ docker run -d -p 8888:8888 --name codt2020 yacchin1205/notebook:codt2020-demo
```

特にエラーなどが表示されなければ、ブラウザで http://localhost:8888 を開きます。PasswordかTokenと求められますので、

```
$ docker logs codt2020
```

で、 `http://127.0.0.1:8888/?token=(トークン)` という出力が得られるはずですので、このトークンを入力します。
コンテナを停止・削除したい場合は、

```
$ docker stop codt2020
$ docker rm codt2020
```

としてください。詳しくは、Dockerコマンドラインのドキュメントを参照してください。

> <span style='background-color:mistyrose;'> **デモ環境を体験するに際して、 [Binder](https://mybinder.readthedocs.io/en/latest/) および [Scrapbox](https://scrapbox.io/product/) の利用規約は各自で確認ください。** </span>

<span style='background-color:mistyrose;'> 質問等、お問い合わせは、Facebookページ https://www.facebook.com/groups/792904597583420/ に参加申請ください！</span>

# デモとして提供するNotebook

## Notebookの実行方法

このデモ環境では、Notebookという形式で、実際に自身で実行可能な運用作業の例が保存されています。

[00_デモ環境の利用方法](sample-notebooks/00_デモ環境の利用方法.ipynb)を参考に、実際に実行をしてみてください。

## Literate Computingの運用への適用例

運用への適用例の一つとして、ログを分析する手順を記述したNotebookを体感いただけます。

* [01_Literate_Computingの運用への適用例](sample-notebooks/01_Literate_Computingの運用への適用例.ipynb)


## NII謹製Literate Computing機能拡張
Jupyterはもともとデータ分析用途に開発されたツールであるため、インフラの運用に適用するためにいくつかの機能拡張を施しています。以下は、その内容をご紹介するNotebookです。

* [02_NII謹製_Jupyterの機能拡張について](sample-notebooks/02_NII謹製_Jupyterの機能拡張について.ipynb)


## Notebookを介したコミュニケーション

Jupyterで行った経験を効率的に共有するためにいくつかの機能拡張を施しています。以下は、その内容をご紹介するNotebookです。

* [03_Notebookを介したコミュニケーション](sample-notebooks/03_Notebookを介したコミュニケーション.ipynb)

## Notebookの検索

Jupyterで実施したNotebookを効率的に検索するための機能拡張を施しています。以下は、その内容をご紹介するNotebookです。

* [04_Notebookの検索](sample-notebooks/04_Notebookの検索.ipynb)

## OperationHub

Jupyter Notebookを用いた運用手順を複数人で効果的に共有・管理するために、JupyterHubを拡張したOperationHubを提供しています。
以下は、OperationHubをAWSアカウント内に構築し、試用するためのNotebookです。

> AWSへのアカウント登録が必要です。また、仮想マシン等の維持には一定の料金がかかります。ご自身の責任でお試しください。

* [05_OperationHubをAWSに構築](sample-notebooks/05_OperationHubをAWSに構築.ipynb)
