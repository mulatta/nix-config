#!/run/current-system/sw/bin/bash
ACTION=$1
TEMPLATE=$2
TEMPLATE_PATH=$3

if [ -z "$ACTION" ]; then
  echo "Error: Missing ACTION parameter"
  echo "Usage: dvt [new|init] TEMPLATE [TEMPLATE_PATH]"
  exit 1
fi

if [ -z "$TEMPLATE" ]; then
  echo "Error: Missing TEMPLATE parameter"
  echo "Usage: dvt [new|init] TEMPLATE [TEMPLATE_PATH]"
  exit 1
fi

if [ $ACTION == "new" ]; then
  nix flake new --template github:mulatta/templates#"$TEMPLATE" "$TEMPLATE_PATH"
elif [ $ACTION == "init" ]; then
  nix flake init --template github:mulatta/templates#"$TEMPLATE"
else
  echo "Error: ACTION must be either 'new' or 'init'"
  exit 1
fi
