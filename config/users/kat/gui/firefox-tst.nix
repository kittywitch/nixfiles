{ config, ... }:

{
  home.file.".mozilla/tst.css".text = let base16 = config.kw.hexColors; in ''
    /* Hide border on tab bar, force its state to 'scroll', adjust margin-left for width of scrollbar. */ 
    #tabbar { border: 0; overflow-y: scroll !important; }

/* Hide .twisty and adjust margins so favicons have 7px on left. */
.tab .twisty {
    margin-left: -16px;
}

/* Push tab labels slightly to the right so they're completely hidden in collapsed state */
.tab .label {
    margin-left: 7px;
}
/* Hide close buttons on tabs. */
.tab .closebox {
    visibility: collapse;
}

/* Hide sound playing/muted button. */
.sound-button::before {
    display: none !important;
}

/* Hide 'new tab' button. */
.newtab-button {
    display: none;
}

/* ################################################ */
/* ##### COLOR THEME ############################## */
/* ################################################ */
@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}
@keyframes pulse {
    0% {
        opacity: 0.75;
    }
    100% {
        opacity: 0.25;
    }
}
* {
    font-family: "Cozette", monospace !important;
}
:root {
    background-color: ${base16.base00} !important;
}
#tabbar {
    background-color: ${base16.base00} !important;
    border-right: 1px solid ${base16.base01};
    box-shadow: none !important;
}
.tab {
    background-color: ${base16.base01};
    color: ${base16.base05} !important;
    box-shadow: none !important;
    margin: 0.125em;
    border-radius: 0.125em;
    }

.tab .favicon {
    margin-left: 0.25em;
}

.tab .label {
  margin: 0.25em;
}
.tab:hover {
    background-color: ${base16.base0C}FF !important;
    color: ${base16.base07} !important;
}
.tab.discarded {
    background-color: ${base16.base00};
    color: ${base16.base02} !important;
}
.tab.discarded:hover {
    background-color: ${base16.base01} !important;
    color: ${base16.base03} !important;
}

:root .tab .highlighter::before {
    display: none;
}

.tab.active {
    background-color: ${base16.base0D}FF;
    color: ${base16.base07} !important;
}
.tab.active:hover {
    background-color: ${base16.base0D}FF !important;
}

@keyframes rainbow_animation {
    0% {
        background-position: 0 0;
    }

    100% {
        background-position: 100% 0;
    }
}
/* Adjust style for tab that has sound playing. */
    .tab.sound-playing .label {
        background: linear-gradient(to right, #6666ff, #0099ff , #00ff00, #ff3399, #6666ff);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
    animation: rainbow_animation 3s linear infinite;
    animation-direction: alternate-reverse;
    background-size: 400% 100%;
    }

/* Adjust style for tab that is muted. */
.tab.muted {
    opacity: 0.5;
}
  '';
}
