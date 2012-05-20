express        = require('express')
routes         = require('./routes')
lessMiddleware = require('less-middleware')
publicDir      = __dirname + '/public'
pg             = require('pg')

app            = module.exports = express.createServer()

conString = "postgres://localhost/node-portfolio"

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
    pg.connect conString, (err, client) ->
      client.query "SELECT * FROM posts", (err, result) ->
        res.contentType('application/json')
        res.send(result.rows)
  else
    res.render 'posts', {title: "Blog coming soon"}

app.get '/contact', (req, res) ->
  res.render 'index', {title: "Contact page coming soon"}

app.get '/posts/new', (req, res) ->
  res.render 'index', {title: "you should not be here"}

app.get '/work', (req, res) ->
  res.render 'work'

port = process.env.PORT || 3000

app.listen port, () ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
