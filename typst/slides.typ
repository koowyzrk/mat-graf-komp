#import "@preview/definitely-not-isec-slides:1.0.1": *
#import "@preview/pavemat:0.2.0": pavemat
#import "@preview/physica:0.9.6"

#show: definitely-not-isec-theme.with(
  aspect-ratio: "16-9",
  slide-alignment: top,
  progress-bar: true,
  institute: [Politechnika Łódzka],
  logo: image("uni_logo/uni_logo.png", width: 5cm),
  config-info(
    title: [Przekształcenia Liniowe w 3D \ Rotacja, Odbicie, Skalowanie],
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
//   #quote-block[
//   Good luck with your presentation! @emg25template
//   ]
//
// #color-block(title, body)
// #icon-block(title, icon, body)
//
// === Presenting with pdfpc ===
//
// Use #note("...") to add pdfpc presenter annotations on a specific slide
// #note("This will show on pdfpc speaker notes ;)")
// Before presenting, export all notes to a pdfpc file:
// $ typst query slides.typ --field value --one "<pdfpc-file>" > slides.pdfpc
// $ pdfpc slides.pdf
//
// -------------------------------[[ CUT HERE ]]--------------------------------

#title-slide()

#slide(title: [Skalowanie obiektów w przestrzeni 3D])[
  #set text(size: 0.9em)
  Skalowanie to przekształcenie liniowe zmieniające rozmiar obiektu względem początku układu współrzędnych o zadany współczynnik *k*.
  Dla przestrzeni trójwymiarowej macierz skalowania ma postać:
  #v(1em)
  #align(center)[
    $S(k_x, k_y, k_z) = physica.dmat(k_x, k_y, k_z, delim: "[", fill: 0)$
  ]
  #v(1em)
  gdzie:
  - $k_x$, $k_y$, $k_z$ – współczynniki skali wzdłuż osi $x$, $y$, $z$
]

#slide(title: [Skalowanie wzdłuż osi układu współrzędnych])[
  #set text(size: 0.9em)
  Skalowanie wzdłuż osi polega na zmianie wymiaru obiektu względem płaszczyzn współrzędnych.
  Jeżeli współczynniki skalowania są jednakowe, skalowanie jest *jednolite*;
  w przeciwnym razie — *niejednolite*.
  #v(1em)
  Mnożąc wektor przez macierz skalowania, otrzymujemy:
  #v(1em)
  #align(center)[
    $vec(x, y, z) = physica.dmat(k_x, k_y, k_z, delim: "[", fill: 0) ⋅ vec(x, y, z) = vec(k_x x, k_y y, k_z z)$
  ]
  #v(1em)
  lub równoważnie:
  #align(center)[
    $S(k_x, k_y, k_z) ⋅ vec(v) = vec(v')$, gdzie $v' = (k_x x, k_y y, k_z z)$
  ]
]

#slide(title: [Skalowanie jednolite])[
  #set text(size: 0.9em)
  Jednolite skalowanie to przekształcenie liniowe, w którym każdy wymiar obiektu
  jest powiększany lub pomniejszany o ten sam współczynnik $k$.
  Skalowanie odbywa się względem początku układu współrzędnych.
  #v(1em)
  *Macierz skalowania w 3D:*
  $S = physica.dmat(k, k, k, delim: "[", fill: 0)$
  #v(1em)
  *Własności:*
  - zachowuje kształt i kąty (nie zniekształca obiektu),
  - kierunek kształtu jest zawsze zachowany
  - wszystkie wymiary rosną proporcjonalnie do $k$,
  - pole powierzchni rośnie jak $k^2$,
  - objętość rośnie jak $k^3$.
]

