express        = require('express')
routes         = require('./routes')
lessMiddleware = require('less-middleware')
publicDir      = __dirname + '/public'
orm            = require('orm')

Post = null
db_host = process.env.DATABASE_URL || "postgres://pierre@localhost/portfolio_blog"
db = orm.connect db_host, (success, db)->
  if !success
    console.log("Could not connect to database!")
  else
    console.log("Connection successful")
    Post = db.define "posts"
      "title"   : "String"
      "content"    : "Text"



app = module.exports = express.createServer()

app.configure( () ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.cookieParser()
  app.use lessMiddleware({ src: publicDir, compress: true })
  app.use express.static(publicDir )
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
)

app.configure 'development', () ->
  app.use express.errorHandler({
    dumpExceptions: true
    showStack: true
  })


app.configure 'production', () ->
  app.use express.errorHandler()

# Routes

app.get '/', (req, res) ->
  res.render 'index', {title: ""}

app.get '/cv', (req, res) ->
  res.render 'index', {title: "Cv coming soon"}

app.get '/posts', (req, res) ->
  if req.accepts('application/json')
    Post.find (posts) ->
      res.contentType('application/json')
      res.send(posts)
  else
    res.render 'posts', {title: "Blog coming soon"}

app.put '/posts/:id', (req, res) ->
  Post.get req.params.id, (post) ->
    post.title = req.body.post.title
    post.content = req.body.post.content
    post.save (err) ->
      console.log 'err: ' + err
      res.contentType('application/json')
      res.send('')

app.post '/posts', (req, res) ->
  post = new Post(req.body.post)
  post.save (err) ->
    console.log 'err: ' + err
    res.contentType('application/json')
    res.send(post)

app.delete '/posts/:id', (req, res) ->
  Post.get req.params.id, (post) ->
    post.remove () ->
    res.contentType('application/json')
    res.send('')

app.get '/contact', (req, res) ->
  res.render 'index', {title: "Contact page coming soon"}

app.get '/posts/new', (req, res) ->
  res.render 'index', {title: "you should not be here"}

app.get '/work', (req, res) ->
  res.render 'work'

port = process.env.PORT || 3000

app.listen port, () ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
