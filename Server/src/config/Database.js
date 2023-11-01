const mysql = require('mysql');
// const dbConfig = require('../config/db.config');
// var con = mysql.createPool({
//     host: dbConfig.HOST,
//     user: dbConfig.USER,
//     password: dbConfig.PASSWORD,
//     database: dbConfig.DATABASE
// });
const con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "signup"
});

module.exports = con;

