{
  lib,
  manifests,
  project,
  projectName,
}:
let
  address =
    networkRole: memberName:
    let
      network =
        project.networks.${networkRole}
          or (throw "Project '${projectName}': network role '${networkRole}' is not assigned");

      addresses = manifests.${memberName}.network.addresses or { };
    in
    addresses.${network}
      or (throw "Project '${projectName}': member '${memberName}' has no '${network}' address");

  addresses = networkRole: members: map (address networkRole) (lib.toList members);
in
{
  inherit address addresses;
}
