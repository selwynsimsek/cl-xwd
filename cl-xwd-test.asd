#|
  This file is a part of cl-xwd project.
  Copyright (c) 2019 Selwyn Simsek
|#

(defsystem "cl-xwd-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Selwyn Simsek"
  :license ""
  :depends-on ("cl-xwd"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-xwd"))))
  :description "Test system for cl-xwd"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
