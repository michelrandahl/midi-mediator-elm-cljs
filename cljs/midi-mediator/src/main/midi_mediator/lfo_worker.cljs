(ns midi-mediator.lfo-worker)

(defonce state (atom {:interval-time 250
                      :frequency 8
                      :timer-id nil
                      
                      :note-interval 750
                      :next-note-time 0}))

(defn reset-keys-in-state [& [kvs]]
  (swap! state #(apply assoc % kvs)))

(defn get-state [k]
  (get (deref state) k))

(defn init []
  (js/self.addEventListener
    "message"
    (fn [^js e]
      (let [event-data (. e -data)
            cmd (. event-data -cmd)]
        (case cmd
          "next-note-time"
          (let [next-note-time (. event-data -nextNoteTime)]
            ;; use the println to visualize the scheduling performed from the worker loop in main
            ;; (println "setting next scheduled note time" next-note-time)
            (reset-keys-in-state [:next-note-time next-note-time]))

          "on"
          (locking state
            (let [initial-time (. event-data -initialTime)
                ;;next-note-time (+ initial-time note-interval)
                  get-next-note-time (fn [] (+ initial-time (get-state :note-interval)))
                  timer-id (js/setInterval (fn []
                                             (let [next-note-time (get-state :next-note-time)]
                                               (println "setInterval timer" next-note-time)
                                               (js/postMessage (js-obj "cmd" "lfo-tick"
                                                                       "nextNoteTime" next-note-time
                                                                       "noteInterval" (get-state :note-interval)))))
                                           (get-state :interval-time))]
              (println "starting lfo")
              (reset-keys-in-state [:next-note-time (get-next-note-time)
                                    :timer-id timer-id])
              (println (deref state))))

          "off"
          (locking state
            (let [timer-id (get-state :timer-id)]
              (println "stopping lfo worker" timer-id)
              (js/clearInterval timer-id)
              (reset-keys-in-state [:timer-id nil])
              (js/self.close)))

          (println "unkown message " e))))))
