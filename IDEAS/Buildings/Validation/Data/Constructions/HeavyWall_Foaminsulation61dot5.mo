within IDEAS.Buildings.Validation.Data.Constructions;
record HeavyWall_Foaminsulation61dot5 "BESTEST Heavy wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final locGain=2,
    final mats={Materials.WoodSiding(d=0.009),IDEAS.Buildings.Validation.Data.Insulation.Foaminsulation( d=0.615),
                                                                                                    Materials.ConcreteBlock(d=0.10)});

end HeavyWall_Foaminsulation61dot5;
