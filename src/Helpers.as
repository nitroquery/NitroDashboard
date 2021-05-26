namespace Nitro {
  class mat2
  {
  	float xx;
  	float xy;
  	float yx;
  	float yy;
  }
  
  float DegreeToRadiant(float degrees) { return degrees * Math::PI / 180.0f; }

  // Gets a scene manager by its index. Prefer to use this instead of FindMgr,
  // if you know the index.
  CMwNod@ GetSceneMgr(ISceneVis@ sceneVis, uint index) {
    uint managerCount = Dev::GetOffsetUint32(sceneVis, 0x8);
    if (index > managerCount) {
      error("Index out of range: there are only " + managerCount + " managers");
      return null;
    }
    return Dev::GetOffsetNod(sceneVis, 0x10 + index * 0x8);
  }

  vec2 mat2_product(vec2 vector, mat2 matrix)
  {
  	return vec2(vector.x * matrix.xx - vector.y * matrix.xy, vector.x * matrix.yx + vector.y * matrix.yy);
  }

  vec2 rotate(vec2 vector, float angle)
  {
  	//mat2 rotation_matrix = mat2(Math::Cos(Math::ToRad(angle)),-Math::Sin(Math::ToRad(angle)), Math::Sin(Math::ToRad(angle)),  Math::Cos(Math::ToRad(angle)));
  	mat2 rotation_matrix = mat2();
  	rotation_matrix.xx = Math::Cos(Math::ToRad(angle));
  	rotation_matrix.xy = -Math::Sin(Math::ToRad(angle));
  	rotation_matrix.yx = Math::Sin(Math::ToRad(angle));
  	rotation_matrix.yy =  Math::Cos(Math::ToRad(angle));

  	return mat2_product(vector,rotation_matrix);
  }
}
