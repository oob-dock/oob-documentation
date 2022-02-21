var express = require('express');
var router = express.Router();
require('dotenv').config();

router.use('/login', require('./login'));
router.use('/consent', require('./consent'));
router.use('/redirect', require('./redirect'));
router.use('/load', require('./load'));

module.exports = router;
