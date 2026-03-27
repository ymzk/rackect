
#lang racket

(require racket/control)



;; effect declaration
(define-syntax-rule (define-effect id fields)
  (struct id fields #:transparent))



;; internal data structures
;; * wrappers for user-accessible objects
(struct handler-object (name h) #:transparent)
(struct cont (k) #:transparent)

;; * internal data structure 
(struct msg-return (value) #:transparent)
(struct msg-perform (e k) #:transparent)

;; * patterns for handler declarations
(struct return (value) #:transparent)
(struct effect (e k) #:transparent)
(struct on-enter () #:transparent)
(struct on-exit () #:transparent)

;; * special constant
(struct UNHANDLED ())
(define UNH (UNHANDLED))



;; effect handler implementation
(define (with-effect-handler-impl H body)
  (match-let ([(handler-object _ h) H])
    (h (on-enter))
    (let loop ([msg (reset0 (msg-return (body)))])
      (match msg
        [(msg-return v)
          (h (on-exit))
          (match (h (return v))
            [(UNHANDLED) v]
            [v~ v~])]
        [(msg-perform e k)
          (h (on-exit))
          (let ([k~ (lambda (x) (h (on-enter)) (let ([msg (reset0 (k x))]) (loop msg)))])
            (match (h (effect e (cont k~)))
              [(UNHANDLED)
                (shift0 k~~
                  (msg-perform e (compose k~~ k~)))]
              [v~ v~]))]))))

(define-syntax-rule (with-effect-handler H body ...)
  (with-effect-handler-impl H (lambda () body ...)))



;; primitive operators -- handler/perform/continue
(define-syntax handler
  (syntax-rules ()
    [(_ [pat body ...] ...)
      (handler-object (gensym 'noname) (match-lambda [pat body ...] ... [_ UNH]))]
    [(_ name [pat body ...] ...)
      (handler-object (gensym 'name) (match-lambda [pat body ...] ... [_ UNH]))]))

(define (perform e)
  (shift0 k (msg-perform e k)))

(define (continue k v)
  ((cont-k k) v))


(define-syntax-rule (define-handler id clauses ...)
  (define id (handler id clauses ...)))


(provide
  define-effect
  with-effect-handler
  handler
  perform
  continue
  define-handler
  (rename-out [handler-object-name handler-name])
  (struct-out return)
  (struct-out effect)
  (struct-out on-enter)
  (struct-out on-exit))
