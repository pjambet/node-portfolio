
express   = require('express')
routes    = require('./routes')
publicDir    = __dirname + '/public'

app       = module.exports = express.createServer()
less      = null
###
Configuration
###


express.compiler.compilers.less.compile = (str, fn) ->
  if (!less)
    less = require("less")
  try
    less.render(str, { compress : true }, fn)
  catch err
    fn(err)

app.configure( () ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.compiler({ src: publicDir, enable: ['less']})
  app.use express.static(publicDir)
  app.use app.router
)

app.configure 'development', () ->
  app.use express.errorHandler({
    dumpExceptions: true
    showStack: true
  })


app.configure 'production', () ->
  app.use express.errorHandler()


# Redis

# var redis = require('redis-url').connect(process.env.REDISTOGO_URL);

# redis.set('foo', 'bar');

# redis.get('foo', function(err, value) {
#   console.log('foo is: ' + value);
# });

# Routes

# app.get('/', routes.index);
app.get '/', (req, res) ->
  res.render 'index', {title: "Index"}

app.get '/cv', (req, res) ->
  res.render 'index', {title: "Cv coming soon"}

app.get '/contact', (req, res) ->
  res.render 'index', {title: "Contact page coming soon"}

app.get '/posts/new', (req, res) ->
  res.render 'index', {title: "you should not be here"}
port = process.env.PORT || 3000

app.listen port, () ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
