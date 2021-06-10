namespace OpenUtils::Vehicle {
  CSceneVehicleVisState@ GetVis(ISceneVis@ sceneVis, CSmPlayer@ player) {
    // When Vehicle is null, we're playing offline. In that case, we'll just grab the first entity
    // that matches the ID mask 0x02000000.
    uint vehicleEntityId = 0;
    uint vehiclesOffset = 0x1C8;
    uint VehiclesManagerIndex = 4;
    if (player.ScriptAPI.Vehicle !is null) {
      vehicleEntityId = player.ScriptAPI.Vehicle.Id.Value;
    }

    auto vehicleVisMgr = OpenUtils::Scene::GetSceneMgr(sceneVis, VehiclesManagerIndex); // NSceneVehicleVis_SMgr
    if (vehicleVisMgr is null) {
      return null;
    }
    auto vehicles = Dev::GetOffsetNod(vehicleVisMgr, vehiclesOffset);
    auto vehiclesCount = Dev::GetOffsetUint32(vehicleVisMgr, vehiclesOffset + 0x8);
    for (uint i = 0; i < vehiclesCount; i++) {
      auto nodVehicle = Dev::GetOffsetNod(vehicles, i * 0x8);
      auto nodVehicleEntityId = Dev::GetOffsetUint32(nodVehicle, 0);

      if (vehicleEntityId != 0 && nodVehicleEntityId != vehicleEntityId) {
        continue;
      } else if (vehicleEntityId == 0 && (nodVehicleEntityId & 0x02000000) == 0) {
        continue;
      }
      return Dev::ForceCast<CSceneVehicleVis@>(nodVehicle).Get().AsyncState;
    }
    return null;
  }

  // Get RPM for vehicle vis. This is contained within the state,
  // but not exposed by default, which is why this function exists.
  uint16 g_offsetEngineRPM = 0;
	uint GetRPM(CSceneVehicleVisState@ vis)
	{
		if (g_offsetEngineRPM == 0) {
			auto type = Reflection::GetType("CSceneVehicleVisState");
			if (type is null) {
				error("Unable to find reflection info for CSceneVehicleVisState!");
				return 0.0f;
			}
			g_offsetEngineRPM = type.GetMember("EngineOn").Offset + 4;
		}

		return uint(Dev::GetOffsetFloat(vis, g_offsetEngineRPM));
	}
}
