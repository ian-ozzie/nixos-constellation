{ lib }:
{ constellation, private }:
memberName:
let
  fields = lib.unique (lib.attrNames fromPublic ++ lib.attrNames fromPrivate);
  fromPrivate = private.members.${memberName} or { };
  fromPublic = constellation.members.${memberName} or { };

  mergeField =
    field:
    let
      privateField = fromPrivate.${field};
      publicField = fromPublic.${field};
    in
    if !(fromPublic ? ${field}) then
      privateField
    else if !(fromPrivate ? ${field}) then
      publicField
    else if lib.isList publicField && lib.isList privateField then
      publicField ++ privateField
    else if lib.isAttrs publicField && lib.isAttrs privateField then
      lib.recursiveUpdate publicField privateField
    else
      privateField;
in
lib.genAttrs fields mergeField
