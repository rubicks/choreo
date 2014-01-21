(ns choreo.models.schema
  (:require
   [clojure.java.jdbc :as sql]
   [noir.io :as io]
   [taoensso.timbre :as timbre]
   ))

(def db-store "site.db")

(def db-spec {:classname "org.h2.Driver"
              :subprotocol "h2"
              :subname (str (io/resource-path) db-store)
              :user "sa"
              :password ""
              :naming {:keys clojure.string/lower-case
                       :fields clojure.string/upper-case}})

(defn initialized?
  "checks to see if the database schema is present"
  [& args]
  (.exists (new java.io.File (str (io/resource-path) db-store ".h2.db"))))

(defn- -create-guestbook-table [& args]
  (sql/with-connection db-spec
    (sql/create-table
      :guestbook
      [:id        "INTEGER PRIMARY KEY AUTO_INCREMENT"]
      [:timestamp :timestamp]
      [:name      "varchar(30)"]
      [:message   "varchar(200)"])
    (sql/do-commands
     "CREATE INDEX timestamp_index ON guestbook (timestamp)"))
  ;; (timbre/info "success: choreo.models.schema/-create-guestbook-table")
  ;; (timbre/info (meta args))
  )

(defn- -create-tables
  "creates the database tables used by the application"
  [& args]
  (-create-guestbook-table)
  ;; (timbre/info "success: choreo.models.schema/-create-tables")
  )

(defn init [& args]
  (-create-tables)
  ;; (timbre/info "success: choreo.models.schema/init")
  )
