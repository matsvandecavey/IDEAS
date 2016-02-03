within IDEAS.Fluid.HeatExchangers.FanCoilUnits.data;
record Generic "Generic record for FanCoilUnit parameters"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Power QNom = m_flow_nominal_water*4180*(TWater_in_nominal - TWater_out_nominal)
    "Nominal thermal power at the specified conditions";
  parameter SI.MassFlowRate m_flow_nominal_water=0.0269
    "Nominal mass flow rate";
  parameter SI.MassFlowRate m_flow_nominal_air=0.108 "Nominal mass flow rate";

  parameter Modelica.SIunits.Mass mMedium=1.3
    "Mass of medium (water) in the FCU";
  parameter Modelica.SIunits.Mass mDry=3
    "Mass of dry material (steel/aluminium) in the FCU";

  parameter Modelica.SIunits.Temperature TWater_in_nominal=50 + 273.15
    "Nominal inlet temperature";
  parameter Modelica.SIunits.Temperature TWater_out_nominal=40 + 273.15
    "Nominal outlet temperature";
  parameter Modelica.SIunits.Temperature TAir_in_nominal=21 + 273.15
    "Nominal inlet temperature";
  parameter Modelica.SIunits.Temperature TAir_out_nominal=31 + 273.15
    "Nominal inlet temperature";

  parameter Modelica.SIunits.TemperatureDifference dTSet=1
    "trigger temperature difference";
  parameter Modelica.SIunits.Temperature TSet = 273.15 + 22
    "End heating temperature setpoint";
  parameter Real Kv_nominal = 0.5
    "Flow coefficient of valve, k=m_flow/sqrt(dp), with unit=(m3/h/(bar^(1/2))).";
  parameter Real fractionRad = 0.16 "Fraction of the heat which is emitted as radiant heat. 
   Determined from datasheet measurements: measured heat on waterside was larger then measured heat on air side. The ratio is explained by radiant heat losses.";
  parameter Real position[:] = {0,1,2,3} "Operations levels levels of the FCU";
  parameter Real m_flow[size(position,1)] = {0.0,0.054,0.074,0.108}
    "Air mass_flow rates by the fan";
  parameter Real y[size(position,1)] = {0,0.5,0.75,1}
    "Valve opening. The exact valve opening is not known from the datasheets.";
  parameter Real phi[size(position,1)] = {0.0001, 0.93, 0.96, 1} "ratio to determine KV from Kv nominal.
  Kv[position]/Kv[valve open]. Kv = m_flow/sqrt(p) [m3/s/(bar)^(1/2)]";

  annotation (
defaultComponentName="datVal",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This is a generic record for the normalized volume flow
rates for different valve opening positions.
See the documentation of
<a href=\"modelica://IDEAS.Fluid.Actuators.Valves.Data\">
IDEAS.Fluid.Actuators.Valves.Data</a>
for how to use this record.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 12, 2014, by Michael Wetter:<br/>
Added annotation <code>defaultComponentPrefixes=\"parameter\"</code>
so that the <code>parameter</code> keyword is added when dragging
the record into a model.
</li>
<li>
March 27, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
