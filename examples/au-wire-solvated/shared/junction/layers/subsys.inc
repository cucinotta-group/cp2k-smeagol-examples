   &SUBSYS
     &KIND Au
       ELEMENT Au
       BASIS_SET ${BASIS_Au}
       POTENTIAL GTH-PBE-q11
     &END KIND
     &CELL
       A	${CELL_A}
       B	${CELL_B}
       C 	${CELL_C}
       MULTIPLE_UNIT_CELL 1 1 1
       PERIODIC XYZ       
     &END CELL
     @IF (${RTYPE}==ENERGY)
     @INCLUDE 'coord.inc'
     @ENDIF
     &TOPOLOGY
       MULTIPLE_UNIT_CELL 1 1 1
       @IF ( ${RTYPE} == GEO_OPT )
       COORD_FILE_FORMAT XYZ
       COORD_FILE_NAME ${COORD}
       @ENDIF
     &END TOPOLOGY
   &END SUBSYS

