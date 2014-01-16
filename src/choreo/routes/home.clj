(ns choreo.routes.home
  (:use compojure.core)
  (:require
   [choreo.models.db :as db]
   [choreo.util :as util]
   [choreo.views.layout :as layout]
   ))

(defn home-page [& [name message error]]
  (layout/render "home.html"
                 {:error error
                  :name name
                  :message message
                  :messages (db/get-messages)}))

(defn about-page []
  (layout/render "about.html"))

(defroutes home-routes
  (GET "/" [] (home-page))
  (GET "/about" [] (about-page)))
