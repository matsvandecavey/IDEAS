within IDEAS.Fluid.HeatExchangers.FanCoilUnits.Archive;
block CtrlValveFCU_TSet
  "4 step control for FCU (corresponding to position number (opening) 0 (0), 1 (0.5), 2 (0.75), 3 (1)). Step 0 (off: temperature high enough: >= TSet + |uBound[0]|) - step 3 (max heating: temperature too low: < TSet)"
  extends Modelica.Blocks.Interfaces.SISO(y(start=0));
  Modelica.Blocks.Interfaces.RealOutput sigma "position opening"    annotation (Placement(transformation(extent={{100,30},{120,50}}, rotation=0)));

  parameter Boolean enableRelease=false
    "if true, an additional RealInput will be available for releasing the controller";
  parameter Real[3] uBou={-1,0,1}
    "TSet - TAir switching boundaries. if under TSet: full on (step 3)"                                annotation(evaluate=false);
  parameter Real hyst=0.5
    "Hysteresis, applies to each boundary when going to lower steps";
  Modelica.Blocks.Interfaces.RealInput release(start=0) = rel if enableRelease
    "if < 0.5, the controller is OFF"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Real rel
    "release, either 1 ,either from RealInput release if enableRelease is true";
  parameter Modelica.SIunits.Temperature TSet = 273.15+21;
  Modelica.SIunits.TemperatureDifference delta_T;
equation
  delta_T = u - TSet;
  if not enableRelease then
    rel = 1;
  end if;

  if noEvent(rel < 0.5) then
    y = 0;
    sigma = 0;
  else // release is on
    if noEvent(delta_T < uBou[1]) then
      // measured temperature (u) much lower than TSet, stay or increase to full power (3).
      y = 3;
      sigma = 1;
    elseif noEvent(delta_T < uBou[1] + hyst) then
      if noEvent(y > 2.5) then
        // in step 3, with sufficient heating need, stay in 3.
        y = 3;
        sigma = 1;
      else
        // step 2
        y = 2;
        sigma = 0.75;
      end if;
    elseif noEvent(delta_T < uBou[2]) then
      // Measured temp (u) lower than TSet, stay or increase to 2.
      y = 2;
      sigma = 0.75;
    elseif noEvent(delta_T < uBou[2] +hyst) then
      if noEvent(y>1.5) then
        // in step 2, with sufficient heating need, stay in 2.
        y = 2;
        sigma = 0.75;
      else
        // step one.
        y = 1;
        sigma = 0.5;
      end if;
    elseif noEvent(delta_T < uBou[3]) then
      // in step 1, stay in 1.
      y = 1;
      sigma = 0.5;
    elseif noEvent(delta_T < uBou[3] + hyst) then
       if noEvent(y > 0.5) then
        // in step 1: stay or increase to step 1.
        y = 1;
        sigma = 0.5;
       else
        // step 0.
        y = 0;
        sigma = 0;
       end if;
    else
        y = 0;
        sigma = 0;
    end if; // u
  end if; // release
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Bitmap(extent={{-100,-104},{100,100}}, fileName="modelica://IDEAS/Images/Hysteresis_ctrl_FCU.png")}),
    Documentation(info="<HTML>
<p>
This block transforms a <b>Real</b> input signal into a <b>Boolean</b>
output signal:
</p>
<ul>
<li> When the output was <b>false</b> and the input becomes
     <b>greater</b> than parameter <b>uHigh</b>, the output
     switches to <b>true</b>.</li>
<li> When the output was <b>true</b> and the input becomes
     <b>less</b> than parameter <b>uLow</b>, the output
     switches to <b>false</b>.</li>
</ul>
<p>
The start value of the output is defined via parameter
<b>pre_y_start</b> (= value of pre(y) at initial time).
The default value of this parameter is <b>false</b>.
</p>
</HTML>
",revisions="<html>
<ul>
<li>
May 13, 2014, by Damien Picard:<br/>
Add possibility to use parameters as boundary values instead of inputs.
</li>
</ul>
</html>"));
end CtrlValveFCU_TSet;
