{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  sarif-fmt,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "sarif-fmt";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-QiIAo9q8pcon/Os7ih8jJyDLvKPrLD70LkMAQfgwDNM=";
  };

  cargoHash = "sha256-RlINf/8P+OpZffvqbkKoafeolioDGABWS71kpGcX/cs=";

  # `test_clippy` (the only test we enable) is broken on Darwin
  # because `--enable-profiler` is not enabled in rustc on Darwin
  # error[E0463]: can't find crate for profiler_builtins
  doCheck = !stdenv.isDarwin;

  checkFlags = [
    # these tests use nix so...no go
    "--skip=test_clang_tidy"
    "--skip=test_hadolint"
    "--skip=test_shellcheck"

    # requires files not present in the crates.io tarball
    "--skip=test_clipp"
  ];

  passthru = {
    tests.version = testers.testVersion { package = sarif-fmt; };
  };

  meta = {
    description = "A CLI tool to pretty print SARIF diagnostics";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "sarif-fmt";
  };
}
