within IDEAS.Fluid.HeatExchangers.FanCoilUnits.Archive;
block CtrlValveFCU
  "4 step control for FCU (corresponding to position number (opening) 0 (0), 1 (0.5), 2 (0.75), 3 (1)). Step 0 (off: temperature high enough: >= TSet + |uBound[0]|) - step 3 (max heating: temperature too low: < TSet)"
  extends Modelica.Blocks.Interfaces.SISO(y(start=0));
  Modelica.Blocks.Interfaces.RealOutput sigma "position opening"    annotation (Placement(transformation(extent={{100,30},{120,50}}, rotation=0)));

  parameter Boolean enableRelease=false
    "if true, an additional RealInput will be available for releasing the controller";
  parameter Real[3] uBou={-2,-1,0}
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

equation
  if not enableRelease then
    rel = 1;
  end if;

  if noEvent(rel < 0.5) then
    y = 0;
    sigma = 0;
  else // release is on
    if noEvent(u < uBou[1] - hyst) then
      // (going) below uBou[1], always off
      y = 0;
      sigma = 0;
    elseif noEvent(u < uBou[1] and y < 0.5) then
      // below initiate step 1: stay off
      y = 0;
      sigma = 0;
    elseif noEvent(u < uBou[2] - hyst) then
      // swith up to one, stay on one or switch down to one
      y = 1;
      sigma = 0.5;
    elseif noEvent(u < uBou[2] and y < 1.5) then
      // below initiate step 2: stay in step 1
      y = 1;
      sigma = 0.5;
    elseif noEvent(u < uBou[3] - hyst) then
      // swith up to 2, stay on 2 or switch down to 2
      y = 2;
      sigma = 0.75;
    elseif noEvent(u < uBou[3] and y < 2.5) then
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
            100}}), graphics={Polygon(
          points={{-65,89},{-73,67},{-57,67},{-65,89}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-65,67},{-65,-81}},
          color={192,192,192}),Line(points={{-90,-70},{82,-70}}, color={192,192,
          192}),Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Text(
          extent={{70,-80},{94,-100}},
          lineColor={160,160,164},
          textString="u"),Text(
          extent={{-65,93},{-12,75}},
          lineColor={160,160,164},
          textString="y"),Line(
          points={{-80,-70},{30,-70}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-50,10},{80,10}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-50,10},{-50,-70}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{30,10},{30,-70}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-10,-65},{0,-70},{-10,-75}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-10,15},{-20,10},{-10,5}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-55,-20},{-50,-30},{-44,-20}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{25,-30},{30,-19},{35,-30}},
          color={0,0,0},
          thickness=0.5),Text(
          extent={{-99,2},{-70,18}},
          lineColor={160,160,164},
          textString="true"),Text(
          extent={{-98,-87},{-66,-73}},
          lineColor={160,160,164},
          textString="false"),Text(
          extent={{19,-87},{44,-70}},
          lineColor={0,0,0},
          textString="uHigh"),Text(
          extent={{-63,-88},{-38,-71}},
          lineColor={0,0,0},
          textString="uLow"),Line(points={{-69,10},{-60,10}}, color={160,160,
          164})}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
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
