within IDEAS.Electric.Battery.Examples;
model TestBattery_only
  // Test the charging and discharging of a battery

  Modelica.SIunits.Power Pnet;

  BatterySystemGeneral batterySystemGeneral(
    redeclare IDEAS.Electric.Data.Batteries.LiIon technology,
    SoC_start=0.6,
    Pnet=Pnet,
    EBat=10) annotation (Placement(transformation(extent={{56,66},{76,86}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1500,
    startTime=2700,
    height=-8000)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=4000,
    duration=1500,
    startTime=600)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  BaseClasses.WattsLaw wattsLaw
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Math.Add3 add3_1
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    height=4000,
    duration=1500,
    startTime=4800)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=8000,
    rising=1000,
    width=5000,
    falling=1500,
    period=9000,
    nperiod=-1)
    annotation (Placement(transformation(extent={{-40,72},{-20,92}})));
  Modelica.Blocks.Interfaces.RealOutput y1 "Connector of Real output signals"
    annotation (Placement(transformation(extent={{2,90},{22,110}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-20})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
equation
  Pnet = trapezoid.y;
  connect(const.y, wattsLaw.Q) annotation (Line(
      points={{-19,20},{-10,20},{-10,52},{0.2,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, add3_1.u1) annotation (Line(
      points={{-59,90},{-50,90},{-50,58},{-42,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, add3_1.u2) annotation (Line(
      points={{-59,50},{-42,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y, add3_1.u3) annotation (Line(
      points={{-59,10},{-50,10},{-50,42},{-42,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(trapezoid.y, wattsLaw.P) annotation (Line(
      points={{-19,82},{-10,82},{-10,56},{0.2,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3_1.y, y1) annotation (Line(
      points={{-19,50},{-8,50},{-8,100},{12,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wattsLaw.vi[1], batterySystemGeneral.pin[1]) annotation (Line(
      points={{20,50},{28,50},{28,76},{56.4,76}},
      color={85,170,255},
      smooth=Smooth.None));
    connect(voltageSource.pin_p,ground. pin) annotation (Line(
        points={{80,-30},{80,-50}},
        color={85,170,255},
        smooth=Smooth.None));
  connect(voltageSource.pin_n, wattsLaw.vi[1]) annotation (Line(
      points={{80,-10},{80,50},{20,50}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end TestBattery_only;
