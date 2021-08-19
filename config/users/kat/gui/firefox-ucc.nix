{ profile, base16 }:

''
    * {
      font-family: "Cozette", monospace;
    }

    :root {
    --animationSpeed  : 0.15s;
    }

  /* Hide main tabs toolbar */
  #TabsToolbar {
      visibility: collapse;
  }
  /* Hide splitter, when using Tree Style Tab. */
  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] + #sidebar-splitter {
      display: none !important;
  }
  /* Hide sidebar header, when using Tree Style Tab. */
  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
      visibility: collapse;
  }


  #back-button { display: none !important }
  #forward-button { display: none !important }
  #urlbar-search-mode-indicator { display: none !important }
  #urlbar *|input::placeholder { opacity: 0 !important; }

  #nav-bar, toolbar-menubar, #menubar-items, #main-menubar {
    background: ${base16.base00} !important;
  }

  #urlbar-background {
    background: ${base16.base01} !important;
  }

  #urlbar {
    text-align: center;
  }

  #urlbar-container {
    width: 50vw !important;
    }

  #star-button{
    display:none;
  }

  #navigator-toolbox {
    border      : none !important;
  }

  .titlebar-spacer {
    display     : none !important;
  }

  #urlbar:not(:hover):not([breakout][breakout-extend]) > #urlbar-background {
    box-shadow  : none !important;
    background  : ${base16.base01} !important;
  }

  .urlbar-icon, #userContext-indicator, #userContext-label {
    fill        : transparent !important;
    background  : transparent !important;
    color       : transparent !important;
  }

  #nav-bar-customization-target > toolbarspring { max-width: none !important }

  #urlbar:hover .urlbar-icon,
  #urlbar:active .urlbar-icon,
  #urlbar[focused] .urlbar-icon {
    fill        : var(--toolbar-color) !important;
  }

  #urlbar-container {
     -moz-box-pack: center !important;
  }

  /* animations */
  toolbarbutton,
  .toolbarbutton-icon,
  .subviewbutton,
  #urlbar-background,
  .urlbar-icon,
  #userContext-indicator,
  #userContext-label,
  .urlbar-input-box,
  #identity-box,
  #tracking-protection-icon-container,
  [anonid=urlbar-go-button],
  .urlbar-icon-wrapper,
  #tracking-protection-icon,
  #identity-box image,
  stack,
  vbox,
  tab:not(:active) .tab-background,
  tab:not([beforeselected-visible])::after,
  tab[visuallyselected] .tab-background::before,
  tab[visuallyselected] .tab-background::before,
  .tab-close-button {
    transition  : var(--animationSpeed) !important;
  }
''
