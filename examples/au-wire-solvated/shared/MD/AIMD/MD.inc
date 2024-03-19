   &MD
     TEMP_TOL 10
     ENSEMBLE  NVT
     STEPS  10000
     TIMESTEP     0.5
     ECONS_START_VAL     5.3102998044228311E+00
     TEMPERATURE     3.0000000000000000E+02
     &THERMOSTAT
       TYPE  CSVR
       &CSVR
        #TIMECON     9.9999999999999966E+02
	 TIMECON     10
         &THERMOSTAT_ENERGY
               7.6029995702320035E+00
         &END THERMOSTAT_ENERGY
         &RNG_INIT
Wiener process for Thermostat # 1        1 F T F  -6.2150427652468987E-01        1994874840.0        3367805833.0        2886187475.0        1699717299.0        3129889731.0        2549555414.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0             12345.0
         &END RNG_INIT
       &END CSVR
     &END THERMOSTAT
     &PRINT
       &ENERGY  ON
         &EACH
           MD  10
         &END EACH
       &END ENERGY
     &END PRINT
   &END MD
