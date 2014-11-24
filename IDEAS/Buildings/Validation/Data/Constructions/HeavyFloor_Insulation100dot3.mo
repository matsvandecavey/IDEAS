within IDEAS.Buildings.Validation.Data.Constructions;
record HeavyFloor_Insulation100dot3 "BESTEST Heavy floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=2,
    final locGain=2,
    final mats={IDEAS.Buildings.Validation.Data.Insulation.Insulation( d=1.003),Materials.ConcreteSlab(d=0.08)});

end HeavyFloor_Insulation100dot3;
