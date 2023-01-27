pts2d = meshbuilder(0:0.1:0.2, 0:0.1:0.2)
pts3d = meshbuilder(0:0.1:0.1, 0:0.1:0.1, 0:0.1:0.1)

rst2d = [0.0  0.0; 0.0  0.1; 0.0  0.2
         0.1  0.0; 0.1  0.1; 0.1  0.2
         0.2  0.0; 0.2  0.1; 0.2  0.2]
rst3d = [0.0  0.0  0.0; 0.0  0.1  0.0; 0.1  0.0  0.0; 0.1  0.1  0.0
         0.0  0.0  0.1; 0.0  0.1  0.1; 0.1  0.0  0.1; 0.1  0.1  0.1]

@test rst2d ≈ pts2d
@test rst3d ≈ pts3d