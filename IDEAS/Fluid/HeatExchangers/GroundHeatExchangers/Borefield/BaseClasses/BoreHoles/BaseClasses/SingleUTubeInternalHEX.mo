within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model SingleUTubeInternalHEX
  "Internal part of a borehole for a U-Tube configuration"
  extends Interface.PartialBoreHoleInternalHEX;

  extends IDEAS.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFil_start,
    T2_start=TFil_start,
    final tau1=Modelica.Constants.pi*geo.rTub^2*adv.hSeg*rho1_nominal/
        m1_flow_nominal,
    final tau2=Modelica.Constants.pi*geo.rTub^2*adv.hSeg*rho2_nominal/
        m2_flow_nominal,
    final show_T=true,
    vol1(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal1,
      final V=m2_flow_nominal*tau2/rho2_nominal,
      final m_flow_small=m1_flow_small),
    redeclare final IDEAS.Fluid.MixingVolumes.MixingVolume vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final V=m1_flow_nominal*tau1/rho1_nominal,
      final m_flow_small=m2_flow_small));

  parameter Modelica.SIunits.Temperature TFil_start=adv.TFil0_start
    "Initial temperature of the filling material"
    annotation (Dialog(group="Filling material"));

  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-58,40},{-82,16}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-56,-40},{-80,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(
    final R=RCondGro_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-50,16},{-26,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(
    final R=RCondGro_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-48,-40},{-24,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(
    final R=Rgb_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{52,26},{76,50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(
    final R=Rgb_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{52,-40},{76,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg(
    final R=Rgg_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={20,2})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(final C=Co_fil/2, T(
        start=TFil_start)) "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-90,36},{-70,16}},
        rotation=0,
        origin={80,0})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(final C=Co_fil/2, T(
        start=TFil_start)) "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-90,-36},{-70,-16}},
        rotation=0,
        origin={80,6})));

protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cpFil=fill.c
    "Specific heat capacity of the filling material";
  final parameter Modelica.SIunits.ThermalConductivity kFil=fill.k
    "Thermal conductivity of the filling material";
  final parameter Modelica.SIunits.Density dFil=fill.d
    "Density of the filling material";

  parameter Modelica.SIunits.HeatCapacity Co_fil=dFil*cpFil*adv.hSeg*Modelica.Constants.pi
      *(geo.rBor^2 - 2*(geo.rTub + geo.eTub)^2)
    "Heat capacity of the whole filling material";

  parameter Modelica.SIunits.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";

  parameter Real Rgb_val(fixed=false);
  parameter Real Rgg_val(fixed=false);
  parameter Real RCondGro_val(fixed=false);
  parameter Real x(fixed=false);

public
  Modelica.Blocks.Sources.RealExpression RVol1(y=
    convectionResistance(
    hSeg=adv.hSeg,
    rBor=geo.rBor,
    rTub=geo.rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m1_flow,
    m_flow_nominal=adv.m_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Modelica.Blocks.Sources.RealExpression RVol2(y=
    convectionResistance(hSeg=adv.hSeg,
    rBor=geo.rBor,
    rTub=geo.rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m2_flow,
    m_flow_nominal=adv.m_flow_nominal))
    "Convective and thermal resistance at fluid 2"
     annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));

initial equation
  (Rgb_val, Rgg_val, RCondGro_val, x) =
    singleUTubeResistances(hSeg=adv.hSeg,
    rBor=geo.rBor,
    rTub=geo.rTub,
    eTub=geo.eTub,
    sha=geo.xC,
    kFil=fill.k,
    kSoi=soi.k,
    kTub=geo.kTub);

equation
  connect(vol1.heatPort, RConv1.fluid) annotation (Line(
      points={{-10,60},{-60,60},{-60,50},{-90,50},{-90,28},{-82,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv1.solid, Rpg1.port_a) annotation (Line(
      points={{-58,28},{-50,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg1.port_b, capFil1.port) annotation (Line(
      points={{-26,28},{-20,28},{-20,36},{0,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil1.port, Rgb1.port_a) annotation (Line(
      points={{0,36},{26,36},{26,38},{52,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil1.port, Rgg.port_a) annotation (Line(
      points={{0,36},{20,36},{20,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb1.port_b, port) annotation (Line(
      points={{76,38},{86,38},{86,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.solid, Rpg2.port_a) annotation (Line(
      points={{-56,-28},{-48,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg2.port_b, capFil2.port) annotation (Line(
      points={{-24,-28},{-12,-28},{-12,-30},{0,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.fluid, vol2.heatPort) annotation (Line(
      points={{-80,-28},{-86,-28},{-86,-46},{20,-46},{20,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil2.port, Rgb2.port_a) annotation (Line(
      points={{0,-30},{26,-30},{26,-28},{52,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg.port_b, capFil2.port) annotation (Line(
      points={{20,-10},{20,-30},{0,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb2.port_b, port) annotation (Line(
      points={{76,-28},{86,-28},{86,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RVol1.y, RConv1.Rc) annotation (Line(
      points={{-79,8},{-70,8},{-70,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RVol2.y, RConv2.Rc) annotation (Line(
      points={{-79,-8},{-68,-8},{-68,-16}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{100,100}}),
                        graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            100}}), graphics={Rectangle(
          extent={{88,54},{-88,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{88,-66},{-88,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Model for the heat transfer between the fluid and within the borehole filling. This model computes the dynamic response of the fluid in the tubes, and the heat transfer between the fluid and the borehole filling, and the heat storage within the fluid and the borehole filling. </p>
<p>This model computes the different thermal resistances present in a single-U-tube borehole using the method of Bauer et al. [1] and computing explicitely the <i>fluid-to-ground</i> thermal resistance <i>Rb</i> and the <i>grout-to-grout </i>resistance <i>Ra</i> as defined by Hellstroem [2] using the multipole method (BaseClasses.singleUTubeResistances). The convection resistance is calculated using the Dittus-Boelter correlation (see BaseClasses.convectionResistance).</p>
<p>The following figure shows the thermal network set up by Bauer et al. [1]</p>
<p><img src=\"modelica://DaPModels/Borefield/Boreholes/BaseClasses/Documentation/Bauer_singleUTube_small.PNG\"/></p>
<p><h4>References</h4></p>
<p>[1] G. Hellstr&ouml;m. <i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>. Dep. of Mathematical Physics, University of Lund, Sweden, 1991.</p>
<p>[2] D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. <i>Thermal resistance and capacity models for borehole heat exchangers</i>. INTERNATIONAL JOURNAL OF ENERGY RESEARCH, 35:312&ndash;320, 2010.</p>
</html>", revisions="<html>
<p><ul>
<li>January 2014, Damien Picard,<br/><i>First implementation.</i></li>
</ul></p>
</html>"));
end SingleUTubeInternalHEX;
