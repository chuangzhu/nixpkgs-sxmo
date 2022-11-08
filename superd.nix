{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "superd";
  version = "0.7";

  src = fetchFromSourcehut {
    owner = "~craftyguy";
    repo = pname;
    rev = version;
    hash = "sha256-XSB6qgepWhus15lOP9GzbiNoOCSsy6xLij7ic3LFs1E=";
  };

  vendorHash = "sha256-Oa99U3THyWLjH+kWMQAHO5QAS2mmtY7M7leej+gnEqo=";

  meta = with lib; {
    description = "User service supervisor";
    homepage = "https://sr.ht/~craftyguy/superd/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
