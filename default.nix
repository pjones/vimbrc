{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenvNoCC.mkDerivation {
  name = "pjones-vimbrc";
  src = ./.;
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin $out/etc

    for file in bin/*; do
      install -m 0550 "$file" $out/bin
    done

    for file in etc/*; do
      install -m 0440 "$file" $out/etc
    done
  '';
}
