var connection = require('../connection');
var ejs = require('ejs');
var fs = require('fs');
var rows = [];

connection.query(
	'SELECT * FROM receptor_requests', [], (err, result) => {
		if (err) throw err;

		if (result.rowCount > 0) {
			rows = result.rows;
		}
	}
);