#slide(title: [Wizualizacja skalowania jednolitego (sześcian)])[
  #set text(size: 0.9em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #image("transformations/scale_uniform_1.png", width: 15cm)
      #align(center)[#text(size: 0.8em, "Sześcian przed skalowaniem (długość boku = 1)")]
    ],
    [
      #image("transformations/scale_uniform_2.png", width: 15cm)
      #align(center)[#text(size: 0.8em, "Sześcian po skalowaniu o współczynnik k = 2 \n (długość boku = 2)")]
    ],
  )
  #v(2em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      *Obliczenia:*
      Dla punktu $P = vec(1, 0, 0)$ oraz macierzy:
      $S = physica.dmat(2, 2, 2, delim: "[", fill: 0)$
      #v(1em)
      mamy:
      $P' = S ⋅ P = vec(1 ⋅ 2 + 0 ⋅ 0 + 0 ⋅ 0, 1 ⋅ 0 + 0 ⋅ 2 + 0 ⋅ 0, 1 ⋅ 0 + 0 ⋅ 0 + 0 ⋅ 2) = vec(2, 0, 0)$
    ],
    [
      Dla kolejnych wierzchołków sześcianu:
      $
        physica.vecrow(0, 0, 0, delim: "[") → physica.vecrow(0, 0, 0, delim: "[") \
        physica.vecrow(0, 0, 1, delim: "[") → physica.vecrow(0, 0, 2, delim: "[") \
        physica.vecrow(0, 1, 0, delim: "[") → physica.vecrow(0, 2, 0, delim: "[") \
        physica.vecrow(0, 1, 1, delim: "[") → physica.vecrow(0, 2, 2, delim: "[") \
        physica.vecrow(1, 0, 1, delim: "[") → physica.vecrow(2, 0, 2, delim: "[") \
        physica.vecrow(1, 1, 0, delim: "[") → physica.vecrow(2, 2, 0, delim: "[") \
        physica.vecrow(1, 1, 1, delim: "[") → physica.vecrow(2, 2, 2, delim: "[")
      $
    ],
  )
  #v(2em)
  Każda współrzędna została pomnożona przez $2$.
  Zatem sześcian o boku $1$ został powiększony do boku $2$,
  a objętość zwiększyła się $8$-krotnie ($2^3 = 8$).
]

#slide(title: [Skalowanie niejednolite (anisotropowe)])[
  #set text(size: 0.9em)
  Jeśli chcemy „rozciągnąć” lub „ściśnąć” obiekt, możemy zastosować różne współczynniki skalowania w różnych kierunkach.
  Takie przekształcenie nazywamy *skalowaniem niejednolitym (anisotropowym)*.
  Nierównomierna skala nie zachowuje kątów ani proporcji między wymiarami.
  #v(1em)
  *Macierz skalowania:*
  $S = physica.dmat(k_x, k_y, k_z, delim: "[", fill: 0)$
  #v(1em)
  *Własności:*
  - nie zachowuje kształtów ani kątów między osiami,
  - kierunki osi pozostają zachowane (osie nie zmieniają orientacji),
  - zmiana długości wzdłuż osi X, Y, Z następuje odpowiednio o współczynniki $k_x$, $k_y$, $k_z$,
  - pole powierzchni zmienia się proporcjonalnie do $k_x k_y$,
  - objętość zmienia się proporcjonalnie do $k_x k_y k_z$,
]

#slide(title: [Wizualizacja skalowania niejednolitego])[
  #set text(size: 0.9em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #image("transformations/scale_notuniform_1.png", width: 15cm)
      #align(center)[#text(size: 0.8em, "Sześcian przed skalowaniem (długość boku = 1)")]
    ],
    [
      #image("transformations/scale_notuniform.png", width: 15cm)
      #align(center)[#text(size: 0.8em, "Sześcian po skalowaniu o róźne współczynniki k")]
    ],
  )
  #v(2em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      *Obliczenia:*
      Dla punktu $P = vec(1, 0, 0)$ oraz macierzy:
      $S = physica.dmat(2, 0.5, 1.5, delim: "[", fill: 0)$
      #v(1em)
      mamy:
      $P' = S ⋅ P = vec(1 ⋅ 2 + 0 ⋅ 0 + 0 ⋅ 0, 1 ⋅ 0 + 0 ⋅ 0.5 + 0 ⋅ 0, 1 ⋅ 0 + 0 ⋅ 0 + 0 ⋅ 1.5) = vec(2, 0, 0)$
    ],
    [
      Dla kolejnych wierzchołków sześcianu:
      $
        physica.vecrow(0, 0, 0, delim: "[") → physica.vecrow(0, 0, 0, delim: "[") \
        physica.vecrow(0, 0, 1, delim: "[") → physica.vecrow(0.0, 0.0, 1.5, delim: "[") \
        physica.vecrow(0, 1, 0, delim: "[") → physica.vecrow(0.0, 0.5, 0.0, delim: "[") \
        physica.vecrow(0, 1, 1, delim: "[") → physica.vecrow(0.0, 0.5, 1.5, delim: "[") \
        physica.vecrow(1, 0, 1, delim: "[") → physica.vecrow(2.0, 0.0, 1.5, delim: "[") \
        physica.vecrow(1, 1, 0, delim: "[") → physica.vecrow(2.0, 0.5, 0.0, delim: "[") \
        physica.vecrow(1, 1, 1, delim: "[") → physica.vecrow(2.0, 0.5, 1.5, delim: "[")
      $
    ],
  )
]

