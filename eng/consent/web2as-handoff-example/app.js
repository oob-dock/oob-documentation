var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const session = require('express-session');
const MemoryStore = require('memorystore')(session);
const fs = require('fs');

var indexRouter = require('./routes/index');

var app = express();

app.use(
  session({
    cookie: { maxAge: 600000 },
    store: new MemoryStore({
      checkPeriod: 600000,
    }),
    resave: false,
    secret: 'AUTH-EXAMPLE-SECRET',
    saveUninitialized: true,
  })
);

app.set('views', __dirname + '/views');
app.set('view engine', 'jsx');
app.engine('jsx', require('express-react-views').createEngine());

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/api', indexRouter);

// Definição da rota para início do fluxo handoff. No Authorization Server (AS), a configuração da URL
// para handoff (HANDOFF_RESOURCE_URL) nesse caso seria, por exemplo: http://exemplo.com.br/handoffsample#<IDENTIFICACAO>
app.get('/handoffsample', (_, res) => {
  fs.readFile(path.join(__dirname, './views', 'handoffsample.html'), "utf8", function (error, pgResp) {
    if (error) {
        res.writeHead(404);
        res.write('Contents you are looking are Not Found');
    } else {
        const asBaseUrl = process.env.AS_OOB_URL.replace('/auth', '');
        pgResp = pgResp.split('AS_BASE_URL').join(asBaseUrl);
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.write(pgResp);
    }
    res.end();
  });
});

app.get('*', (_, res) =>
  res.sendFile(path.join(__dirname, './public', 'index.html'))
);

app.use(function (req, res, next) {
  next(createError(404));
});

app.use(function (err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};
  console.log(err);

  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
