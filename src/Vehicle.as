
namespace Nitro {

  class Vehicle {
    #include "./Helpers.as";
    CSceneVehicleVisState@ State;

    float RPM = 0;
    float Speed = 0;

    bool IsGearingUp;
    bool IsGearingDown;

    Vehicle() {}
    Vehicle(ISceneVis@ sceneVis, CSmPlayer@ player) {
      // When Vehicle is null, we're playing offline. In that case, we'll just grab the first entity
      // that matches the ID mask 0x02000000.
      uint vehicleEntityId = 0;
      if (player.ScriptAPI.Vehicle !is null) {
        vehicleEntityId = player.ScriptAPI.Vehicle.Id.Value;
      }

      auto vehicleVisMgr = Nitro::GetSceneMgr(sceneVis, 5); // NSceneVehicleVis_SMgr
  		if (vehicleVisMgr is null) {
  			return;
  		}
      uint vehiclesOffset = 0x1C8;
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
  			@this.State = Dev::ForceCast<CSceneVehicleVis@>(nodVehicle).Get().AsyncState;
  		}

      if (this.State !is null) {
        float rpm = this.getRPM(this.State);
        // visual correction
        if (rpm < 900) {
          rpm += 900;
        }

        switch (this.State.CurGear) {
          case 1:
            if (rpm > 10000) {
              this.IsGearingUp = true;
            }
          break;
          case 2:
            if (rpm > 9500) {
              this.IsGearingUp = true;
            } else if (rpm < 5750) {
              this.IsGearingDown = true;
            }
          break;
          case 3:
            if (rpm > 10000) {
              this.IsGearingUp = true;
            } else if (rpm < 6600) {
              this.IsGearingDown = true;
            }
          case 4:
            if (rpm > 10000) {
              this.IsGearingUp = true;
            } else if (rpm < 6250) {
              this.IsGearingDown = true;
            }
          break;
          case 5:
            if (rpm < 7000) {
              this.IsGearingDown = true;
            }
          break;
          default:
            this.IsGearingUp = false;
          break;
        }
        this.RPM = rpm;
        this.Speed = Math::Abs(this.State.FrontSpeed * 3.6f);
      }
    }

    // Get RPM for vehicle vis. This is contained within the state, but not exposed by default, which
  	// is why this function exists.
    uint16 g_offsetEngineRPM = 0;
  	float getRPM(CSceneVehicleVisState@ vehicle)
  	{
  		if (g_offsetEngineRPM == 0) {
  			auto type = Reflection::GetType("CSceneVehicleVisState");
  			if (type is null) {
  				error("Unable to find reflection info for CSceneVehicleVisState!");
  				return 0.0f;
  			}
  			g_offsetEngineRPM = type.GetMember("EngineOn").Offset + 4;
  		}

  		return Dev::GetOffsetFloat(vehicle, g_offsetEngineRPM);
  	}

  }
}
