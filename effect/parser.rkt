
(load "effect/state.rkt")
(load "effect/par.rkt")
(require racket/stxparam)

(define-syntax-parameter it (lambda (stx)
  (raise-syntax-error #f "undefined" stx)))

(define (->list obj)
  (cond
    [(list? obj) obj]
    [(stream? obj) (stream->list obj)]
    [(string? obj) (string->list obj)]
    [else (error (format "failure in converting to list: ~S" obj))]))

(define-syntax-rule (run-parser src body ...)
  (let ([src~ (->list src)])
    (run-par (run-state src~ (let ([ret (begin body ...)]) (list ret (get)))))))

(define (read-any-char)
  (match (get)
    [(cons ch src~) (put src~) ch]
    [_ (cancel)]))

(define (read-satisfy pred)
  (let ([ch (read-any-char)])
    (if (pred ch) ch (cancel))))

(define-syntax-rule (read-if pred ...)
  (read-satisfy (lambda (ch) (syntax-parameterize ([it (make-rename-transformer #'ch)]) pred ...))))

(define (read-char ch)
  (read-if (equal? it ch)))

(define (read-string str)
  (map read-char (->list str)))

(define (alt-l options)
  ((choose-from options)))

(define (alt-f . options)
  (alt-l options))

(define-syntax-rule (alt option ...)
  (alt-f (lambda () option) ...))

(define (many-f p)
  (alt (many1-f p) null))

(define (many1-f p)
  (cons (p) (many-f p)))

(define-syntax-rule (many body ...)
  (many-f (lambda () body ...)))

(define-syntax-rule (many1 body ...)
  (many1-f (lambda () body ...)))

(define (follows-f p)
  (let* ([src (get)]
         [ret (p)])
    (put src)
    ret))

(define (not-follows-f p)
  (let* ([src (get)]
         [res (run-parser src (p))])
    (if (null? res) null (cancel))))

(define-syntax-rule (follows body ...)
  (follows-f (lambda () body ...)))

(define-syntax-rule (not-follows body ...)
  (not-follows-f (lambda () body ...)))
