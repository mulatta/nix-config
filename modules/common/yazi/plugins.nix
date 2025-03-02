{ pkgs, ... }:
{
  glow = pkgs.fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "5ce76dc92ddd0dcef36e76c0986919fda3db3cf5";
    hash = "sha256-UljcrXXO5DZbufRfavBkiNV3IGUNct31RxCujRzC9D4=";
  };
  nbpreview = pkgs.fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "nbpreview.yazi";
    rev = "f8879b382f441e881fc10bd18a523fd910737067";
    hash = "sha256-iHfvLSUveHSRvYw5xFGuhSsTRC3xlY+PaooHnmA7Zzs=";
  };
  miller = pkgs.fetchFromGitHub {
    owner = "Reledia";
    repo = "miller.yazi";
    rev = "40e02654725a9902b689114537626207cbf23436";
    hash = "sha256-GXZZ/vI52rSw573hoMmspnuzFoBXDLcA0fqjF76CdnY=";
  };
}
