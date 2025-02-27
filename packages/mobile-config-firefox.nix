{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
}:

stdenvNoCC.mkDerivation {
  pname = "mobile-config-firefox";
  version = "4.4.0-unstable-2025-02-23";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "mobile-config-firefox";
    rev = "151c01014c6520e5ad1678049e82cd8d63545cd1";
    hash = "sha256-DvH6xSFKITmAVMqJA5FWxfzQ57ACYgMUJoW7Nrt0g+w=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    pushd src
    cat $(cat ../out/userContent.files) > $out/userContent.css
    cat $(cat ../out/userChrome.files) > $out/userChrome.css
    popd

    runHook postInstall
  '';

  meta = {
    description = "Mobile and privacy friendly configuration for Firefox (distro-independent)";
    license = lib.licenses.mpl20;
    homepage = "https://gitlab.postmarketos.org/postmarketOS/mobile-config-firefox";
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.all;
  };
}
