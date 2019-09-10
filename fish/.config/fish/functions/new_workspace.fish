function new_workspace

  # append will be in fish 3.0
  set used_workspaces ""
  for workspace in (swaymsg --raw --type get_workspaces | jq --raw-output '.[].name')
    set --append used_workspaces $workspace
  end
  echo $used_workspaces

  set free_workspaces (seq 1 50)
  for ws in $used_workspaces
    if set --local index (contains --index $ws $free_workspaces)
      set --erase free_workspaces[$index]
    end
  end
  echo $free_workspaces
end
