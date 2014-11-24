within IDEAS.Buildings.Data.Constructions;
record FloorOnGround
  "Example - Floor on ground for floor heating system with no ground insulation"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=3,
    locGain=2,
    mats={Materials.Concrete(d=0.20), Materials.Screed(d=0.08),
        Materials.Concrete(d=0.015)});

end FloorOnGround;
