(provide 'util)

(defun eval-and-replace ()
  "Evaluate Lisp expression at point, replacing expression with
its result."
  (interactive)
  (backward-sexp)
  (mark-sexp)
  (eval-region (region-beginning) (region-end) (current-buffer))
  (kill-region (region-beginning) (region-end))
  (kill-line)
  (previous-line 2)
  (end-of-line)
  (kill-line)
  (deactivate-mark)
  (forward-sexp))
(bind-key "C-x E" #'eval-and-replace)


(defun filter (pred lst &optional acc)
  "Return elements of LST that satisfy PRED."
  (if (not lst)
      (reverse acc)
    (let ((a (car lst))
	  (rest (cdr lst)))
      (if (funcall pred a)
	  (filter pred rest (cons a acc))
	(filter pred rest acc)))))

(defun reduce (reducer lst &optional start)
  "Reduce LST according to REDUCER."
  (if start
      (--reduce reducer lst start)
    (--reduce reducer (cdr lst) (car lst))))

(defun --reduce (reducer lst acc)
  (if (not lst)
      acc
    (let ((a (car lst))
	  (rest (cdr lst)))
      (reduce-helper reducer rest (funcall reducer a acc)))))

;; I don't like how Lisp source files embed the documentation to the
;; function above the function definition.  I think this is convenient
;; for some functions and most languages, but in Lisp it's quite
;; possible that the function definition is simpler than the
;; documentation.
(defun range (start &optional stop step)
  "Generate a list of numbers like Python's range function.

* If only START is provided, then return [0, START).
* If STOP is provided, but not step, then return [START, STOP).
* If STEP is provided, then return [START, STOP), incrementing by STEP.

In the latter two cases, STOP < START is supported.

See range* for a more general form of range."
  (cond ((and (null stop) (null step))
	 (if (cl-plusp start) (range 0 start 1) (range 0 start -1)))
	((null step)
	 (range start stop (if (< start stop) 1 -1)))
	(t (range* start
		   (lambda (x) (+ x step))
		   (if (< start stop)
		       (lambda (x) (>= x stop))
		     (lambda (x) (<= x stop)))))))

(defun range* (start succ test)
  "Return a list of objects beginning with START, incrementing by
function SUCC, and ending just before TEST called with START
returns t."
  (if (funcall test start)
      nil
    (cons start (range* (funcall succ start) succ test))))

(defun ref (seq inds)
  "Reference the indices of SEQ according to INDS like Python's
  [] operator. Negative indices not yet supported."
  (--ref seq inds 0))

(defun --ref (seq inds ind)
  (if (or (null seq) (null inds))
      nil
    (if (< ind (car inds))
	(--ref (cdr seq) inds (1+ ind))
      (cons (car seq) (--ref (cdr seq) (cdr inds) (1+ ind))))))

(defmacro ->> (form &rest forms)
  (if (null forms)
      form
    `(->> ,(append (car forms) (list form)) ,@(cdr forms))))

(defmacro -> (form &rest forms)
  (if (null forms)
      form
    `(-> ,(append (list (caar forms)) (list form) (cdar forms))
	 ,@(cdr forms))))

;; TODO: I like this abstraction, but I don't like the way it
;; looks when called.  It's hard to read what's happening.
(defmacro n->> (form fn n &optional args)
  "Thread FORM througn FN with ARGS N times."
  `(->> ,form
	,@(make-list n `(,fn ,@args))))

(defmacro n-> (form fn n &optional args)
  `(-> ,form
       ,@(make-list n `(,fn ,@args))))

(defmacro sop (&rest forms)
  "Sum of products for forms."
  `(+ ,@(mapcar (lambda (form) (cons '* form)) forms)))

(defmacro pos (&rest forms)
  "Product of sums for forms."
  `(* ,@(mapcar (lambda (form) (cons '+ form)) forms)))

(defun mkcd (dirname)
  (make-directory dirname)
  (cd dirname))
