{ writeTextFile, linkFarm }:

let
  mewp = writeTextFile {
    name = "index.html";
    text = ''
      <html>
        <head>
          <title>Gensokyo</title>
          <link rel="stylesheet" type="text/css" href="main.css">
        </head>
        <body>
          <img src="cute.png"/>
        </body>
      </html>
    '';
  };
in
linkFarm "index" [
  { name = "index.html"; path = mewp; }
  { name = "main.css"; path = ./main.css; }
  { name = "cute.png"; path = ./cute.png; }
]
