# LC4RI: *Literate Computing for Reproducible Infrastructure* デモ環境

Literate Computing for Reproducible Infrastructureは、インフラ運用の場面において"機械的に再現できる、人が読み解ける手順"を作成・利用していくことで、運用作業の信頼性向上、手順やノウハウの蓄積・流通をはかっていこうという考え方です。

## デモ環境の利用方法

このデモ環境ではJupyterのインタフェースを使って、運用作業の一例としてログ分析や、LC4RIの実践のために開発している各種Extensionを使ってみるといったことを体験することができます。

なお、この環境ではNotebookを自由に作成、編集することができますが、サーバにはこれらのNotebookは永続的に**保存されません**。この環境は[Binder](https://mybinder.readthedocs.io/en/latest/)サービスの上でデプロイされており、一定時間が経過すると自動的に削除されます。編集したNotebookなどの情報は失われますのでご注意ください。



## Notebookの実行方法

このデモ環境では、Notebookという形式で、実際に自身で実行可能な運用作業の例が保存されています。

[00_デモ環境の利用方法](00_デモ環境の利用方法.ipynb)を参考に、実際に実行をしてみてください。


## Literate Computingの運用への適用例

運用への適用例の一つとして、ログの分析ダッシュボードを体感いただけるNotebookです。

* [01_Literate_Computingの運用への適用例](01_Literate_Computingの運用への適用例.ipynb)


## NII謹製Literate Computing機能拡張
Jupyterはもともとデータ分析用途に開発されたツールであるため、インフラの運用に適用するためにいくつかの機能拡張を施しています。以下は、その内容をご紹介するNotebookです。

* [02_NII謹製_Jupyterの機能拡張について](02_NII謹製_Jupyterの機能拡張について.ipynb)