#slide(title: [Skalowanie wzdłuż jednej osi])[
  #set text(size: 0.9em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #image("transformations/scale_notuniform_x.png", width: 15cm)
      #align(center)[#text(size: 0.8em, "Skalowanie sześcianu o długości boku = 1 tylko względem osi x o wartość 2")]
    ],
    [
      Aby "rozciągnąć" lub "ściśnąć" tylko względem jednej osi możemy użyć następujących macierzy. \
      #v(1em)
      $S_x = physica.dmat(k, 1, 1, delim: "[", fill: 0)
      S_y = physica.dmat(1, k, 1, delim: "[", fill: 0)
      S_z = physica.dmat(1, 1, k, delim: "[", fill: 0)$

      #v(1em)
      W naszym przykładzie "rozciągniemy" nasz sześcian względem osi x. Więc nasza macierz będzie wyglądać nastepująco: \
      #v(1em)
      #align(center)[
        $S_x = physica.dmat(2, 1, 1, delim: "[", fill: 0)$
      ]
    ],
  )
]

#slide(title: [Skalowanie w dowolnym kierunku])[
  #set text(size: 0.9em)
  Skalowanie nie musi odbywać się wyłącznie wzdłuż osi układu współrzędnych.
  Możemy skalować obiekt wzdłuż dowolnego kierunku określonego przez wektor jednostkowy *$physica.vu(n)$*.
  #v(1em)
  *Macierz skalowania wzdłuż kierunku $physica.vu(n)$:*
  #v(1em)
  #align(center)[
    $S = I + (k - 1)physica.vu(n)physica.vu(n)^T$
  ]
  gdzie:
  - $I$ — macierz jednostkowa,
  - $physica.vu(n)$ — wektor jednostkowy kierunku skalowania,
  - $k$ — współczynnik skali wzdłuż tego kierunku.
  #v(1em)

  Rozpisując równanie $physica.vu(n)physica.vu(n)^T$, otrzymujemy:
  #v(1em)
  #align(center)[
    $physica.vu(n) = vec(n_x, n_y, n_z) => physica.vu(n)physica.vu(n)^T = mat(n_x^2, n_x n_y, n_x n_z; n_y n_x, n_y^2, n_y n_z; n_z n_x, n_z n_y, n_z^2)$
  ]

  Po podstawieniu do $S = I + (k - 1)physica.vu(n)physica.vu(n)^T$, otrzymujemy:
  #v(1em)
  #align(center)[
    $S(physica.vu(n),k) = mat(1 + (k-1)n_x^2, (k-1) n_x n_y, (k-1) n_x n_z; (k-1) n_y n_x, 1 + (k-1) n_y^2, (k-1) n_y n_z; (k-1) n_z n_x, (k-1) n_z n_y, 1 + (k-1) n_z^2)$
  ]
  #v(1em)
  Skalowanie w dowolnym kierunku jest uogólnieniem skalowania wzdłuż osi:
  #v(1em)
  - dla $physica.vu(n) = vec(1, 0, 0)$ mamy skalowanie wzdłuż osi X,
  #v(1em)
  - dla $physica.vu(n) = vec(0, 1, 0)$ — wzdłuż osi Y,
  #v(1em)
  - dla $physica.vu(n) = vec(0, 0, 1)$ — wzdłuż osi Z.
]

