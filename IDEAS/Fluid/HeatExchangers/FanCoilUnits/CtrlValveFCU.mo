within IDEAS.Fluid.HeatExchangers.FanCoilUnits;
block CtrlValveFCU
  "4 step control for FCU (corresponding to position number (opening) 0 (0), 1 (0.5), 2 (0.75), 3 (1)). Step 0 (off: temperature high enough: >= TSet + |uBound[0]|) - step 3 (max heating: temperature too low: < TSet)"
  extends Modelica.Blocks.Interfaces.SISO(y(start=0));
  Modelica.Blocks.Interfaces.RealOutput sigma "position opening"    annotation (Placement(transformation(extent={{100,30},{120,50}}, rotation=0)));

  parameter Boolean enableRelease=false
    "if true, an additional RealInput will be available for releasing the controller";
  parameter Real[3] uBou={-1,0,1}
    "deltaT = TAir - TSet: switching boundaries. deltaT>uBou[end] (+ hysteresis) --> off, deltaT<uBou[start] --> full on"
                                                                                                        annotation(evaluate=false);
  parameter Real hyst=0.5
    "Hysteresis, applies to each boundary when decreasing the heat emission (lower step)";
  Modelica.Blocks.Interfaces.RealInput release(start=0) = rel if enableRelease
    "if < 0.5, the controller is OFF"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Real rel
    "release, either 1 ,either from RealInput release if enableRelease is true";
  parameter Modelica.SIunits.Temperature TSet = 273.15+21;
  Modelica.SIunits.Temperature TZone;
  Modelica.SIunits.TemperatureDifference delta_T;
equation
  TZone = u;
  delta_T = TZone - TSet;

  if not enableRelease then
    rel = 1;
  end if;

  if noEvent(rel < 0.5) then
    y = 0;
    sigma = 0;
  else // release is on
    if noEvent(delta_T > uBou[3] + hyst) then
      // (going) below uBou[1], always off
      y = 0;
      sigma = 0;
    elseif noEvent(delta_T > uBou[3] and y < 0.5) then
      // below initiate step 1: stay off
      y = 0;
      sigma = 0;
    elseif noEvent(delta_T > uBou[2] + hyst) then
      // swith up to one, stay on one or switch down to one
      y = 1;
      sigma = 0.5;
    elseif noEvent(delta_T > uBou[2] and y < 1.5) then
      // below initiate step 2: stay in step 1
      y = 1;
      sigma = 0.5;
    elseif noEvent(delta_T > uBou[1] + hyst) then
      // swith up to 2, stay on 2 or switch down to 2
      y = 2;
      sigma = 0.75;
    elseif noEvent(delta_T > uBou[1] and y < 2.5) then
      // below initiate step 3: stay in step 2
      y = 2;
      sigma = 0.75;
    else
      // temperature short >0: stay or switch to 3
      y = 3;
      sigma = 1;
    end if; // u
  end if; // release
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Bitmap(extent={{-102,-102},{98,102}},  fileName="modelica://IDEAS/Images/Hysteresis_ctrl_FCU.png")}),
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
end CtrlValveFCU;
