# KaomojiParser

KaomojiParser is a Swift Package to deal with texts that contain Japanese kaomoji. KaomojiParser supports removing kaomoji from texts and extracting kaomoji from texts.  

Implementation notes are available at [Qiita(Japanese)](https://qiita.com/ensan_hcl/items/ffa57c175aa5046cc7d6).

## Kaomoji structure
This project aims to search kaomoji in texts. There are various kaomoji, and whether a character is contained in kaomoji or not is not obvious.

> ホームランｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎

This is one of popular kaomoji, but the range of kaomoji depends on the definition. Perhaps there are three candidates: 

1. `(ﾟ∀ﾟ)` is kaomoji, and `ホームランｷﾀ━━━━━━━━‼︎` is the main text.
1. `ｷﾀ━━━━(ﾟ∀ﾟ)━━━━` is kaomoji, and `ホームラン!!` is the main text.
1. `ｷﾀ━━━━(ﾟ∀ﾟ)━━━━!!` is kaomoji, and `ホームラン` is the main text.

At first, this project uses the third way to parse texts. Maybe first and second ways can be added in the future.

## Reference

This implementation relys on this paper. Thanks to the authors.
* 風間一洋, 水木栄, & 榊剛史. (2016). Twitter における顔文字を用いた感情分析の検討. In 人工知能学会全国大会論文集 第 30 回全国大会 (2016) (pp. 3H3OS17a4-3H3OS17a4). 一般社団法人 人工知能学会.

