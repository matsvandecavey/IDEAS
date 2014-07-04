within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.Aggregation;
function transientFrac "Calculates the transient resistance for each cell"
  extends Interface.partialAggFunction;
  import SI = Modelica.SIunits;

  input Data.Records.StepResponse steRes;
  input Data.Records.Geometry geo;
  input Data.Records.Soil soi;
  input Data.Records.ShortTermResponse shoTerRes;

  input Integer[q_max,p_max] nuMat "number of pulse at the end of each cells";

  input Modelica.SIunits.Temperature TSteSta "steady state temperature";

  output Real[q_max,p_max] kappaMat "transient resistance for each cell";

protected
  Integer q_pre;
  Integer p_pre;

algorithm
  for q in 1:q_max loop
    for p in 1:p_max loop
      if q == 1 and p == 1 then
        kappaMat[q, p] := (GroundHX.HeatCarrierFluidStepTemperature(
          t_d=nuMat[q, p],
          steRes=steRes,
          geo=geo,
          soi=soi,
          shoTerRes=shoTerRes) - steRes.T_ini)/TSteSta;

      else
        (q_pre,p_pre) := BaseClasses.previousCellIndex(
          q_max,
          p_max,
          q,
          p);

        kappaMat[q, p] := (GroundHX.HeatCarrierFluidStepTemperature(
          t_d=nuMat[q, p],
          steRes=steRes,
          geo=geo,
          soi=soi,
          shoTerRes=shoTerRes) - GroundHX.HeatCarrierFluidStepTemperature(
          t_d=nuMat[q_pre, p_pre],
          steRes=steRes,
          geo=geo,
          soi=soi,
          shoTerRes=shoTerRes))/TSteSta;
      end if;
    end for;
  end for;

end transientFrac;
