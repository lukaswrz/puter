{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    mmtc
  ];

  xdg.configFile."mmtc/mmtc.ron".text = ''
    Config(
        address: "${config.services.mpd.network.listenAddress}:${builtins.toString config.services.mpd.network.port}",
        clear_query_on_play: false,
        cycle: false,
        jump_lines: 24,
        seek_secs: 5.0,
        search_fields: SearchFields(
            file: false,
            title: true,
            artist: true,
            album: true,
        ),
        ups: 1.0,
        layout: Rows([
            Fixed(1, Columns([
                Ratio(12, Textbox(Styled([Fg(Indexed(122)), Bold], Text("Title")))),
                Ratio(10, Textbox(Styled([Fg(Indexed(158)), Bold], Text("Artist")))),
                Ratio(10, Textbox(Styled([Fg(Indexed(194)), Bold], Text("Album")))),
                Ratio(1, Textbox(Styled([Fg(Indexed(230)), Bold], Text("Time")))),
            ])),
            Min(0, Queue([
                Column(
                    item: Ratio(12, If(QueueCurrent,
                        Styled([Italic], If(QueueTitleExist, QueueTitle, QueueFile)),
                        If(QueueTitleExist, QueueTitle, QueueFile),
                    )),
                    style: [Fg(Indexed(75))],
                    selected_style: [Fg(Black), Bg(Indexed(75)), Bold],
                ),
                Column(
                    item: Ratio(10, If(QueueCurrent,
                        Styled([Italic], QueueArtist),
                        QueueArtist,
                    )),
                    style: [Fg(Indexed(111))],
                    selected_style: [Fg(Black), Bg(Indexed(111)), Bold],
                ),
                Column(
                    item: Ratio(10, If(QueueCurrent,
                        Styled([Italic], QueueAlbum),
                        QueueAlbum,
                    )),
                    style: [Fg(Indexed(147))],
                    selected_style: [Fg(Black), Bg(Indexed(147)), Bold],
                ),
                Column(
                    item: Ratio(1, If(QueueCurrent,
                        Styled([Italic], QueueDuration),
                        QueueDuration,
                    )),
                    style: [Fg(Indexed(183))],
                    selected_style: [Fg(Black), Bg(Indexed(183)), Bold],
                ),
            ])),
            Fixed(1, Columns([
                Min(0, Textbox(Styled([Bold], If(Searching,
                    Parts([
                        Styled([Fg(Indexed(113))], Text("Searching: ")),
                        Styled([Fg(Indexed(185))], Query),
                        Styled([Fg(Indexed(185))], Text("⎸")),
                    ]),
                    If(Not(Stopped), Parts([
                        Styled([Fg(Indexed(113))], Parts([
                            If(Playing, Text("[playing: "), Text("[paused:  ")),
                            CurrentElapsed,
                            Text("/"),
                            CurrentDuration,
                            Text("] "),
                        ])),
                        If(TitleExist,
                            Parts([
                                Styled([Fg(Indexed(149))], CurrentTitle),
                                If(ArtistExist, Parts([
                                    Styled([Fg(Indexed(216))], Text(" | ")),
                                    Styled([Fg(Indexed(185))], CurrentArtist),
                                    If(AlbumExist, Parts([
                                        Styled([Fg(Indexed(216))], Text(" | ")),
                                        Styled([Fg(Indexed(221))], CurrentAlbum),
                                    ])),
                                ])),
                            ]),
                            Styled([Fg(Indexed(185))], CurrentFile),
                        ),
                    ])),
                )))),
                Fixed(7, TextboxR(Styled([Fg(Indexed(81))], Parts([
                    Text("["),
                    If(Repeat, Text("@")),
                    If(Random, Text("#")),
                    If(Single, Text("^"), If(Oneshot, Text("!"))),
                    If(Consume, Text("*")),
                    Text("]"),
                ])))),
            ])),
        ]),
    )
  '';
}
