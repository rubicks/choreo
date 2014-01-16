(ns choreo.handler  
  (:require
   [choreo.models.schema :as schema]
   [choreo.routes.home :refer [home-routes]]
   [com.postspectacular.rotor :as rotor]
   [compojure.core :refer [defroutes]]            
   [compojure.route :as route]
   [environ.core :refer [env]]
   [noir.util.middleware :as middleware]
   [selmer.parser :as parser]
   [taoensso.timbre :as timbre]
   ))


(defroutes app-routes
  (route/resources "/")
  (route/not-found "Not Found"))


(defn init
  "init will be called once when
   app is deployed as a servlet on
   an app server such as Tomcat
   put any initialization code here"
  [& args]
  (timbre/set-config!
    [:appenders :rotor]
    {:min-level :info
     :enabled? true
     :async? false ; should be always false for rotor
     :max-message-per-msecs nil
     :fn rotor/append})

  (timbre/set-config!
    [:shared-appender-config :rotor]
    {:path "choreo.log" :max-size (* 512 1024) :backlog 10})

  (if (env :selmer-dev) (parser/cache-off!))

  (if-not (schema/initialized?) (schema/init))
  (timbre/info "schema initialized successfully")
  (timbre/info "choreo started successfully")
  (timbre/info (.getClassName (first (.getStackTrace (Throwable.)))))
  )


(defn destroy
  "destroy will be called when your application
   shuts down, put any clean up code here"
  []
  (timbre/info "choreo is shutting down...")
  (timbre/info (.getClassName (first (.getStackTrace (Throwable.)))))
  )


(defn template-error-page [handler]
  (if (env :selmer-dev)
    (fn [request]
      (try
        (handler request)
        (catch clojure.lang.ExceptionInfo ex
          (let [{:keys [type error-template] :as data} (ex-data ex)]
            (if (= :selmer-validation-error type)
              {:status 500
               :body (parser/render error-template data)}
              (throw ex))))))
    handler))


(def app (middleware/app-handler
           ;; add your application routes here
           [home-routes app-routes]
           ;; add custom middleware here
           :middleware [template-error-page]
           ;; add access rules here
           :access-rules []
           ;; serialize/deserialize the following data formats
           ;; available formats:
           ;; :json :json-kw :yaml :yaml-kw :edn :yaml-in-html
           :formats [:json-kw :edn]))