#slide(title: [Przykład: skalowanie wzdłuż kierunku ukośnego])[
  #set text(size: 0.9em)
  Załóżmy, że chcemy skalować wzdłuż kierunku ukośnego, który leży w płaszczyźnie XY i biegnie pod kątem 45° do osi X oraz dla współczynnika skali $k = 2$. \
  Ten kierunek opisuje wektor:
  #v(1em)
  #align(center)[
    $physica.va(n) = vec(1, 1, 0)$
  ]
  #v(1em)
  ,który nie jest wektorem jednostkowym więc musimy go znormalizować. Jego długość teraz wynosi:
  #align(center)[
    $abs(physica.va(n)) = sqrt(1^2 + 1^2 + 0^2) = sqrt(2)$
  ]
  #v(1em)
  Aby przekształcenie było poprawne, potrzebujemy wektora jednostkowego:
  #v(1em)
  #align(center)[
    $physica.vu(n) = frac(physica.va(n), abs(physica.va(n))) -> physica.vu(n) = frac(1, sqrt(2)) vec(1, 1, 0)$
  ]

  #v(2em)
  Obliczamy macierz $physica.vu(n)physica.vu(n)^T$:
  #align(center)[
    $physica.vu(n)physica.vu(n)^T = frac(1, 2) mat(1, 1, 0; 1, 1, 0; 0, 0, 0)$
  ]
  #v(1em)
  Po podstawieniu do równania na $S$:
  #v(1em)
  #align(center)[
    $S = mat(1, 0, 0; 0, 1, 0; 0, 0, 1) + (2 - 1) ⋅ frac(1, 2) mat(1, 1, 0; 1, 1, 0; 0, 0, 0)$
  ]
  #v(1em)
  Ostatecznie:
  #align(center)[
    $S = mat(1.5, 0.5, 0; 0.5, 1.5, 0; 0, 0, 1)$
  ]
  #v(2em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      *Działanie na przykładzie punktu:* \
      #v(1em)
      Dla $P = vec(1, 0, 1)$: $P' = S ⋅ P = vec(1.5, 0.5, 1)$
      #v(1em)
      Punkt został przeskalowany wzdłuż kierunku ukośnego $(1, 1, 0)$ — jego współrzędne zmieniły się proporcjonalnie w obu osiach.
      Obiekt został rozciągnięty dwukrotnie wzdłuż tego kierunku, natomiast w kierunku prostopadłym pozostał bez zmian.
    ],
    [
      #image("transformations/scale_diff_1.png", width: 15cm)
    ],
  )
]

#slide(title: [Odbicie względem płaszczyzny])[
  #set text(size: 0.9em)
  Odbicie (lub *lustrzane odbicie*) to przekształcenie liniowe, które odwraca położenie punktów obiektu względem danej płaszczyzny.
  W przestrzeni trójwymiarowej płaszczyzna odbicia przechodzi przez początek układu współrzędnych, a jej orientację określa wektor jednostkowy normalny $physica.vu(n)$.
  Odbicie można interpretować jako *skalowanie wzdłuż kierunku $physica.vu(n)$* ze współczynnikiem $k = -1$.
  #v(1em)
  *Macierz odbicia:*
  #align(center)[
    $R(physica.vu(n)) = S(physica.vu(n), -1)
    = mat(
      1 - 2n_x^2, -2n_x n_y, -2n_x n_z;
      -2n_y n_x, 1 - 2n_y^2, -2n_y n_z;
      -2n_z n_x, -2n_z n_y, 1 - 2n_z^2
    )$
  ]
  #v(1em)
  *Własności odbicia:*
  - odwraca orientację obiektu (powstaje obraz lustrzany),
  - jest izometrią — zachowuje długości i kąty między wektorami,
  - dwukrotne zastosowanie odbicia przywraca pierwotny kształt: $R(physica.vu(n))^2 = I$,
]

