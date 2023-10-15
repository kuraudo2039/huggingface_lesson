hugging face pipeline のチュートリアル用に使ってみた NLP の各タスク用事前学習モデルの感触をメモっておく。

# 全体

エンコード系（感情分析、固有表現抽出、質問応答 等）は予測出力とそのスコアが出るので、スコアに閾値を設定して、精度の高いものを抽出して最終的な出力を選ぶ感じ。  
全体的に、用途に分けてファインチューニングの必要性を感じる。

基本的に、翻訳、テキスト生成 以外のタスクはあんまり更新が活発ではないイメージ。

# 感情分析

## model: デフォルト

英語で hello world! と fuck you! を試してみたら、score 0.9 以上で POSITIVE と NEGATIVE が判定された。日本語はﾜｶﾗﾝがそのままでも使えそう。

# 固有表現認識（抽出？）

## model: Mizuiro-sakura/luke-japanese-base-finetuned-ner

luke-japanese-base というモデルに、ストックマーク社による Wikipedia を用いたデータセット（stockmarkteam/ner-wikipedia-dataset）を用いてファインチューニングしたもの

wiki を使っているのもあり、適当な wiki の文を入れたらイイ感じに NER(named entity recognition)してくれた。  
例）国際〇〇協会 > 〇〇系組織 〇〇 > 人名

# 質問応答

## model: deepset/roberta-base-squad2

roBERTa-base モデルに、スタンフォード質疑応答データセット（SQuAD2.0） というウィキペディアの記事＋記事に対する質問応答によって事前学習されたモデル

twitter の文章を元に使ってみたが、ある程度質問を具体的にすればこのままでも使えそうだった。  
例）〇〇は何周年？、〇〇の役職は？　等で正しい回答が score 0.8 以上で出力される。

# 要約

## model: csebuetnlp/mT5_multilingual_XLSum

mT5 というチェックポイントに、XLSum という、BBC の記事 135 万件＋専門的注釈をつけたマルチリンガルデータセットで事前学習されたモデル

走れメロスを要約してみたけど、よくわからない文字列が出力される。生成モデル系はそのまま自然言語のみの出力が出るので、根気よく分析しながら使う必要がありそう。  
トークン数が多すぎ多のかもしれない。

# 翻訳

## model: facebook/mbart-large-50-many-to-many-mmt  
2023/9 更新

mBART-large-50 というチェックポイントを facebook がファインチューニングしたモデル

youtube の一節を入力したら、大量の Thank が出力されたり、Hello が出力されたり...。そもそも何か設定が違いそう。あとテキスト生成系は同じ単語を何度も出力されやすいので、されないように上限が設定されてるとか設定できるとか聞いたことがあるので、それ系を設定する必要があったのかもしれない。 m
いずれにせよ、ハイパーパラメータの調整やファインチューニングは必須そう。

# テキスト生成

## model: stabilityai/japanese-stablelm-instruct-alpha-7b-v2

StabilityAI 社が提供している、70 億パラメータの日本語用モデル  
japanese-stablelm-instruct-alpha-7b-v2NeoX というトランスフォーマーアーキテクチャに基づくんだそう。元は GPT-NeoX


## model: rinna/japanese-gpt-neox-3.6b

rinna社が提供している、EleutherAI/gpt-nexoを日本語でファインチューニングしたモデル。  
日本語コーパス：  
- CC-100(facebookのwebクロールコーパス) https://data.statmt.org/cc-100/ 
- mc4(Common Crawl のWebクロールコーパス) https://huggingface.co/datasets/mc4
- 日本語wiki https://dumps.wikimedia.org/other/cirrussearch/

生成された文章で、序盤は自然っぽい文章だったがこちらもループに入った。  
ループしないような設定や工夫はやはり必要そう。  

