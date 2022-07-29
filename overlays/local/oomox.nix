{ gnome3
, stdenv
, gdk-pixbuf
, glib
, libxml2
, bc
, librsvg
, sassc
, inkscape
, optipng
, python3
, gtk3
, gobject-introspection
, gtk-engine-murrine
, fetchFromGitHub
, wrapGAppsHook
, makeWrapper
, runtimeShell
}:
python3.pkgs.buildPythonApplication rec {
					format = "other";
          name = "oomox";
          src = fetchFromGitHub {
            owner = "themix-project";
            repo = "oomox";
            rev = "1.14";
            sha256 = "0zk2q0z0n64kl6my60vkq11gp4mc442jxqcwbi4kl108242izpjv";
            fetchSubmodules = true;
          };
					  dontWrapGApps = true;
					dontPatchELF = true;
					dontFixup = true;
					doCheck = false;
					strictDeps = false;
					buildPhase = ''
					true
					'';
          nativeBuildInputs = [ makeWrapper wrapGAppsHook libxml2 gobject-introspection glib bc ];
					propagatedBuildInputs = with python3.pkgs; [
						gnome3.gnome-themes-extra gdk-pixbuf librsvg sassc inkscape optipng
						gobject-introspection
						pygobject3
						python3
						gtk-engine-murrine
						pystache
						pyyaml
						gtk3
						bc
	
					];
          propagatedUserEnvPkgs = [ gtk-engine-murrine ];
installPhase = ''
mkdir $out
gappsWrapperArgsHook
make install DESTDIR=/ PREFIX=$out APPDIR=$out/lib/share/oomox
for prog in $out/bin/*; do
sed -i "s/cd /true /" $prog
wrapProgram $prog "''${gappsWrapperArgs[@]}"  --prefix PATH : "${bc}/bin:${python3}/bin" --prefix PYTHONPATH : "$out/lib/share/oomox:$PYTHONPATH"
done
#for script in $(find $out -name "change_color.sh"); do
#	cp ${./script.sh} $script
#done
'';
}
