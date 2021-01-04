(ns midi-mediator.main
  (:require [cljs-bean.core :refer [bean]]))

(def note-on-message (array 0x9f, 80, 0x7f) #_[0x9f, 80, 0x7f])
(def note-off-message (array 0x8f, 80, 0x40) #_[0x8f, 80, 0x40])

(defn ^:export send-note-to-device [device start-time]
  ;; (println "send midi note on/off")
  (js-invoke device "send" note-on-message start-time)
  (js-invoke device "send" note-off-message (+ start-time 10)))

(def last-scheduled-note-time (atom nil))

(defn ^:export lfo-tick-fun [worker
                             device
                             ^js event]
  (let [event-data (.-data event)
        cmd (.-cmd event-data)]
    (case cmd
      "lfo-tick"
      (let [note-interval (.-noteInterval event-data)
            last-scheduled (deref last-scheduled-note-time)
            next-note-time (.-nextNoteTime event-data)]

        (when (not= last-scheduled next-note-time)
          (send-note-to-device device next-note-time)
          (reset! last-scheduled-note-time next-note-time)

          (let [current-time (atom (js/window.performance.now))]
            ;; busy loop
            (while (< (deref current-time) next-note-time)
              (reset! current-time (js/window.performance.now)))

            (.. worker (postMessage (js-obj "cmd" "next-note-time"
                                            "nextNoteTime" (+ next-note-time note-interval)))))))

      ;; strange event recieved...
      (println "dunno" event))))

(defn ^:export set-lfo-device [midi-access]
  (let [get-device (fn [port-id]
                     (js-invoke (.-outputs midi-access) "get" port-id))
        current-worker (atom nil)]
    (fn [port-id]

      (when (deref current-worker)
        (println "sending off signal....")
        (.. (deref current-worker) (postMessage (js-obj "cmd" "off"))))

      (when port-id
        (let [start-time (js/window.performance.now)
              worker (js/Worker. "/cljs/midi-mediator/out/worker.js")
              device (get-device port-id)]
          (println "setting up lfo worker" device)
          (.. worker (addEventListener "message" (partial lfo-tick-fun worker device)))
          (.. worker (postMessage (js-obj "cmd" "on"
                                          "initialTime" start-time)))
          (reset! current-worker worker))))))

(defn ^:export send-note [midi-access]
  (let [port-id "8837D4A7553916ADF0351EB34983F5F9DBF3B8526C9CE5CE6EC9F2E1E233FC2F"
        nts1 (js-invoke (.-outputs midi-access) "get" port-id)
        current-time (js/window.performance.now)]
    (println "listen carefully")
    (println (+ current-time 500))
    (js-invoke nts1 "send" note-on-message current-time)
    (js-invoke nts1 "send" note-off-message (+ current-time 500))))

(defn init []
  (println "initializing clojure script stuff...")
  #_(let [worker (js/Worker. "/cljs/midi-mediator/out/worker.js")]
    (.. worker (addEventListener "message" (fn [e] (js/console.log e))))
    (.. worker (postMessage "hello world"))
    (.. worker (postMessage "hello world foobar"))))

(defn ^:export myfun []
  (println "hello from clojure script!"))

(defn ^:export my-other-fun []
  (println "foobar"))

(def js-hobbit #js {"name" "Bilbo Baggins", "age" 111})

(defn ^:export fancy-fun [^js midi-access]
  (println "fancy object" midi-access)
  (println "inputs list? " (.-inputs midi-access))
  (println (js-keys midi-access))
  (println (js->clj midi-access))
  #_(doseq [i (.-inputs midi-access)]
    (println "keys " (keys i))
    (println "vals " (vals i))
    (println "input stuff? " (bean i))))
