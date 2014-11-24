within IDEAS.Buildings.Validation.Data.Constructions;
record LightRoof_195_Fiberglass11dot18 "BESTEST Light roof"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final locGain=2,
    final mats={Materials.Roofdeck_195(d=0.019),IDEAS.Buildings.Validation.Data.Insulation.Fiberglass( d=0.1118),
        Materials.PlasterBoard(d=0.010)});

end LightRoof_195_Fiberglass11dot18;
