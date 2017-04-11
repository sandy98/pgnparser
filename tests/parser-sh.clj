#!/usr/bin/env clj

(require '[clojure.java.shell :refer [sh]])

;; (println (or (first *command-line-args*) "No command line arguments provided."))
(println (:out (sh "../pgnparser" (or (first *command-line-args*) "") "1" "100")))

(System/exit 0)


