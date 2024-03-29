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
          <h1>Gensokyo</h1>
            <img src="cute.png"/>
          <nav>
            <ul>
              <li>
                <a href="https://home.gensokyo.zone">Home Assistant</a>
              </li>
              <li>
                <a href="https://z2m.gensokyo.zone">Zigbee2MQTT</a>
              </li>
              <li>
                <a href="https://id.gensokyo.zone">Kanidm</a>
              </li>
            </ul>
          </nav>
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
