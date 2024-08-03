{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
}:
buildGoModule rec {
  pname = "mautrix-slack";
  version = "2024-05-01";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "75d2ffd88b6f1d097697fab363099ed7d37fff6f";
    hash = "sha256-l0pZPp11VJ7xP0uuctjOEZHCDnS4OAbxMRkcNQLbMzs=";
  };

  buildInputs = [
    olm
  ];

  vendorHash = "sha256-FL0wObZIvGV9V7pLmrxTILQ/TGEMSH8/2wFPlu6idcA=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/slack";
    description = "A Matrix-Slack puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [kittywitch];
    mainProgram = "mautrix-slack";
  };
}
