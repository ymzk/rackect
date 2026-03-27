#!/bin/bash -e

racket -l racket -t effect-handler/basic.rkt    -f test/basic-test.rkt  -e "(main)"  | diff - test/basic-test.rkt.out
racket -l racket -t effect-handler/dynwin.rkt   -f test/basic-test.rkt  -e "(main)"  | diff - test/basic-test.rkt.out
racket -l racket -t effect-handler/dynwin-t.rkt -f test/basic-test.rkt  -e "(main)"  | diff - test/basic-test.rkt.out

racket -l racket -t effect-handler/basic.rkt    -f test/test-state.rkt  -e "(main)"  | diff - test/test-state.rkt.out
racket -l racket -t effect-handler/basic.rkt    -f test/test-par.rkt    -e "(main)"  | diff - test/test-par.rkt.out
racket -l racket -t effect-handler/basic.rkt    -f test/test-gen.rkt    -e "(main)"  | diff - test/test-gen.rkt.out
racket -l racket -t effect-handler/basic.rkt    -f test/test-parser.rkt -e "(main)"  | diff - test/test-parser.rkt.out
racket -l racket -t effect-handler/basic.rkt    -f test/test-jump.rkt   -e "(main)"  | diff - test/test-jump.rkt.out
racket -l racket -t effect-handler/basic.rkt    -f test/test-cont.rkt   -e "(main)"  | diff - test/test-cont.rkt.out
