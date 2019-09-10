function new_workspace

  # append will be in fish 3.0
  set $workspaces ""
  for workspace in (swaymsg --raw --type get_workspaces | jq --raw-output '.[].name')
    set --append $workspaces $workspace
  end

end
