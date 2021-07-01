{ profile }:

''
  #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
    opacity: 0;
    pointer-events: none;
  }
  #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
      visibility: collapse !important;
  }

  #sidebar-header {
    display: none;
  }
''
