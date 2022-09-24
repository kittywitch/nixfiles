{ writeTextFile, linkFarm }:

let
  mewp = writeTextFile {
    name = "index.html";
    text = ''
      <html>
        <head>
          <title>Gensokyo</title>
          <style>
            html {
              margin: 0;
              width: 100%;
              min-height: 100%;
              padding: 0;
            }
            body {
              margin: 2em auto;
              width: 50%;
            }
            img {
              max-height: 33vh;
              min-height: 500px;
              margin: 1em auto;
              display: block;
            }
            h1 {
              text-align: center;
            }
            nav ul {
              list-style-type: none;
              display: grid;
              grid-template-columns: 1fr 1fr 1fr;
              margin: 0;
              padding: 0;

            }
            nav ul li {
              text-align: center;
              margin: 0;
              padding: 0;
            }
          </style>
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
  mewy = "${./cute.png}";
in
linkFarm "index" [
  { name = "index.html"; path = mewp; }
  { name = "cute.png"; path = mewy; }
]
