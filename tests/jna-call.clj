(defmacro jna-call [lib func ret & args] 
  `(let [library#  (name ~lib)
         function# (com.sun.jna.Function/getFunction library# ~func)] 
     (.invoke function# ~ret (to-array [~@args]))))
     
(defmacro shell [cmd & args]
  `(let [result# (clojure.java.shell/sh (name ~cmd) ~@args)]
     (do
       (if (zero? (:exit result#))
         (println (:out result#))
         (println "ERROR: " (:err result#)))
       (:exit result#))))
       
       
       