#slide(title: [Przykład — odbicie względem płaszczyzny XY])[
  #set text(size: 0.9em)
  Rozważmy odbicie względem płaszczyzny XY, której wektor normalny to:
  #v(1em)
  #align(center)[$physica.vu(n) = vec(0, 0, 1)$]
  *Macierz odbicia:*
  #align(center)[
    $R = mat(
      1, 0, 0;
      0, 1, 0;
      0, 0, -1
    )$
  ]
  #v(1em)
  Dla wierzchołków piramidy mamy:
  #v(0.5em)
  $
    physica.vecrow(0, -0.5, 0, delim: "[") → physica.vecrow(0, -0.5, 0, delim: "[") \
    physica.vecrow(-0.5, 0, 0, delim: "[") → physica.vecrow(-0.5, 0, 0, delim: "[") \
    physica.vecrow(0, 0.5, 0, delim: "[") → physica.vecrow(0, 0.5, 0, delim: "[") \
    physica.vecrow(0.5, 0, 0, delim: "[") → physica.vecrow(0.5, 0, 0, delim: "[") \
    physica.vecrow(0, 0, 1, delim: "[") → physica.vecrow(0, 0, -1, delim: "[")
  $
  #v(1em)
  Wierzchołki leżące w płaszczyźnie XY pozostają niezmienione, natomiast punkt znajdujący się powyżej zostaje odbity symetrycznie poniżej niej.
  #v(1em)
  #align(center)[
    #image("transformations/piramid_refl.png", width: 15cm)
  ]
]

#slide(title: [Rzut równoległy jako przypadek skalowania])[
  #set text(size: 0.9em)
  Rzut równoległy (ortograficzny) można traktować jako *szczególny przypadek skalowania*, w którym współczynnik skali wzdłuż jednego z kierunków wynosi zero.
  W takim przypadku wszystkie punkty zostają „spłaszczone” na płaszczyznę — czyli ich współrzędne wzdłuż danego kierunku zanikają.
  #v(1em)
  *Interpretacja geometryczna:*
  Punkty oraz ich obrazy są połączone prostymi równoległymi do kierunku rzutu. Dlatego przekształcenie to nazywa się *rzutem równoległym*.
  #v(1em)
  *Własności rzutu równoległego:*
  - nie zachowuje perspektywy (brak zbiegu linii równoległych),
  - zachowuje kształt i proporcje obiektów,
  - jest liniowym przekształceniem macierzowym,
  - w praktyce odpowiada „pominięciu” współrzędnej $z$ (dla rzutu na płaszczyznę XY).
]

#slide(title: [Rzutowanie na oś lub płaszczyznę kardynalną])[
  #set text(size: 0.9em)
  Rzutowanie na jedną z płaszczyzn głównych (kardynalnych) można przedstawić za pomocą *macierzy skalowania* ze współczynnikiem $k = 0$ w kierunku normalnym do tej płaszczyzny.
  #v(1em)
  W ten sposób rzut 3D → 2D realizowany jest przez „wyzerowanie” jednej współrzędnej punktu:
  #v(1em)
  #align(center)[
    *Rzut na płaszczyznę XY:*
    $P_"xy" = S(vec(0, 0, 1), 0) =
    mat(
      1, 0, 0;
      0, 1, 0;
      0, 0, 0
    )$
    #v(1em)
    *Rzut na płaszczyznę XZ:*
    $P_"xz" = S(vec(0, 1, 0), 0) =
    mat(
      1, 0, 0;
      0, 0, 0;
      0, 0, 1
    )$
    #v(1em)
    *Rzut na płaszczyznę YZ:*
    $P_"yz" = S(vec(1, 0, 0), 0) =
    mat(
      0, 0, 0;
      0, 1, 0;
      0, 0, 1
    )$
  ]
  #v(1em)
  W każdym przypadku współrzędna wzdłuż kierunku normalnego do płaszczyzny zostaje usunięta,
  co odpowiada „rzutowi” wszystkich punktów na daną płaszczyznę przy zachowaniu ich pozostałych współrzędnych.
  #align(center)[
    #image("transformations/ortho_project_teapot.png", width: 15cm)
  ]
]

