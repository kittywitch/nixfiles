final: prev: {
  cairo = prev.cairo.override { glSupport = false; };
}
