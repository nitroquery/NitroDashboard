namespace OpenUtils::Scene {
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
}
