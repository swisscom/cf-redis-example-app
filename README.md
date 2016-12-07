# CF Redis Enterprise Example App 

This app is an example of how you can consume a Cloud Foundry service within an app.

It allows you to set, get and delete Redis key/value pairs using RESTful endpoints.

### Getting Started

Install the app by pushing it to your Cloud Foundry and binding with the Redis service

Example:

     $ git clone -b redisent https://github.com/swisscom/cf-redis-example-app.git
     $ cd cf-redis-example-app
     $ cf create-service redisent large redisent-example
     $ cf push

### Endpoints

#### PUT /:key

Sets the value stored in Redis at the specified key to a value posted in the 'data' field. Example:

    $ export APP=redisent-example-app.my-cloud-foundry.com
    $ curl -X PUT $APP/foo -d 'data=bar'
    success


#### GET /:key

Returns the value stored in Redis at by the key specified by the path. Example:

    $ curl -X GET $APP/foo
    bar

#### DELETE /:key

Deletes a Redis key spcified by the path. Example:

    $ curl -X DELETE $APP/foo
    success
