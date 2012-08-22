express        = require('express')
routes         = require('./routes')
http           = require('http')
path           = require('path')
mongoose       = require('mongoose')
lessMiddleware = require('less-middleware')
publicDir      = __dirname + '/public'

mongoose.connect process.env.MONGOLAB_URI || 'mongodb://localhost/todone'

Todo = mongoose.model 'Todo', new mongoose.Schema
  content: String
  done: Boolean

app = express()

app.configure () ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.cookieParser()
  app.use lessMiddleware({ src: publicDir, compress: true })
  app.use express.static(publicDir )
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(path.join(__dirname, 'public'))
  app.use app.router

app.configure 'development', () ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true


app.configure 'production', () ->
  app.use express.errorHandler()

# Routes

app.get '/', (req, res) ->
  res.render 'index', {title: ""}

app.get '/todos_index', (req, res) ->
  res.render 'todos_index'

app.get "/todos", (req, res) ->
  Todo.find (err, todos) ->
    res.send todos

app.post "/todos", (req, res) ->
  todo = new Todo(content: req.body.content, done: req.body.done)
  todo.save (err) ->
    console.log("created") unless err
  res.send todo

app.put "/todos/:id", (req, res) ->
  Todo.findById req.params.id, (err, todo) ->
    todo.content = req.body.content
    todo.done = req.body.done
    todo.save (err) ->
      console.log("updated") unless err
      res.send todo

app.del '/todos/:id', (req, res) ->
  Todo.findById req.params.id, (err, todo) ->
    todo.remove (err) ->
      console.log("removed") unless err


app.listen app.get('port'), ->
  console.log "Express server listening on port %d in %s mode", app.get('port'), app.settings.env
