(use ncurses posix srfi-1 s)
(include "usage-display.scm")
(include "conf.scm")
(include "abbr.scm")

(define x 0)
(define y 0)
(define curr-word "")
(define word-history '())

(define (add-to-word-history)
  (when
      (not
       (let ((t #t))
         (for-each (lambda(g) (set! t (and t (or (eq? g #\space) (eq? g #\tab)))))
                   (string->list curr-word))
         t))
    (set! word-history (append word-history
                               `(,curr-word)))))

(define (show-word-history)
  (when (> (length word-history) 8)
    (set! word-history '()))
  (for-each
   (lambda(w)
     (set! y (add1 y))
     (mvprintw y x  "~A" w))
   (reverse word-history)))

(define (show-help-screen)
  (initscr)
  (cbreak)
  (clear)
  (let ((y 0))
    (for-each
     (lambda (a)
       (mvprintw y 0 "~A" a)
       (set! y (add1 y)))
     (s-split "\n" usage-display))))

(define (say-word)
  (let ((k (s-split " " selected-command)))
    (process (car k)
             (map (lambda(a)
                    (let ((l (string->symbol curr-word)))
                      (when (memq l (map car abbr))
                        (set! curr-word (alist-ref l abbr))))
                    (if (s-contains? "~A" a) curr-word a))
                  (cdr k)))))

(define (main)
  (define w (initscr))
  (cbreak)
  (let ((c (getch))
        (curr-index #f))
    (clear)
    (case c
        ((#\newline  #\space)
         (add-to-word-history)
         (say-word)
         (set! curr-word ""))
        ((#\delete)
         (set! curr-word ""))
        ((#\tab)
         (show-help-screen))
        (else
         (set! curr-word
           (string-append
            curr-word
            (list->string `(,c))))))
    (when (not (eq? c #\tab))
      (show-word-history))
    (set! y 0)
    (when (not (eq? c #\escape))
      (mvprintw y x  "~A" curr-word)
      (main))))


(main)
(endwin)
(print "bye..")
(exit)
