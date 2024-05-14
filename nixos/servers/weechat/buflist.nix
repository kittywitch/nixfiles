{ config, std, inputs, ... }: let
    inherit (std) list set;
 in {
    services.weechat.enable = true;
    home-manager.users.kat.programs.weechat.config.buflist.format =  with set.map (_: v: "colour${builtins.toString (list.unsafeHead v)}") inputs.base16.lib.base16.shell.mapping256;  {
        indent = "\${if:\${merged}?\${if:\${buffer.prev_buffer.number}!=\${buffer.number}?│┌:\${if:\${buffer.next_buffer.number}==\${buffer.number}?│├:\${if:\${buffer.next_buffer.name}=~^server||\${buffer.next_buffer.number}<0?└┴:├┴}}}:\${if:\${buffer.active}>0?\${if:\${buffer.next_buffer.name}=~^server?└:\${if:\${buffer.next_buffer.number}>0?├:└}}:\${if:\${buffer.next_buffer.name}=~^server? :│}}}─";
        buffer_current = "\${color:,${base0D}}\${format_buffer}";
        hotlist = " \${color:${base0B}}(\${hotlist}\${color:${base0B}})";
        hotlist_highlight = "\${color:${base08}}";
        hotlist_low = "\${color:${base06}}";
        hotlist_message = "\${color:${base0C}}";
        hotlist_none = "\${color:${base06}}";
        hotlist_private = "\${color:${base09}}";
        hotlist_separator = "\${color:${base04}},";
        number = "\${color:${base07}}\${number}\${if:\${number_displayed}?.: }";
    };
}
