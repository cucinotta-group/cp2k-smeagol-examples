&MOTION
  &CELL_OPT
    OPTIMIZER BFGS
    CONSTRAINT XY
    KEEP_ANGLES .TRUE.
    KEEP_SYMMETRY .TRUE.
    TYPE DIRECT_CELL_OPT
  &END CELL_OPT
  &CONSTRAINT
  	&FIXED_ATOMS
   	COMPONENTS_TO_FIX XYZ
    	LIST 1..36
  	&END FIXED_ATOMS
  &END CONSTRAINT
  &PRINT
   &TRAJECTORY
     &EACH
    	CELL_OPT 1
     &END EACH
   &END TRAJECTORY
  &END PRINT
&END MOTION