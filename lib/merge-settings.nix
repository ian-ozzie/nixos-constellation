{ lib }:
let
  mergeSettings =
    publicSettings: privateSettings:
    if lib.isAttrs publicSettings && lib.isAttrs privateSettings then
      lib.zipAttrsWith
        (
          _: values:
          if lib.length values == 1 then
            lib.head values
          else
            mergeSettings (lib.elemAt values 0) (lib.elemAt values 1)
        )
        [
          publicSettings
          privateSettings
        ]
    else if lib.isList publicSettings || lib.isList privateSettings then
      lib.toList publicSettings ++ lib.toList privateSettings
    else
      privateSettings;
in
mergeSettings
