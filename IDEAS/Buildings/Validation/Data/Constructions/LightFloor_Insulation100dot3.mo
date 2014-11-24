within IDEAS.Buildings.Validation.Data.Constructions;
record LightFloor_Insulation100dot3 "BESTEST Light floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=2,
    final locGain=1,
    final mats={IDEAS.Buildings.Validation.Data.Insulation.Insulation( d=1.003),Materials.PlasterBoard(d=0.010)});

end LightFloor_Insulation100dot3;
