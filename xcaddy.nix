{ lib
, stdenv
, go
, buildGoModule
, fetchFromGitHub
, makeWrapper
}:
let
  owner = "caddyserver";
  repo = "xcaddy";
  rev = "v0.1.9";
  sha256 = "19gsj3k9x5fb764hfiifp703jpl3daarch19l9f19zqc9b58nw93";
  vendorSha256 = "1nilvjdmky1mf9vxrhy0322hl661y690ah3jg70pdlj9b0q4ilf8";
  version = "0.1.9";

  xcaddyBuild = buildGoModule {
    pname = "xcaddy-build";
    inherit version;

    src = fetchFromGitHub {
      inherit owner repo rev sha256;
    };

    inherit vendorSha256;

    CGO_ENABLED = 0;
  };
in
stdenv.mkDerivation rec {
  inherit xcaddyBuild;

  pname = "xcaddy";
  inherit version;

  buildInputs = [ go ];
  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
     makeWrapper ${xcaddyBuild}/bin/xcaddy "$out/bin/xcaddy" \
      --prefix PATH : ${lib.makeBinPath buildInputs}
  '';
};
