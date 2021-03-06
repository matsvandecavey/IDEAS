within IDEAS.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_dp_DerivativeCheck
  "Model that checks the correct implementation of the 1st order derivative of the flow function"
  extends Modelica.Icons.Example;

  constant Real gain = 2 "Gain for computing the mass flow rate";

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.SIunits.MassFlowRate m_flow_turbulent = 0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  Modelica.SIunits.MassFlowRate m_flow_comp "Comparison value for m_flow";
  Modelica.SIunits.Pressure dp "Pressure drop";
  Modelica.SIunits.MassFlowRate err "Integration error";
initial equation
 m_flow = m_flow_comp;
equation
  dp = time*gain;
  m_flow = IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
    dp=dp,
    k=  k,
    m_flow_turbulent=m_flow_turbulent);
  der(m_flow) = der(m_flow_comp);
  err = m_flow-m_flow_comp;
  assert(abs(err) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-08),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_dp_DerivativeCheck.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and its first order derivative
<a href=\"modelica://IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der\">
IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BasicFlowFunction_dp_DerivativeCheck;
