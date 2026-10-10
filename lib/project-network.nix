{
  lib,
  manifests,
  project,
  projectName,
}:
let
  addressFamily = address: if lib.hasInfix ":" address then "ipv6" else "ipv4";
  addresses = networkRole: members: map (address networkRole) (lib.toList members);
  urlAddress = address: if addressFamily address == "ipv6" then "[${address}]" else address;

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

  endpoint =
    networkRole: memberName: port:
    "${urlAddress (address networkRole memberName)}:${toString port}";

  endpoints =
    networkRole: members: port:
    map (memberName: endpoint networkRole memberName port) (lib.toList members);
in
{
  inherit
    address
    addressFamily
    addresses
    endpoint
    endpoints
    urlAddress
    ;
}