#slide(title: [Przekształcenie skośne w 3D (Shearing)])[
  #set text(size: 0.9em)
  *Przekształcenie skośne* (ang. *shearing*, inaczej *pochylenie* lub *skoszenie*) w przestrzeni trójwymiarowej polega na przesunięciu punktów obiektu wzdłuż jednego kierunku proporcjonalnie do ich położenia w innym kierunku.
  Przekształcenie to zachowuje objętość, ale *zniekształca kąty i kształty* obiektu.
  #v(1em)
  Dla przykładu, jeśli przesuwamy współrzędne $x$ i $y$ proporcjonalnie do wartości $z$, to:
  #align(center)[
    $
      x' = x + k_"xz" z, quad
      y' = y + k_"yz" z, quad
      z' = z
    $
  ]
  W postaci macierzowej:
  #align(center)[
    $
      S_{z}(k_"xz", k_"yz") =
      mat(
        1, 0, k_"xz";
        0, 1, k_"yz";
        0, 0, 1
      )
    $
  ]
  gdzie $k_"xz"$ i $k_"yz"$ określają stopień pochylenia względem osi $z$.
  #v(1em)
  Ogólnie istnieje sześć możliwych macierzy przekształceń skośnych w 3D — w zależności od tego, względem której osi wykonywane jest pochylenie:
  #align(center)[
    $
      S_{x}(k_"xy", k_"xz") =
      mat(1, k_"xy", k_"xz"; 0, 1, 0; 0, 0, 1)
      quad
      S_{y}(k_"yx", k_"yz") =
      mat(1, 0, 0; k_"yx", 1, k_"yz"; 0, 0, 1)
      quad
      S_{z}(k_"zx", k_"zy") =
      mat(1, 0, 0; 0, 1, 0; k_"zx", k_"zy", 1)
    $
  ]
  #v(1em)
  *Własności przekształcenia skośnego:*
  - zachowuje objętość, ale nie zachowuje kątów ani kształtów,
  - jest liniowym przekształceniem (determinant macierzy = 1),
  - w połączeniu ze skalowaniem może imitować rotację z deformacją.
]

#slide(title: [Przykład — przekształcenie skośne względem osi Z])[
  #set text(size: 0.9em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #align(center)[
        $
          S_{z}(0.5, 0.3) =
          mat(
            1, 0, 0.5;
            0, 1, 0.3;
            0, 0, 1
          )
        $
      ]
      Dla tego przekształcenia punkty przesuwają się proporcjonalnie do swojej współrzędnej $z$, tworząc efekt „pochylenia” obiektu w kierunku osi $x$ i $y$.
    ],
    [
      #image("transformations/shear3d.png")
    ],
  )
]

