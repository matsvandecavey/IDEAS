within IDEAS.Buildings.Validation.Data.Constructions;
record LightWall_195_Fiberglass6dot6 "BESTEST Light wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final locGain=2,
    final mats={Materials.WoodSiding_195(d=0.009),IDEAS.Buildings.Validation.Data.Insulation.Fiberglass( d=0.066),
        Materials.PlasterBoard(d=0.012)});

end LightWall_195_Fiberglass6dot6;
