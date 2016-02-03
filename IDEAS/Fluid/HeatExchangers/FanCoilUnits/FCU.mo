within IDEAS.Fluid.HeatExchangers.FanCoilUnits;
model FCU
  import Buildings;
  extends IDEAS.Fluid.Interfaces.PartialTwoPort(
    redeclare package Medium=Water);
  replaceable package Water = IDEAS.Media.Water;
  replaceable package Air = IDEAS.Media.Air;

  parameter IDEAS.Fluid.HeatExchangers.FanCoilUnits.data.Generic FCU_characteristics annotation (Placement(
        transformation(extent={{-84,70},{-64,90}})), choicesAllMatching);

  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU heaCoi(
    redeclare package Medium1 = Water,
    redeclare package Medium2 = Air,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=FCU_characteristics.m_flow_nominal_water,
    m2_flow_nominal=FCU_characteristics.m_flow_nominal_air,
    Q_flow_nominal=FCU_characteristics.QNom,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    T_a1_nominal=FCU_characteristics.TWater_in_nominal,
    T_a2_nominal=FCU_characteristics.TAir_in_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-6})));

  // Control
  IDEAS.Fluid.Actuators.Valves.TwoWayTable val(
    redeclare package Medium = Water,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    m_flow_nominal=FCU_characteristics.m_flow_nominal_water,
    Kv=FCU_characteristics.Kv_nominal,
    flowCharacteristics=IDEAS.Fluid.Actuators.Valves.Data.Generic(y=
        FCU_characteristics.y, phi=FCU_characteristics.phi),
    from_dp=from_dp)                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));
  IDEAS.Fluid.HeatExchangers.FanCoilUnits.CtrlValveFCU ctrlValveFCU(
      enableRelease=enableRelease, uBou={-FCU_characteristics.dTSet,0,
        FCU_characteristics.dTSet})
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Blocks.Interfaces.RealInput release if enableRelease
    "if < 0.5, the FCU is OFF"
    annotation (Placement(transformation(extent={{-123,-100},{-83,-60}}),
        iconTransformation(extent={{-123,-100},{-83,-60}})));

  // Air flow
  IDEAS.Fluid.Sources.MassFlowSource_T m_flow_in_air(
    redeclare package Medium = Air,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,-40})));
  IDEAS.Fluid.Sensors.EnthalpyFlowRate senEntFlo_in(redeclare package Medium =
        Air, m_flow_nominal=FCU_characteristics.m_flow_nominal_air)
                                      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={28,-40})));
  IDEAS.Fluid.Sensors.EnthalpyFlowRate senEntFlo_out(redeclare package Medium
      = Air, m_flow_nominal=FCU_characteristics.m_flow_nominal_air) annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-40})));
  IDEAS.Fluid.Sources.Boundary_pT airBou(nPorts=1, redeclare package Medium =
        Air) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-61,-40})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=heatPortCon.T)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-44})));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    table=[FCU_characteristics.position,cat(
        1,
        {max(FCU_characteristics.m_flow[1], 1E-8)},
        {FCU_characteristics.m_flow[i] for i in 2:size(FCU_characteristics.m_flow, 1)})])
    annotation (Placement(transformation(extent={{46,-86},{66,-66}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=ctrlValveFCU.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={26,-76})));

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  // Heat flow
  parameter Real fractionRad=FCU_characteristics.fractionRad;
  Modelica.SIunits.HeatFlowRate Q_flow_total;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon
    "Convective heat transfer from radiators" annotation (Placement(
        transformation(extent={{40,90},{60,110}}), iconTransformation(extent={{40,
            108},{60,128}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad
    "Radiative heat transfer from radiators" annotation (Placement(
        transformation(extent={{80,90},{100,110}}), iconTransformation(extent={{
            80,108},{100,128}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowCon
    "convective part of the emitted heat (1-fractionRad)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,70})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowRad
    "Radiative part of the emitted heat (fractionRad)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,50})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_total*(1 -
        fractionRad))
    annotation (Placement(transformation(extent={{-40,60},{0,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=Q_flow_total*
        fractionRad)
    annotation (Placement(transformation(extent={{-40,40},{0,60}})));

  Modelica.Blocks.Sources.RealExpression Delta_T_short(y=heatPortCon.T)
    "Increase in degrees needed to reach the set point temperature" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,20})));
  parameter Boolean enableRelease=false
    "if true, an additional RealInput will be available for releasing the controller";
  parameter Modelica.SIunits.Temperature TSet=273.15 + 21;
equation
  Q_flow_total = -1*(senEntFlo_out.H_flow - senEntFlo_in.H_flow)
    "Net FCU-emitted(hence negative sign) entropy gain";
  connect(port_a, val.port_a)
    annotation (Line(points={{-100,0},{-75,0},{-50,0}}, color={0,127,255}));
  connect(val.port_b, heaCoi.port_a1)
    annotation (Line(points={{-30,0},{-25,0},{-20,0}}, color={0,127,255}));
  connect(ctrlValveFCU.sigma, val.y)
    annotation (Line(points={{-49,24},{-40,24},{-40,12}}, color={0,0,127}));
  connect(heaCoi.port_a2, senEntFlo_in.port_b) annotation (Line(points={{0,-12},
          {10,-12},{10,-40},{18,-40}}, color={0,127,255}));
  connect(m_flow_in_air.ports[1], senEntFlo_in.port_a)
    annotation (Line(points={{46,-40},{46,-40},{38,-40}}, color={0,127,255}));
  connect(heaCoi.port_b2, senEntFlo_out.port_a) annotation (Line(points={{-20,-12},
          {-20,-40},{-30,-40}}, color={0,127,255}));
  connect(senEntFlo_out.port_b, airBou.ports[1])
    annotation (Line(points={{-50,-40},{-54,-40}}, color={0,127,255}));
  connect(heatFlowCon.Q_flow, realExpression.y)
    annotation (Line(points={{20,70},{2,70}}, color={0,0,127}));
  connect(heatFlowRad.Q_flow, realExpression1.y)
    annotation (Line(points={{20,50},{2,50}}, color={0,0,127}));
  connect(heatFlowCon.port, heatPortCon)
    annotation (Line(points={{40,70},{50,70},{50,100}}, color={191,0,0}));
  connect(heatFlowRad.port, heatPortRad)
    annotation (Line(points={{40,50},{90,50},{90,100}}, color={191,0,0}));
  connect(heaCoi.port_b1, port_b)
    annotation (Line(points={{0,0},{100,0}},         color={0,127,255}));
  connect(release, ctrlValveFCU.release) annotation (Line(points={{-103,-80},{-74,
          -80},{-74,4},{-60,4},{-60,8}}, color={0,0,127}));
  connect(m_flow_in_air.T_in, realExpression2.y)
    annotation (Line(points={{68,-44},{79,-44}}, color={0,0,127}));
  connect(combiTable1D.y[1], m_flow_in_air.m_flow_in) annotation (Line(points={{
          67,-76},{76,-76},{76,-48},{66,-48}}, color={0,0,127}));
  connect(realExpression3.y, combiTable1D.u[1])
    annotation (Line(points={{37,-76},{44,-76}}, color={0,0,127}));
  connect(Delta_T_short.y, ctrlValveFCU.u)
    annotation (Line(points={{-79,20},{-72,20}}, color={0,0,127}));
 annotation (
    Placement(transformation(extent={{-80,78},{-60,98}})),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}}), graphics={Bitmap(
            extent={{-96,-92},{102,132}}, fileName="modelica://IDEAS/Images/IconFCU.png")}),
    Documentation(info="<html>
<p>The models simulates a fan coil unit with a temperature controlled operating regime. It can switch from fully closed valve and no fan to fully open valve with a fan blowing air.</p>
<p>The parameters of the FCU&apos;s operating regime are specified in a data record. </p>
<p>More specifically:</p>
<ul>
<li>fan &apos;s air mass flow rate (m_flow), </li>
<li>valve phi values (indicating Kv(postion)/Kv(fully open)). This gives a Kv value for every valve position and thus links the water mass flow rate with the pressure drop over the FCU.</li>
</ul>
<h4><span style=\"color: #008000\">Assumptions</span></h4>
<ul>
<li>no electrical power for the fan implemented (can be up to 75W).</li>
<li>the pressure drop characteristic for the FCU is lumped in the valve and represented by the Kv_nominal value and phi. The pressure drop values in the data record are based upon pressure and massflow measurements <span style=\"font-family: MS Shell Dlg 2;\">the datasheets for</span> the operating regimes.</li>
<li>the fractionRad for radiative heating is calcualted from the difference between measred air-side heat flow and water-side heat flow which are both in the datasheet.</li>
<li>cross flow of mixed air over the hot coil.</li>
<li>hysteresis controller with 0.5K overflow on both sides.</li>
</ul>
</html>"));
end FCU;
