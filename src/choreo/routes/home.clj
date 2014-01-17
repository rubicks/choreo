(ns choreo.routes.home
  (:use compojure.core)
  (:require
   [choreo.models.db :as db]
   [choreo.util :as util]
   [choreo.views.layout :as layout]
   ))


(defn- -home-page [& [name message error]]
  (layout/render "home.html"
                 {:error error
                  :name name
                  :message message
                  :messages (db/get-messages)}))


(defn- -save-message [name message]
  (cond
   (empty? name)
   (-home-page name message "Someone forgot to leave a name.")
   (empty? message)
   (-home-page name message "Don't you have something to say?")
   :else
   (do
     (db/save-message name message)
     (-home-page))))


(defn- -about-page []
  (layout/render "about.html"))


(defroutes home-routes
  (GET "/" [] (-home-page))
  (GET "/" [name message] (-home-page name message))
  (GET "/about" [] (-about-page)))
