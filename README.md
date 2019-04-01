# th-dic-skk

[東方Project辞書](http://9lab.jp/works/dic/th-dic.php) for SKK

## 概要

東方Project辞書をSKKで扱えるよう変換した辞書です。また、変換用のRubyスクリプトも添付しています。

## 辞書ファイル

辞書ファイルは`dist`以下に含まれています。内容は以下の通りです。

* `SKK-JISYO.th-character.<format>` : キャラクター名辞書
* `SKK-JISYO.th-music.<format>` : 曲名辞書
* `SKK-JISYO.th-product.<format>` : 作品名辞書
* `SKK-JISYO.th-spellcard.<format>` : スペルカード辞書
* `SKK-JISYO.th-term.<format>` : 用語辞書
* `SKK-JISYO.th.<format>` : 上記の辞書を結合した辞書

`<format>`はannotationの取り扱いの違いで付けられています。これは東方Project辞書の注釈に`/`が含まれており、エスケープ処理が必要なためです。内容は以下の通りです。

* `lisp` : `/`が含まれる場合に`(concat "...\057...")`の形式に変換
* `aquaskk` : `/`を`,`に変換（候補では`[2f]`でエスケープ出来るようですが、annotationでは出来ないようです）
* `unannotated` : 全てのannotationを取り除く

SKKの各実装での対応状況については[SKK辞書の闇への対応状況 - みずぴー日記](http://mzp.hatenablog.com/entry/2016/05/02/101923)が詳しいです。DDSKKやCorvusSKKでは`lisp`、AquaSKKでは`aquaskk`で問題無いと思います。

辞書のエンコーディングはUTF-8です。

東方Project辞書には見出し語にかなと英字が含まれるものがありますが、SKKでは扱えないため除外しています。また、@変換辞書についても除外しています。

## 変換プログラム

`bin/convert`で東方Project辞書のGoogle日本語入力用辞書を変換可能です。実行にはRubyが必要です。

    Usage: bin/convert [options] [file]
            --[no-]annotation
            --escape FORMAT

現状では対応していない品詞があるため、辞書のバージョンによっては正常に動作しない可能性があります。

また、プロジェクト直下に`th-dic-r7-google.zip`をダウンロードした後に`rake`で一括変換が可能です。実行にはRubyの他に`unzip`、`skkdic-expr2`が必要です。

## ライセンス

東方Project辞書に倣い、[Unlicense](http://unlicense.org/)とします。

## 謝辞

東方Project辞書の作者のきゅー氏にこの場を借りてお礼申し上げます。
