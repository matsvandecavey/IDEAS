within IDEAS.Data.Materials;
record Air = IDEAS.Data.Interfaces.Material (
    k=0.0241,
    c=1008,
    rho=1.23,
    epsSw=0,
    epsLw=0,
    nState=1,
    gas=true,
    mhu=18.3*10e-6);