#|
  This file is a part of cl-xwd project.
  Copyright (c) 2019 Selwyn Simsek
|#

#|
  Author: Selwyn Simsek
|#

(defsystem "cl-xwd"
  :version "0.1.0"
  :author "Selwyn Simsek"
  :license ""
  :depends-on ("lisp-binary" "cl-shm")
  :components ((:module "src"
                :components
                ((:file "cl-xwd"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "cl-xwd-test"))))
