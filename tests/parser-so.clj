#!/usr/bin/env clj

(defmacro jna-call [lib func ret-type & args]
  `(let [lib# (name ~lib) func# (com.sun.jna.Function/getFunction lib# ~func)] 
    (.invoke func# ~ret-type (to-array [~@args]))))

;;(.invoke 
;;  (com.sun.jna.Function/getFunction  "../libpgnparser.so" "parser") 
;;  String 
;;  (to-array [(or (first *command-line-args*) "") 1 100]))

(let [pgn-data (jna-call "../libpgnparser.so", "parser", String, (or (first *command-line-args*) "") 1 100)]
  (println pgn-data))

(System/exit 0)


