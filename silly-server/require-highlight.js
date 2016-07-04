
var Highlights = require("../lib/highlights");
var highlighter = new Highlights();

var express = require("express");
var app = express();

app.get("/", function (req, res) {
    var html = highlighter.highlightSync({
        fileContents: "var hello = \"world\";",
        scopeName: "source.js",
    });

    res.send(template(html));
});

app.use("/static", express.static("public"));

app.listen(3000, function () {
    // listen...
});

var template = function (code) {
    var stylesheet = `http://localhost:3000/static/source-code.css`;

    return `<html>
        <head>
            <title>Tonic</title>
            <link href='https://fonts.googleapis.com/css?family=Source+Code+Pro'
                rel='stylesheet' type='text/css'>
            <link href="${stylesheet}" rel="stylesheet" type='text/css' />
            <style>div:target{background:#ffa;}</style>
        </head>
        <body>
            <div class="source-code">
                ${code}
            </div>
        </body>
    </html>`;
};
