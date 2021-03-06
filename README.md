# Lunchpack
[![CircleCI](https://circleci.com/gh/esminc/lunchpack.svg?style=shield)](https://circleci.com/gh/esminc/lunchpack)
## エレベーターピッチ
Lunchpack（ランチパック）というサービスは、

アジャイル事業部の制度の一つであるランチ給付金制度について、利用者とランチ給付金を使えるメンバーを調べるのが面倒なことを解決したい

アジャイル事業部メンバー向けの、

ランチ給付金制度の便利ツールです。

ユーザーはメンバーの名前の一覧から、自分とランチ給付金を使えるメンバーがひと目でわかる。

また、メンバーの名前一覧からひとり選ぶとさらに利用できる人を絞り込むことができ、

利用実績のスプレッドシートを確認することとは違って、

ひと目で利用者とランチ給付金を使える、使えないメンバーがわかることが備わっている事が特徴です。

## ランチ給付金制度について
「ランチ給付金制度」は永和システムマネジメントのアジャイル事業部にあるうれしい制度の一つです。

プロジェクトが異なる３人組でランチに行く場合、ひとり1500円まで支援してくれる制度です。
ただし、すでに行った人とはリセットされるまで無効になります。

※ 3人中ひとりだけ入れ替わる組み合わせのパターンはNG

![](https://i.imgur.com/y2UaBAx.png)

## テスト
```
$ bin/rspec
```

## ローカルでの立ち上げ方
```
$ bin/rails s
```

## ER図を生成
先に`$ brew install graphviz`でGraphvizをインストールしておく。
```
$ bin/rake erd

# UML形式で表示（エラーは無視していい）
$ bin/rake erd notation=uml
```
デフォルトでは`erd.pdf`が生成されます。詳しくは[voormedia/rails-erd](https://github.com/voormedia/rails-erd)を参照。

ちなみに、Rails6で動作するようにしているので、`bundle exec erd`では正しく生成されません。
