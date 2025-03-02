{ nur, ... }:
(_final: prev: {
  nur = import nur {
    nurpkgs = prev;
    pkgs = prev;
    repoOverrides = {
      # mulatta = import mulatta-nur { pkgs = prev; };
    };
  };
})
