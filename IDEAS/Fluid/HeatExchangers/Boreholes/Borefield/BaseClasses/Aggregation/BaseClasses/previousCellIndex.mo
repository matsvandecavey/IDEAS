within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.Aggregation.BaseClasses;
function previousCellIndex
  "This function calculates the index [q,p] of the previous cell "
  extends Interface.partialAggFunction;

  input Integer q;
  input Integer p;
  output Integer q_pre;
  output Integer p_pre;

algorithm
  assert((q > 0 and p > 0) and (q > 1 or p > 1),
    "The choosen index is 1. No previous index is possible");
  assert((q <= q_max and p <= p_max),
    "The choosen index is out of the boundary.");

  if p == 1 then
    q_pre := q - 1;
    p_pre := p_max;
  else
    q_pre := q;
    p_pre := p - 1;
  end if;

end previousCellIndex;
