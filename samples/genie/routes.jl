using Genie.Router
import GraphqlController

GraphqlController.register()

route("/") do
  serve_static_file("welcome.html")
end