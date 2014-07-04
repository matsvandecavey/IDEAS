within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples;
model SingleBoreHoleSerStepLoad "SingleBoreHoleSer with step input load "
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  redeclare replaceable parameter Data.Records.StepResponse steRes=
      Data.StepResponse.example_accurate() "generic step load parameter"
    annotation (Placement(transformation(extent={{-18,-76},{-8,-66}})));
  redeclare replaceable parameter Data.Records.Advanced adv=
      Data.Advanced.example() "Advanced parameters"
    annotation (Placement(transformation(extent={{-2,-76},{8,-66}})));
  redeclare replaceable parameter Data.Records.Soil soi=
      Data.SoilData.example()
    annotation (Placement(transformation(extent={{14,-76},{24,-66}})));
  redeclare replaceable parameter Data.Records.Filling fill=
      Data.FillingData.example() "Thermal properties of the filling material"
    annotation (Placement(transformation(extent={{30,-76},{40,-66}})));
  redeclare replaceable parameter Data.Records.Geometry geo=
      Data.GeometricData.example() "Geometric charachteristic of the borehole"
    annotation (Placement(transformation(extent={{46,-76},{56,-66}})));

  SingleBoreHolesInSerie borHolSer(
    redeclare each package Medium = Medium,
    soi=soi,
    fill=fill,
    geo=geo,
    adv=adv,
    dp_nominal=10000,
    m_flow_nominal=steRes.m_flow,
    T_start=steRes.T_ini) "Borehole heat exchanger" annotation (Placement(
        transformation(extent={{-12,-50},{12,-26}}, rotation=0)));

  IDEAS.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{22,-34},{34,-22}})));

  Modelica.Blocks.Sources.Step step(height=1)
    annotation (Placement(transformation(extent={{48,-18},{36,-6}})));

  IDEAS.Fluid.HeatExchangers.HeaterCoolerPrescribed hea(
    redeclare package Medium = Medium,
    m_flow_nominal=steRes.m_flow,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow(start=steRes.m_flow),
    T_start=steRes.T_ini,
    Q_flow_nominal=steRes.q_ste*geo.hBor*geo.nbSer,
    p_start=100000)
    annotation (Placement(transformation(extent={{26,10},{6,-10}})));
  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-50,-24},{-38,-12}})));
  Movers.Pump                           pum(
    redeclare package Medium = Medium,
    m_flow_nominal=steRes.m_flow,
    m_flow(start=steRes.m_flow),
    T_start=steRes.T_ini,
    useInput=true)
    annotation (Placement(transformation(extent={{-12,10},{-32,-10}})));

equation
  connect(pum.port_b, borHolSer.port_a) annotation (Line(
      points={{-32,0},{-58,0},{-58,-38},{-12,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-12,0},{6,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, borHolSer.port_b) annotation (Line(
      points={{26,0},{56,0},{56,-38},{12,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{26,0},{56,0},{56,-28},{34,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, hea.u) annotation (Line(
      points={{35.4,-12},{34,-12},{34,-6},{28,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flowSet) annotation (Line(
      points={{-37.4,-18},{-22,-18},{-22,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                   graphics),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
<p>

</p>
</html>", revisions="<html>
<ul>
</ul>
</html>"),
    experiment(
      StopTime=3.1536e+007,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
        graphics));
end SingleBoreHoleSerStepLoad;
