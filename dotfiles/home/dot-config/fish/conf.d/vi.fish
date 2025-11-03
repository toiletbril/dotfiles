function enable_vi_mode
  set fish_cursor_insert      line
  set fish_cursor_replace_one underscore
  set fish_cursor_replace     underscore
  set fish_cursor_external    line
  set fish_cursor_visual      block
  fish_vi_key_bindings
end

#enable_vi_mode
