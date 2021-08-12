{ writeTextFile, linkFarm }: hostname:

let mewp = writeTextFile {
  name = "index.html";
  text = ''
<html>
  <head>
    <title>kat's ${hostname}</title>
  </head>
  <body>
    <h1>mew! welcome to ${hostname} ><</h1>

    <img src="splash.jpg">

    <p>stop snooping, it's mean! o:</p>
  </body>
</html>
''; }; mewy = "${./splash.jpg}";
in linkFarm "index" [
  { name = "index.html"; path = mewp; }
  { name = "splash.jpg"; path = mewy; }
]
