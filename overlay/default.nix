final: prev:
if prev.stdenv.isDarwin then
  {
    # ghostty = prev.callPackage ./pkgs/ghostty { };
    # cleanshot = prev.callPackage ./pkgs/cleanshot { };
    # hammerspoon = prev.callPackage ./pkgs/hammerspoon { };
    # homerow = prev.callPackage ./pkgs/homerow { };
    # hookmark = prev.callPackage ./pkgs/hookmark { };
    # bookends = prev.callPackage ./pkgs/bookends { };
    # keymapp = prev.callPackage ./pkgs/keymapp { };
  }
else
  { }