#slide(title: [Łączenie transformacji])[
  #set text(size: 0.9em)
  W praktyce przekształcenia obiektów w grafice komputerowej rzadko wykonuje się pojedynczo.
  Najczęściej stosuje się ich *sekwencję* — np. *skalowanie*, potem *rotację*.
  Aby uprościć obliczenia, można je połączyć w jedną macierz transformacji.
  #v(1em)
  *Zasada łączenia:*
  Jeśli mamy dwie macierze transformacji:
  #align(center)[
    $A$ — pierwsza transformacja (np. skalowanie), \
    $B$ — druga transformacja (np. rotacja),
  ]
  to ich złożenie (czyli zastosowanie jednej po drugiej) opisuje macierz:
  #align(center)[
    $M = B ⋅ A$
  ]
  #v(1em)
  Kolejność jest *istotna* — najpierw stosujemy transformację $A$, potem $B$.
  Mnożenie macierzy *nie jest przemienne*, więc $B ⋅ A ≠ A ⋅ B$.
  #v(4em)
  *Przykład:*
  #align(center)[
    $
      S = physica.dmat(2, 1, 1, delim: "(", fill: 0), quad
      R_z(90°) =
      mat(
        0, -1, 0;
        1, 0, 0;
        0, 0, 1
      )
    $
  ]
  #v(0.5em)
  Kolejność zastosowania:
  #v(0.5em)
  #align(center)[
    $M_"RS" = R_z ⋅ S$  ⟹  najpierw skalowanie, potem rotacja \
    $M_"SR" = S ⋅ R_z$  ⟹  najpierw rotacja, potem skalowanie \
    #v(2em)
    $M_"RS" = mat(
      0, -1, 0;
      2, 0, 0;
      0, 0, 1
    )$
    $M_"SR" = mat(
      0, -2, 0;
      1, 0, 0;
      0, 0, 1
    )$
  ]
  #v(5em)
  Wyniki tych dwóch operacji różnią się geometrycznie. Przykład dla sześcianu.
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #align(center)[
        #image("transformations/composition.png")
      ]
    ],
    [
      #align(center)[
        $A = (0,0,0) \
        B = (1,0,0) \
        C = (1,1,0) \
        D = (0,1,0) \
        E = (0,0,1) \
        F = (1,0,1) \
        G = (1,1,1) \
        H = (0,1,1)$
      ]
    ],
  )
  #v(2em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #image("transformations/composition_scale_then_rotate.png")
      #align(center)[#text(size: 0.8em, "Najpierw skalowanie, potem rotacja")]
    ],
    [
      #image("transformations/composition_rotate_then_scale.png")
      #align(center)[#text(size: 0.8em, "Najpierw rotacja, potem skalowanie")]
    ],
  )
  #v(2em)
  *Podsumowanie:*
  - Kolejność mnożenia macierzy decyduje o wyniku.
  - Mnożenie macierzy jest sposobem *komponowania* transformacji.
  - Można więc złożyć złożone przekształcenia w jedną macierz i stosować ją jednokrotnie.
]

#slide(title: [Zastosowania przekształceń liniowych w 3D])[
  #set text(size: 0.9em)
  Przekształcenia liniowe stanowią podstawowy element grafiki komputerowej 3D, umożliwiając opis i kontrolę położenia, orientacji oraz kształtu obiektów w przestrzeni.
  W praktyce wykorzystywane są w wielu dziedzinach technologii i nauki.
  #v(1em)
  *Najważniejsze zastosowania:*
  - *Modelowanie 3D* — skalowanie, obrót i odbicie pozwalają na tworzenie złożonych obiektów poprzez transformacje prostych brył.
  - *Animacja komputerowa* — płynne ruchy i deformacje obiektów wynikają z sekwencji transformacji liniowych (np. macierze kości w animacjach szkieletowych).
  - *Grafika w grach* — przekształcenia obiektów względem kamery i sceny w czasie rzeczywistym (tzw. *world*, *view* i *projection matrices*).
  - *Symulacje fizyczne* — opis ruchu brył sztywnych, zderzeń i przemieszczeń w przestrzeni.
  - *Przetwarzanie obrazu i wizualizacja danych* — rotacje, skalowania i rzuty w systemach CAD, GIS oraz oprogramowaniu inżynierskim.
  #v(0.5em)
  *Podsumowanie:*
  Przekształcenia liniowe umożliwiają precyzyjne opisywanie i modyfikowanie przestrzeni trójwymiarowej.
  Dzięki nim grafika komputerowa łączy matematykę i geometrię z praktyczną wizualizacją rzeczywistości.
]

#slide(title: [Zastosowania przekształceń w praktyce])[
  #place(dx: 2%, dy: 5%)[
    #image("transformations/game.jpg", width: 10cm)
  ]
  #place(dx: 50%, dy: 10%)[
    #image("transformations/animation.jpg", width: 10cm)
  ]
  #place(dx: 15%, dy: 55%)[
    #image("transformations/cad.png", width: 10cm)
  ]
  #place(dx: 70%, dy: 60%)[
    #image("transformations/monkey.png", width: 7cm)
  ]
]

#slide(title: [])[
  #set text(size: 4em)
  #align(center)[
    *Dziękujemy za uwagę.*
  ]
]

#slide(title: [Bibliografia])[
  #bibliography("bibliography.bib", full: true)
]
