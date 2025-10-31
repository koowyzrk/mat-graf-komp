#import "@preview/definitely-not-isec-slides:1.0.1": *
#import "@preview/pavemat:0.2.0": pavemat
#import "@preview/physica:0.9.7"

#show: definitely-not-isec-theme.with(
  aspect-ratio: "16-9",
  slide-alignment: top,
  progress-bar: true,
  institute: [Politechnika Łódzka],
  logo: image("uni_logo/uni_logo.png", width: 5cm),
  // logo: [#tugraz-logo],
  config-info(
    title: [Przekształcenia Liniowe w 3D \ Rotacja, Odbicie, Skalowanie],
    // subtitle: [An optional short subtitle],
    authors: ([Jan Banaszkiewicz], [Jakub Kopaniewski]),
    extra: [*Matematyka Grafiki Komputerowej*],
    footer: [Jan Banaszkiewicz, Jakub Kopaniewski],
    download-qr: "",
  ),
  config-common(
    handout: false,
  ),
  config-colors(
    primary: rgb("7C2529"),
  ),
)

// -------------------------------[[ CUT HERE ]]--------------------------------
//
// === Available slides ===
//
// #title-slide()
// #standout-slide(title)
// #section-slide(title,subtitle)
// #blank-slide()
// #slide(title)
//
// === Available macros ===
//
// #quote-block(body)
// #color-block(title, body)
// #icon-block(title, icon, body)
//
// === Presenting with pdfpc ===
//
// Use #note("...") to add pdfpc presenter annotations on a specific slide
// Before presenting, export all notes to a pdfpc file:
// $ typst query slides.typ --field value --one "<pdfpc-file>" > slides.pdfpc
// $ pdfpc slides.pdf
//
// -------------------------------[[ CUT HERE ]]--------------------------------

#title-slide()

#slide(title: [First Slide])[
  #quote-block[
    Good luck with your presentation! @emg25template
  ]

  $ physica.curl (physica.grad f), physica.tensor(T, -mu, +nu), physica.pdv(f, x, y, [1,2]) $
  #note("This will show on pdfpc speaker notes ;)")
]

#slide(title: [Bibliography])[
  #bibliography("bibliography.bib")
]
