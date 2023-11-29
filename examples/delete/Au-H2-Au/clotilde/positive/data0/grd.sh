sed -i '/^ *MeshCutoff/Ia%block GridCellSampling\n  0.5  0.5   0.0\n  0.5  0.0   0.5\n  0.0  0.5   0.5\n%endblock GridCellSampling' mx.fdf
