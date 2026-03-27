
# racket-eff: effect handler implementation in Racket
--------

### How to run:

テストコードを実行
```bash
$ racket -l racket -t eff.rkt -f state.rkt -f state-main.rkt -e "(main)"
```

または対話モードに入る
```bash
$ racket -l racket -t eff.rkt -f state.rkt -f state-main.rkt -i
```

エフェクトハンドラそのものの定義を提供する .rkt ファイル (eff.rkt、dynwin.rkt、dynwin-t.rkt) はモジュールになっている。
-t、--require、`(require "<file>")` などの方法でロードする。
どの .rkt ファイルをロードしても同じインターフェースが提供される。

エフェクトを定義する .rkt ファイル (state.rkt、par.rkt、parser.rkt、gen.rkt、jump.rkt、cont.rkt) は、異なるエフェクトハンドラの実装と組み合わせて実行できるようにモジュールにはなっていない。
エフェクトハンドラをロードした後、-f、--load、`(load "<file>)` などの方法でロードする。
-l で言語を指定しないとエラーになる。

それぞれのエフェクトにはテストコードが付属する (state-main.rkt、par-main.rkt、parser-main.rkt、gen-main.rkt、jump-main.rkt、cont-main.rkt)。
これらのファイルは main-1、main-2、main-3 と連番が振られたエントリポイント群と、それらを順にすべて呼び出す main を提供する。
これらのファイルもモジュールではなく、エフェクトハンドラと対応するエフェクトの定義をロードしてからテストコードをロードする。
これらのテストコードはエントリポイント群を提供するだけで自動的には呼び出さないことに注意されたい。
テストコードの期待される出力は .rkt.out ファイルに格納されている。


## Interface of effect handlers

次の４つのファイルはそれぞれ effect handler を提供する。
* eff.rkt
* dynwin.rkt
* dynwin-t.rkt

これらの effect handler は、共通して次のプリミティブを提供する。

* (define-effect id (fields ...))

effect constructor を宣言する。
effect constructor は struct の宣言とほぼ等価で、フィールドアクセサやパターンマッチのパターンが自動的に生成される。


* (with-effect-handler H body ...)

body 内で perform された effect を、ハンドラ H でハンドルする。ハンドラ H がハンドルshなかった effect はより外側へと伝搬する。


* (handler [name] handler-clause ...)
* (define-handler id handler-clause ...)
    ~> (define id (handler id handler-clause ...))

ハンドラオブジェクトを作成する。ハンドラは第一級市民で、変数に束縛したり、関数の引数に渡したりしてから with-effect-handler に渡すことができる。
第一引数でハンドラの名前を指定するが、省略してもよい。省略すると anonymous-handler という名前になる。

handler-clause は、次のうちどちらかである
  - [(return x) expr ...]
    return handler。with-effect-handler が body の終わりに達し、正常終了した場合にだけ expr ... が実行される。return handler の中から送出した effect はより外側のハンドラに伝搬する。自身では捕捉できない。
  - [(effect (C fields ...) k) expr ...]
    effect handler。with-effect-handler の中で送出された effect が (C fields ...) にマッチするなら expr ... が実行される。k に指定した変数には effect を送出した perform 以降の継続を表す関数が束縛される。この継続は後述する continue によって呼び出す。

dynwin.rkt または dynwin-t.rkt で定義された effect handler では、handler-clause として次の２種類も書くことができる。
  - [(on-enter) expr ...]
  - [(on-exit) expr ...]
    with-effect-handler の内側に侵入するたびに (on-enter) に指定した expr ... が、脱出するたびに (on-exit) に指定した expr ... が実行される。正常終了による脱出でも (on-exit) は実行されるが、エフェクトの送出でも (on-exit) が実行される。(on-enter) と (on-exit) が何度実行されるのかは予想が難しいため、これらには対になる操作を指定することが期待される。


* (handler-name H)

ハンドラオブジェクトの名前を取り出す。


* (perform e)

effect を送出する。
e は define-effect によって宣言された effect constructor によって作られたオブジェクト。


* (continue k v)

v を引数に継続 k を呼び出す。v の評価値が継続 k の呼び出しによって戻る先の perform 式の評価値になる。


具体例については各 effect の定義を参照のこと。
