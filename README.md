引用ツイートをやめてもらうためのBOT
====

## 概要
先日、とある炎上案件に同情めいたコメントをしたらTwitterが炎上した。  
その後数日間、クソリプおじさんや俺の意見おじさんの引用ツイートがうるさかったのでつくったBOTです。  
炎上済みのツイートを引用ツイートをするとBOTからクソリプが飛んできます。  
ちなみに使用したところ、件のおじさんたちの怒りを買い、ますます炎上することまったなしでした。    
おすすめしません！

## 使い方
		$ bundle install --path vendor/bundle
		$ bundle exec ruby main.rb

HerokuにあげるときのためのダミーアプリとしてSinatraを入れています。   
HerokuではHeroku Schedulerで``ruby main.rb``を定期実行させてください。

## クソコード by
[ikeay](https://github.com/ikeay)
