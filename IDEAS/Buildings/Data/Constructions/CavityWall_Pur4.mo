within IDEAS.Buildings.Data.Constructions;
record CavityWall_Pur4
  "Example - Classic cavity wall construction with 10 cm filled air cavity"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=4,
    locGain=2,
    final mats={Materials.BrickMe(d=0.08), Materials.Pur(d=0.16), Materials.BrickMi(d=
        0.14),Materials.Gypsum(d=0.015)});

end CavityWall_Pur4;
