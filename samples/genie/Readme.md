# Genie + Diana

This is a sample of Genie with Diana to create a server of graphql.
The implementation of it, can be found in app/resources/graphql/GraphqlController.jl, this is a sample file controller that provides the playground-cli if a get request and graphql implementation if post request.

Server wakes up at localhost:8080/graphql. On / you will found the welcome page of genie.

## Features
* Query and Mutation sample in
* Playground-cli integrated.
* The normal functions autoreload when you change it in hot, the lambda functions, don't seems to work.

## Known Issues
* Schema is not loading well. It requires a more work, I'm not sure if its work in the controller or in Diana itself
