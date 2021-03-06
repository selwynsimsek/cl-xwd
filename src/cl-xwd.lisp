;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Implementation of a parser for X Window dump files.
;;;; Usage: (lisp-binary:read-binary 'cl-xwd:xwd-format stream)
(defpackage :cl-xwd
  (:use :common-lisp)
  (:documentation "A XWD parser for Common Lisp"))

(in-package :cl-xwd)

(export '(xwd-format xwd-from-shared-memory-id shared-memory-raw-pointer))

(lisp-binary:defbinary xwd-color-map-entry (:byte-order :big-endian)
  (entry-number 0 :type (unsigned-byte 32))
  (red 0 :type (unsigned-byte 16))
  (green 0 :type (unsigned-byte 16))
  (blue 0 :type (unsigned-byte 16))
  (flags 0 :type (unsigned-byte 8))
  (padding 0 :type (unsigned-byte 8)))

(lisp-binary:defbinary xwd-format (:export t :byte-order :big-endian)
  (header-size 0 :type (unsigned-byte 32))
  (file-version 0 :type (unsigned-byte 32))
  (pixmap-format 0 :type (unsigned-byte 32))
  (pixmap-depth 0 :type (unsigned-byte 32))
  (pixmap-width 0 :type (unsigned-byte 32))
  (pixmap-height 0 :type (unsigned-byte 32))
  (x-offset 0 :type (unsigned-byte 32))
  (byte-order 0 :type (unsigned-byte 32))
  (bitmap-unit 0 :type (unsigned-byte 32))
  (bitmap-bit-order 0 :type (unsigned-byte 32))
  (bitmap-pad 0 :type (unsigned-byte 32))
  (bits-per-pixel 0 :type (unsigned-byte 32))
  (bytes-per-line 0 :type (unsigned-byte 32))
  (visual-class 0 :type (unsigned-byte 32))
  (red-mask 0 :type (unsigned-byte 32))
  (green-mask 0 :type (unsigned-byte 32))
  (blue-mask 0 :type (unsigned-byte 32))
  (bits-per-rgb 0 :type (unsigned-byte 32))
  (number-of-colors 0 :type (unsigned-byte 32))
  (color-map-entries 0 :type (unsigned-byte 32))
  (window-width 0 :type (unsigned-byte 32))
  (window-height 0 :type (unsigned-byte 32))
  (window-x 0 :type (signed-byte 32))
  (window-y 0 :type (signed-byte 32))
  (window-border-width 0 :type (unsigned-byte 32))
  (creator "" :type (lisp-binary:terminated-string 1 :terminator 0 :external-format :utf8))
  (color-map #() :type (simple-array xwd-color-map-entry (color-map-entries))))

(defun xwd-from-shared-memory-id (shared-memory-id)
  "Reads an XWD file that is stored in shared memory identified by shared-memory-id. \
Intended to be used with `Xvfb -shmem'."
  (lisp-binary:read-binary 'xwd-format
                           (cl-shm:shared-memory-pointer->stream
                            (cl-shm:attach-shared-memory-pointer shared-memory-id))))

(defun shared-memory-raw-pointer (shared-memory-id)
  (cffi:inc-pointer (cl-shm:attach-shared-memory-pointer shared-memory-id)
                    (+ (slot-value (xwd-from-shared-memory-id shared-memory-id) 'header-size)
                       (* 12 (length (slot-value (xwd-from-shared-memory-id shared-memory-id) 'color-map))))))
