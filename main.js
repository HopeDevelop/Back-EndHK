var express = require('express');
var url = require('url');
var ejs = require('ejs');
var fs = require('fs');
var app = express();

app.get('/', (req, res) => {
	fs.readFile('./static/index.html', 'utf8', (err, data) => {
		if (err) throw err;

		res.statusCode = 200;
		res.setHeader('content-type', 'text/html');
		res.send(data);
	});
});

app.post('/home', (req, res) => {
	req.on('data', (data) => {
		data = data.toString().split("&");
		data.forEach((value, key) => {
			data[key] = value.split("=")[1];
		});

		var db = require('./connection');
		db.query(
			'SELECT * FROM admins WHERE username = $1::varchar AND password = $2::varchar',
			data, (err, result) => {
				if (result.rowCount == 1) {
					fs.readFile('./static/home.html', 'utf8', (err, data) => {
						if (err) throw err;

						res.statusCode = 200;
						res.setHeader('content-type', 'text/html');
						res.send(data);
					});
				} else {
					res.redirect('/');
				}
			}
		);
	});
});

app.get('/receptores', (req, res) => {
	fs.readFile('./static/receptores.ejs', 'utf8', (err, data) => {
		var db = require('./connection');

		db.query("SELECT * FROM receptor_requests", [], (err, result) => {
			var main = "";
			if (result.rowCount > 0) {
				result.rows.forEach((item) => {
					main += "<form method='POST' action='/receptores' enctype='text/plain'>";
					for (key in item) {
						main += "<p>"+key+": "+item[key]+"</p>";
					}
					main += "<input type='hidden' name'username' value='"+item.username+"' />";
					main += "<input type='submit' formaction='/saveReceptor' value='Salvar' />";
					main += "<input type='submit' formaction='/rejectReceptor' value='Recusar' />";
					main += "</form>";
				});
			} else {
				main += "<p>Nenhuma solicitação para exibir</p>";
			}

			data = data.replace("#{main}", main);
			res.send(data);
		});
	});
});

app.post('/saveReceptor', (req, res) => {
	req.on('data', (data) => {
		console.log(data.toString());
		var db = require('./connection');
		console.log(data.toString().split("=")[1]);

		db.query(
			'SELECT accept_receptor_request($1::VARCHAR(20))',
			[data.split("=")[1]], (err, result) => {
				if (err) console.log(err);

				res.redirect('/receptores');
				res.send();
			}
		);
	});
});

app.post('/rejectReceptor', (req, res) => {
	req.on('data', (data) => {
		var db = require('./connection');
		db.query(
			'SELECT remove_receptor_request($1::VARCHAR(20)',
			[data.toString().split("=")[1]],
			(err, results) => {
				if (err) throw err

				res.redirect('/receptores')
				res.end();
			}
		);
	})
})

app.listen(80, () => {
	console.log("Server running on port 80.");
});
