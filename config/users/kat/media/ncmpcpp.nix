{ config, pkgs, ... }:

{
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = "/home/kat/media-share/music";
    package = pkgs.ncmpcpp-kat;
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "+|";
      user_interface = "alternative";
      colors_enabled = "yes";
      discard_colors_if_item_is_selected = "no";
      header_window_color = "250";
      volume_color = "250";
      state_line_color = "cyan";
      state_flags_color = "cyan";
      alternative_ui_separator_color = "yellow";
      statusbar_color = "yellow";
      progressbar_color = "black";
      progressbar_elapsed_color = "blue";
      window_border_color = "yellow";
      playlist_display_mode = "classic";
      song_columns_list_format =
        "(3f)[cyan]{n} (40)[default]{t|f} (25)[red]{a} (30)[blue]{b} (4f)[cyan]{l}";
      now_playing_prefix = "$b";
      song_list_format =
        " $7%n$9 $8-$9 $6%a$9 $8-$9 $5%b$9 $R $8%t$9 ($4%l$9) ";
      song_library_format = "{%n > }{%t}|{%f}";
      song_status_format = "{%a - }{%t - }{%b}";
      titles_visibility = "no";
      header_visibility = "no";
      statusbar_visibility = "no";
      now_playing_suffix = "$/b";
      progressbar_look = "▄▄ ";
      media_library_primary_tag = "album_artist";
      search_engine_display_mode = "columns";
    };
    bindings = [
      {
        key = "+";
        command = "add";
      }
      {
        key = "-";
        command = "load";
      }
    ];
  };
}
