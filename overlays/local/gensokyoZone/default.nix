{ writeTextFile, linkFarm }:

let
  mewp = writeTextFile {
    name = "index.html";
    text = ''
      <html>
        <head>
          <title>Gensokyo Zone</title>
        </head>
        <body>
          <img src="cute.png">
        </body>
      </html>
    '';
  };
  mewy = "${./cute.png}";
in
linkFarm "index" [
  { name = "index.html"; path = mewp; }
  { name = "cute.png"; path = mewy; }
]
