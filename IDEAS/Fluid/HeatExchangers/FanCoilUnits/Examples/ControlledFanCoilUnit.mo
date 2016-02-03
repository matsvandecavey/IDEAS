within IDEAS.Fluid.HeatExchangers.FanCoilUnits.Examples;
model ControlledFanCoilUnit
  import Buildings;
  replaceable package Medium = Media.Water;

  parameter Modelica.SIunits.Power Q_flow_nominal = 500 "Nominal power";
  parameter Modelica.SIunits.Temperature T_a_nominal=313.15
    "Radiator inlet temperature at nominal condition";
  parameter Modelica.SIunits.Temperature T_b_nominal = 303.15
    "Radiator outlet temperature at nominal condition";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/(T_a_nominal-T_b_nominal)/Medium.cp_const
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  IDEAS.Fluid.Sources.Boundary_pT             sou(
    nPorts=2,
    redeclare package Medium = Medium,
    use_p_in=true,
    T=T_a_nominal)
    annotation (Placement(transformation(extent={{-54,-58},{-34,-38}})));
  IDEAS.Fluid.FixedResistances.FixedResistanceDpM       res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{44,-60},
            {64,-40}})));
  IDEAS.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{44,21},
            {64,41}})));
  IDEAS.Fluid.Sources.Boundary_pT             sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 300000,
    T=T_b_nominal) "Sink"
    annotation (Placement(transformation(extent={{100,-58},{80,-38}})));
  IDEAS.Fluid.HeatExchangers.FanCoilUnits.FCU fcu1(redeclare package Medium = Medium, FCU_characteristics=
        IDEAS.Fluid.HeatExchangers.FanCoilUnits.data.FCU_31()) "Radiator"
    annotation (Placement(transformation(extent={{0,22},{20,42}})));
  IDEAS.Fluid.HeatExchangers.FanCoilUnits.FCU FCU2(
    redeclare package Medium = Medium,
    redeclare package Water = Medium,
    FCU_characteristics=IDEAS.Fluid.HeatExchangers.FanCoilUnits.data.FCU_22())
    "Radiator" annotation (Placement(transformation(extent={{0,-59},{20,-39}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TBCCon1
    annotation (Placement(transformation(extent={{-22,38},{-10,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TBCCon2
    annotation (Placement(transformation(extent={{-22,-30},{-10,-18}})));
  Modelica.Blocks.Sources.Step step(
    offset=300000 + dp_nominal,
    height=-dp_nominal,
    startTime=100000)
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TBCRad2
    annotation (Placement(transformation(extent={{-22,-10},{-10,2}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         TBCRad1
    annotation (Placement(transformation(extent={{-22,58},{-10,70}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=6,
    rising=1000,
    width=2000,
    falling=1500,
    period=6000,
    offset=273.15 + 18,
    startTime=500,
    nperiod=-1)
    annotation (Placement(transformation(extent={{-86,40},{-66,60}})));
  IDEAS.Fluid.Sensors.RelativeTemperature senRelTem(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{0,-83},{20,-63}})));
  IDEAS.Fluid.Sensors.RelativeTemperature senRelTem1(redeclare package Medium
      = Medium) annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(sou.ports[1],fcu1. port_a) annotation (Line(
      points={{-34,-46},{-30,-46},{-30,31.0909},{0,31.0909}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2],FCU2. port_a) annotation (Line(
      points={{-34,-50},{-18,-50},{-18,-49.9091},{0,-49.9091}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(FCU2.port_b,res2. port_a) annotation (Line(
      points={{20,-49.9091},{26,-49.9091},{26,-50},{44,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b,sin. ports[1]) annotation (Line(
      points={{64,31},{66,31},{66,-46},{80,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b,sin. ports[2]) annotation (Line(
      points={{64,-50},{80,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y,sou. p_in) annotation (Line(
      points={{-69,-40},{-56,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBCRad2.port,FCU2. heatPortRad) annotation (Line(
      points={{-10,-4},{19,-4},{19,-39.1818}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCRad1.port,fcu1. heatPortRad) annotation (Line(
      points={{-10,64},{19,64},{19,41.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCCon2.port,FCU2. heatPortCon) annotation (Line(
      points={{-10,-24},{15,-24},{15,-39.1818}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCCon1.port,fcu1. heatPortCon) annotation (Line(
      points={{-10,44},{15,44},{15,41.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(trapezoid.y, TBCRad1.T) annotation (Line(points={{-65,50},{-36,50},{-36,
          64},{-23.2,64}}, color={0,0,127}));
  connect(trapezoid.y, TBCCon1.T) annotation (Line(points={{-65,50},{-36,50},{-36,
          44},{-23.2,44}}, color={0,0,127}));
  connect(trapezoid.y, TBCRad2.T) annotation (Line(points={{-65,50},{-52,50},{-52,
          -4},{-23.2,-4}}, color={0,0,127}));
  connect(trapezoid.y, TBCCon2.T) annotation (Line(points={{-65,50},{-52,50},{-52,
          -24},{-23.2,-24}}, color={0,0,127}));
  connect(senRelTem.port_a, FCU2.port_a) annotation (Line(points={{0,-73},{-12,
          -73},{-12,-49.9091},{0,-49.9091}},
                                        color={0,127,255}));
  connect(senRelTem.port_b, res2.port_a) annotation (Line(points={{20,-73},{26,-73},
          {26,-50},{44,-50}}, color={0,127,255}));
  connect(senRelTem1.port_a, fcu1.port_a) annotation (Line(points={{0,10},{-4,
          10},{-4,31.0909},{0,31.0909}},
                                     color={0,127,255}));
  connect(senRelTem1.port_b, fcu1.port_b) annotation (Line(points={{20,10},{26,
          10},{26,31.0909},{20,31.0909}},
                                      color={0,127,255}));
  connect(fcu1.port_b, res1.port_a) annotation (Line(points={{20,31.0909},{44,
          31.0909},{44,31}},
                    color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlledFanCoilUnit;
