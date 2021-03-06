within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles;
model SingleBoreHoles2UTubeInSerie_save
  "Double U-tube borehole heat exchanger model. If more than one borehole is given, they are assumed to be connected in series"

  extends Interface.PartialSingleBoreHole(m_flow_nominal = gen.m_flow_nominal_bh,T_start=gen.T_start,dp_nominal=gen.dp_nominal);
  replaceable BaseClasses.SingleBoreHole2UTube[gen.nbSer] borHol(
    each final m_flow_nominal=m_flow_nominal,
    each final T_start=T_start,
    each final dp_nominal=dp_nominal,
    each final soi=soi,
    each final fil=fil,
    each final gen=gen,
    each final show_T=show_T,
    each final computeFlowResistance=computeFlowResistance,
    each final from_dp=from_dp,
    each final linearizeFlowResistance=linearizeFlowResistance,
    each final deltaM=deltaM,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final X_start=X_start,
    each final C_start=C_start,
    redeclare each final package Medium = Medium,
    each final C_nominal=C_nominal,
    each final dynFil=dynFil,
    each final mSenFac=mSenFac,
    each final use_TWall=use_TWall)                       constrainedby
    Interface.PartialSingleBoreHole(
    each m_flow_nominal=m_flow_nominal,
    each T_start=T_start,
    each dp_nominal=dp_nominal,
    redeclare each package Medium = Medium,
    each soi=soi,
    each fil=fil,
    each gen=gen,
    each show_T=show_T,
    each computeFlowResistance=computeFlowResistance,
    each from_dp=from_dp,
    each linearizeFlowResistance=linearizeFlowResistance,
    each deltaM=deltaM,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each p_start=p_start,
    each X_start=X_start,
    each C_start=C_start,
    each C_nominal=C_nominal,
    each  dynFil=dynFil,
    each  mSenFac=mSenFac,
    each use_TWall=use_TWall) "Borehole heat exchanger" annotation (Placement(
        transformation(extent={{-16,-16},{16,16}}, rotation=0)),
      choicesAllMatching=true);

equation
  assert(not gen.singleUTube, "This borefield model is for double U-Tube configuration but you chose single U-Tube configuration in the general borefield record.");

  annotation (
    Dialog(group="Borehole"),
    Dialog(group="Borehole"),
    defaultComponentName="borehole",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{-68,60},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-40,60},{-32,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{32,60},{40,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{60,60},{68,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-40,-72},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{60,-72},{40,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-56,68},{-52,-72}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,68},{-44,-72}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{52,68},{56,-72}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,68},{48,-72}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-33,66},
          rotation=90),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={33,66},
          rotation=90),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={67,66},
          rotation=90),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-67,66},
          rotation=90),
        Line(
          points={{0,80},{-20,20},{0,-40},{-12,-82},{-12,-82}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{12,80},{-8,20},{12,-40},{0,-82},{0,-82}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Text(
          extent={{-30,102},{38,66}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          textString="nbSer")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString=""),Text(
          extent={{50,-32},{90,-38}},
          lineColor={0,0,255},
          textString="")}),
    Documentation(info="<html>
<p>
Model of a single U-tube borehole heat exchanger. 
The borehole heat exchanger is vertically discretized into <i>n<sub>seg</sub></i>
elements of height <i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
segment contains a model for the heat transfer in the borehole, 
for heat transfer in the soil and for the far-field boundary condition.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer coefficient
that depends on the fluid velocity, a heat resistance between the two pipes, and
a heat resistance between the pipes and the circumference of the borehole.
The heat capacity of the fluid, and the heat capacity of the grout, is taken into account.
All thermal mass is assumed to be at the two bulk temperatures of the down-flowing 
and up-flowing fluid.
</p>
<p>
The heat transfer in the soil is computed using transient heat conduction in cylindrical
coordinates for the spatial domain <i>r<sub>bor</sub> &le; r &le; r<sub>ext</sub></i>. 
In the radial direction, the spatial domain is discretized into 
<i>n<sub>hor</sub></i> segments with uniform material properties.
Thermal properties can be specified separately for horizontal layer.
The vertical heat flow is assumed to be zero, and there is assumed to be 
no ground water flow. 
</p>
<p>
The far-field temperature, i.e., the temperature at the radius 
<i>r<sub>ext</sub></i>, is computed using a power-series solution
to a line-source heat transfer problem. This temperature boundary condition
is updated every <i>t<sub>sample</sub></i> seconds.
</p>
<p>
The initial far-field temperature <i>T<sub>ext,start</sub></i>, which
is the temperature of the soil at a radius <i>r<sub>ext</sub></i>,
is computed 
as a function of the depth <i>z &gt; 0</i>. 
For a depth between <i>0 &le; z &le; z<sub>0</sub></i>, the temperature
is set to <i>T<sub>ext,0,start</sub></i>. 
The value of <i>z<sub>0</sub></i> is a parameter with a default of 10 meters.
However, there is large variability in the depth where the undisturbed soil temperature
starts.
For a depth of <i>z<sub>0</sub> &le; z &le; h<sub>bor</sub></i>,
the temperature is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  T<sup>i</sup><sub>ext,start</sub> = T<sub>ext,0,start</sub> + (z<sup>i</sup> - z<sub>0</sub>)  dT &frasl; dz
</p>
with <i>i &isin; {1, ..., n<sub>ver</sub>}</i>,
where the temperature gradient <i>dT &frasl; dz &ge; 0</i> is a parameter.
As with <i>z<sub>0</sub></i>, there is large variability in 
<i>dT &frasl; dz &ge; 0</i>. The default value is set to <i>1</i> Kelvin per 100 meters.
For the temperature of the grout, the same equations are applied, with
<i>T<sub>ext,0,start</sub></i> replaced with
<i>T<sub>fil,0,start</sub></i>, and 
<i>T<sup>i</sup><sub>ext,start</sub></i> replaced with
<i>T<sup>i</sup><sub>fil,start</sub></i>. 
The default setting uses the same temperature for the soil and the filling material.
</p>
<h4>Implementation</h4>
<p>
horizontal layer is modeled using an instance of
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.BoreholeSegment\">
IDEAS.HeatExchangers.Fluid.Boreholes.BaseClasses.BoreholeSegment</a>.
This model is composed of the model
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement\">
IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement</a> which computes
the heat transfer in the pipes and the borehole filling,
of the model
<a href=\"modelica://IDEAS.HeatTransfer.Conduction.SingleLayerCylinder\">
IDEAS.HeatTransfer.Conduction.SingleLayerCylinder</a> which computes
the heat transfer in the soil, and
of the model
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.TemperatureBoundaryCondition\">
IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.TemperatureBoundaryCondition</a> which computes
the far-field temperature boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end SingleBoreHoles2UTubeInSerie_save;
