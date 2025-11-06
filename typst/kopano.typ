#import "@preview/definitely-not-isec-slides:1.0.1": *
#import "@preview/pavemat:0.2.0": pavemat
#import "@preview/physica:0.9.6"
#import "@preview/plotsy-3d:0.2.1": *
#import "@preview/pinit:0.2.2": *
#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *

#show: show-theorion
#show: definitely-not-isec-theme.with(
  aspect-ratio: "4-3",
  slide-alignment: top,
  progress-bar: true,
  institute: [Politechnika Łódzka],
  logo: image("uni_logo/uni_logo.png", width: 5cm),
  config-info(
    title: [Przekształcenia liniowe w 3D \ Rotacja,Skalowanie,Odbicie],
    authors: ([Jan Banaszkiewicz], [Jakub Kopaniewski]),
    extra: [*Matematyka Grafiki Komputerowej*],
    footer: [Jan Banaszkiewicz, Jakub Kopaniewski],
  ),
  config-common(
    handout: false,
  ),
  config-colors(
    primary: rgb("7C2529"),
  ),
)
#set text(size: 18pt)
// #set text(size: 0.9em)

#title-slide()
#slide(title: [Agenda])[
  + Rodzaje przekształceń geometrycznych.
  + Czym jest przestrzeń liniowa.
  + Czym jest przekształcenie liniowe - typy przekształceń.
  + Rotacja.
  + Skalowanie.
  + Odbicie.
  + Rzut równoległy (Orthographic projection).
  + Przekształcenie skośne (Shearing).
  + Łączenie transformacji.
]

#slide(title: [Przekształcenia geometryczne])[
  #definition-box(title: [Pojęcie przekształcenia geometrycznego])[
    Przekształcenie $T$ to funkcja która przekształca punkt $A$ do
    innego punktu $T(A)$.
  ]
  #figure(
    table(
      fill: (x, y) => if (x == 1 and y == 2) or (x == 1 and y == 6) { gray },
      columns: 5,
      stroke: .5pt,
      align: (left, center, center, center, center, center),
      [*Przekształcenie*], [*Liniowe*], [*Afiniczne*], [*Odwracalne*], [*Zachowuje kąty*],
      [Transformacja liniowa], [✔️], [✔️], [], [],
      [Transformacja afiniczna], [], [✔️], [], [],
      [Transformacja odwracalna], [], [], [✔️], [],
      [Zachowujące kąty], [], [✔️], [✔️], [✔️],
      [Ortogonalna], [], [✔️], [✔️], [],
      [Translacja], [], [✔️], [✔️], [✔️],
      [Rotacja], [✔️], [✔️], [✔️], [✔️],
      [Jednorodne skalowanie], [✔️], [✔️], [✔️], [✔️],
      [Niejednorodne skalowanie], [✔️], [✔️], [✔️], [],
      [Rzut ortograficzny], [✔️], [✔️], [], [],
      [Odbicie], [✔️], [✔️], [✔️], [],
      [Ścinanie (shear)], [✔️], [✔️], [✔️], [],
    ),
    caption: [
      Porównanie właściwości różnych przekształceń geometrycznych. \
      Brak ptaszka oznacza - "nie zawsze".
    ],
    numbering: none,
  )
]

#slide(title: [Przestrzeń liniowa])[
  #definition-box(title: [ Przestrzeń wektorowa (liniowa) - definicja ])[
    *Przestrzenią liniową* nazywamy trójkę $(V, +, dot)$, w której $V$ jest niepustym zbiorem
    oraz $ +: V times V -> V #h(4em) dot: bb(R) times V -> V, $
    są funkcjami spełniającymi następujące warunki:

    #set text(size: 20pt)

    + $forall_(x,y,z in V) #h(1em) (x + y) + z = x + (y + z),$
    + $exists_(theta in V) forall_(x in V) #h(1em) x + theta = x,$
    + $forall_(x in V) exists_(-x in V) #h(1em) x + (-x) = theta,$
    + $forall_(x, y in V) #h(1em) x + y = y + x,$
    + $forall_(x in V) #h(1em) 1 · x = x,$
    + $forall_(alpha, beta in bb(R)) forall_(x in V) #h(1em) (alpha + beta) · x = alpha · x + beta · x,$
    + $forall_(alpha in bb(R)) forall_(x, y in V) #h(1em) alpha · (x + y) = alpha · x + alpha · y,$
    + $forall_(alpha, beta in bb(R)) forall_(x in V) #h(1em) (alpha beta) · x = alpha · (beta · x).$

    - Elementy zbioru $V$ nazywamy wektorami.
    - Wektor $theta$ nazywamy wektorem zerowym
  ]

  // #definition-box()[
  //   #set text(size: 20pt)
  //   Elementy zbioru $bb(R)^n$: $bb(R)^n = {(p_1, p_2, ..., p_n): p_i in bb(R) "dla"
  //   i = 1, 2, ..., n}$ nazywamy punktami o współrzędnych $p_i$.
  //
  //   Przestrzenią wektorów swobodnych $V(bb(R)^n)$ nazywamy zbiór
  //   $ V(bb(R)^n) = {[v_1, v_2, ..., v_n]: v_i in bb(R) "dla" i = 1, 2, ..., n}, $
  //   w którym wprowadzono działania $ +: V(bb(R)^n) times V(bb(R)^n) -> V(bb(R)^n) " i "
  //   dot: bb(R) times V(bb(R)^n) -> V(bb(R)^n) $
  // ]
  //
  // #definition-box(title: [ Przestrzeń afiniczna - definicja ])[
  //   #set text(size: 20pt)
  //   Trójkę $ (P, V, +),$ gdzie P to zbiór punktów, V to przestrzeń liniowa,
  //   a "$+$" to odwzorowanie opisane: $ +: bb(R)^n times V(bb(R)^n ) -> bb(R)^n $
  //   zdefiniowanym wzorem $ P + v = (p_1, p_2, ..., p_n) + [v_1, v_2, ..., v_n] :=
  //   (p_1 + v_1, p_2 + v_2, ..., p_n + v_n) = Q, $
  //   nazywamy n-wymiarową przestrzenią afiniczną.
  //   @rog @kij
  // ]
]

#slide(title: [Baza przestrzeni liniowej])[
  #definition-box(title: [Baza przestrzeni liniowej])[
    Mówimy, że wektory $x_1, x_2, ..., x_n in V$ tworzą *bazę* przestrzeni liniowej
    $(V, +, dot)$, jeżeli są one liniowo niezależne i rozpinają przestrzeń $(V, +, dot)$.
  ]

  Przykład wektorów, które są bazą przestrzeni liniowej 3 wymiarowych wektorów:

  $ { vec(1, 0, 0), vec(0, 1, 0), vec(0, 0, 1) }, $
  $ { vec(1, 3, 0), vec(0, 0.5, 0), vec(0, 0, 2) } $
  Przykład wektorów, które *nie* są bazą przestrzeni liniowej 3 wymiarowych wektorów:
  $ { vec(-1, 12, 1), vec(1, 2, 1), vec(-1, 5, 0) } $
  $ { vec(0, 1, 0), vec(1, 0, 1) } $

]

#slide(title: [Przekształcenie liniowe])[
  #definition-box(title: [Przekształcenie liniowe])[
    Niech $(V, +, dot)$ i $( W, +, dot )$ będą przestrzeniami liniowymi.
    \
    Odwzorowanie (funkcje) $T: V -> W$ nazywamy liniowym, jeżeli
    + $forall_(x in V) #h(3.3em) T(u + v) = T(u) + T(v)$ #h(4em) (przekształcenie addytywne)
    + $forall_(x in V) forall_(alpha in bb(R)) #h(1em) T(alpha v) = alpha T(v)$  #h(7.745em) (przekształcenie jednorodne)
  ]

  #v(1em);
  #tip-box(title: "")[
    Warto zauważyć że ta definicja nie mówi nam nic o punktach, jednak dla rozpatrywanych
    przez nas transformacji liniowych (nie jest prawdą dla np. Transformacji
    nieliniowych), po oznaczeniu początku układu $O$, można myśleć o punktach
    $P$ jako o wektorze [$arrow(O P)$].
  ]

  \
  \
  \
  \
  \
  \
  \
  Możemy zapisać vector $arrow(v) = vec(3, 5, 2)$, jako liniową kombinację wektorów bazy.
  $ arrow(v) = vec(3, 5, 2) = 3 vec(1, 0, 0) + 5 vec(0, 1, 0) + 2 vec(0, 0, 1) $
  #v(2em)
  Stosując przekształcenie liniowe na liniowej kombinacji wektorów opisujących
  wektor $arrow(v)$ możemy zapisać:
  $ T(arrow(v)) = 3T vec(1, 0, 0) + 5T vec(0, 1, 0) + 2T vec(0, 0, 1) $
  #v(2em)
  Innymi słowy aby dowiedzieć się gdzie wektor $arrow(v)$ zostanie przekształcony,
  musimy dowiedzieć się gdzie wektory $vec(1, 0, 0), vec(0, 1, 0), vec(0, 0, 1)$ zostaną
  przekształcone.

  \
  \
  \
  Niech $T$ będzie przekształceniem liniowym, które jest opisane następującym wzorem:
  #align(center)[
    #grid(
      columns: 3,
      gutter: 100pt,
      $ T vec(1, 0, 0) = vec(-1, 4, 2), $, $ T vec(0, 1, 0) = vec(3, 2, 1), $, $ T vec(0, 0, 1) = vec(1, 4, 3) $,
    )]

  \
  To dla wektora $arrow(v) = vec(3, 5, 2)$:

  \
  $
    T(arrow(v)) = 3T vec(1, 0, 0) + 5T vec(0, 1, 0) + 2T vec(0, 0, 1) =
    3 vec(-1, 4, 2) + 5 vec(3, 2, 1) + 2 vec(1, 4, 3) = vec(17, 40, 17)
  $

  Powyższe przekształcenie można zapisać w formie macierzy:
  $ M = mat(-1, 3, 1; 4, 2, 4; 2, 1, 3) $
  Zatem powyższe przekształcenie możemy zapisać jako mnożenie wektora przez macierz:
  $ T(arrow(v)) = M dot vec(3, 5, 2) = mat(-1, 3, 1; 4, 2, 4; 2, 1, 3) vec(3, 5, 2) = vec(17, 40, 17) $

  Z powyższego przykładu można wywnioskować ogólną formułę aplikowania odwzorowań $T$.

  $ T(arrow(v)) = M arrow(v) $
  #example(title: [Przykład])[
    Niech $T$ będzie liniowym odwzorowaniem które przekształca
    $ "punkt" A = vec(1, 2, 3) "do" "postaci" T(A) = vec(5, -2, 6), $
    $ "punkt" B = vec(3, 7, 4) "do" "postaci" T(B) = vec(-1, 4, 8) $
    $ "i" "punkt" C = vec(2, 9, 3) "do" "postaci" T(C) = vec(9, 2, 3) $

    Punkty A, B, C przed przekształceniem można zapisać w formie macierzy $A = mat(1, 3, 2; 2, 7, 9; 3, 4, 3)$

    \
    Punkty A, B, C po przekształceniu można zapisać w formie macierzy $B = mat(5, -1, 9; -2, 4, 2; 6, -1, 2)$

    \

    Aby znaleźć Macierz $M = mat(a, b, c; d, e, f; g, h, i)$ reprezentującą to
    przekształcenie musimy obliczyć układ równań
    #figure(
      [
        #align(center)[
          #grid(
            columns: 3,
            gutter: 50pt,
            $ a + 2b + 3c = 5, $, $ d + 2e + 3f = -2, $, $ g + 2h + 3i = 6, $,
          )]
        #align(center)[
          #grid(
            columns: 3,
            gutter: 50pt,
            $ 3a + 7b + 4c = -1, $, $ 3d + 7e + 4f = 4, $, $ 3g + 7h + 4i = 8, $,
          )]
        #align(center)[
          #grid(
            columns: 3,
            gutter: 50pt,
            $ 2a + 9b + 3c = 9, $, $ 2d + 9e + 3f = 2, $, $ 2g + 9h + 3i = 3, $,
          )]
      ],
    )
  ]

  Powyższe równanie można policzyć  korzystając z właściwości macierzy:
  $ M A = B => M = B A^(-1) $
  $ M = B A^(-1) = mat(-213/22, 43/22, 79/22; 4/22, 0, -2; -137/22, 7/22, 85/22) $

  W taki sposób znaleźliśmy macierz przekształceń, którą można zastosować,
  dla każdego innego punktu.

  #example(title: [Przykład dla punktu $E = vec(3, 5, 7)$])[
    $ T(E) = M E = mat(-213/22, 43/22, 79/22; 4/22, 0, -2; -137/22, 7/22, 85/22) vec(3, 5, 7) = vec(129, -2, 219/22) $

  ]
]

#slide(title: [Przykład - różnica transformacji])[
  Przykład różnicy transformacji liniowej od afinicznej dla sześcianu,
  rozpiętego na punktach: $ A = {0, 0, 0}, B = {1, 1, 1} $


  #align(center)[
    #grid(
      columns: 2,
      gutter: 80pt,
      [
        Przekształcenie liniowe
        $ lambda(x, y, z) = (2x, 3y, z) $
        $ lambda(B) = {2 dot 1, 3 dot 1, 1} = { 2, 3, 1 } $
        $ underbrace(lambda(A) = {2 dot 0, 3 dot 0, 0} = { 0, 0, 0 }) $
        $f(arrow(theta)) = arrow(theta)$
      ],
      [
        Przekształcenie afiniczne
        $ phi(x, y, z) = (2x + 1, 3y - 2, z) $
        $ phi(B) = {2 dot 1 + 1, 3 dot 1 - 2, 1} = { 3, 1, 1 } $
        $ underbrace(phi(A) = {2 dot 0 + 1, 3 dot 0 - 2, 0} = { 1, -2, 0 }) $
        $f(arrow(theta)) = arrow(b)$
      ],
    )
  ]

  #align(center)[
    #grid(
      columns: 2,
      align: left,
      figure(image("images/cube1.png", width: 70%), caption: [Odwzorowanie liniowe]),
      figure(image("images/cube2.png", width: 70%), caption: [Odwzorowanie afiniczne]),
    )
  ]
]

#slide(title: [Rodzaje przekształceń liniowych])[
  Przekształcenia wchodzące w skład przekształceń liniowych: #h(11em)
  - Rotacja
  - Skalowanie
  - Odbicie
  - Rzut równoległy (Orthographic projection).
  - Przekształcenie skośne (Shearing).
  #align(center)[
    #grid(
      columns: 2,
      align: left,
      figure(image("images/rotate.png", width: 80%), caption: [Rotacja]),
      figure(image("images/scale.png", width: 80%), caption: [Skalowanie]),

      figure(image("images/ortho.png", width: 60%), caption: [Rzut równoległy]),
      figure(image("images/reflect.png", width: 60%), caption: [Odbicie]),

      figure(image("images/shear.png", width: 60%), caption: [Przekształcenie skośne]),
    )
  ]

]

#slide(title: [Rotacja w przestrzeni trójwymiarowej])[
  #figure(
    image("assets/Rotation_around_xaxis_3d.png", width: 80%),
    caption: [Rotacja wokół osi x w 3d],
  ) <fig-rotation_around_xaxis_3d>

  #align(center)[
    #grid(
      columns: 3,
      align: left,
      figure(image("assets/Rotation_around_z_axis.png", width: 90%), caption: [Rotacja wokół osi z (ang. yaw)]),
      figure(image("assets/Rotation_around_y_axis.png", width: 89%), caption: [Rotacja wokół osi y (ang. pitch)]),
      figure(image("assets/Rotation_around_x_axis.png", width: 84%), caption: [Rotacja wokół osi x (ang. roll)]),
    )
  ]
  \
  \
  #align(center)[
    #set text(size: 23pt)
    #grid(
      columns: 3,
      gutter: 28pt,
      align: left,
      $M_z = mat(
        cos theta, -sin theta, 0;
        sin theta, cos theta, 0;
        0, 0, 1
      )$,
      $M_y = mat(
        cos theta, 0, sin theta;
        0, 1, 0;
        -sin theta, 0, cos theta
      )$,
      $M_x = mat(
        1, 0, 0;
        0, cos theta, -sin theta;
        0, sin theta, cos theta
      )$,
    )
  ]
  #tip-box(title: "")[
    Zwróć uwagę, że wiersz macierzy reprezentujący oś po której obracamy elementy
    przestrzeni wektorowej, mają postać wektora jednostkowego.
  ]

  // W trójwymiarowym układzie współrzędnych można nie tylko obracać wokół osi
  // kartezjańskich, ale też wokół dowolnie wybranego wektora, który reprezentowałby
  // naszą nową oś.

  Stosując macierze rotacji można obrócić elementy przestrzeni wektorowej,
  wokół dowolnie wybranej osi.

  $
    R = R_(z)(alpha) R_(y)(beta) R_(x)(gamma) =
    mat(cos theta, -sin theta, 0; sin theta, cos theta, 0; 0, 0, 1)
    mat(cos theta, 0, sin theta; 0, 1, 0; -sin theta, 0, cos theta)
    mat(1, 0, 0; 0, cos theta, -sin theta; 0, sin theta, cos theta) =
  $
  $
    = mat(
      cos alpha cos beta, cos alpha sin beta sin gamma - sin alpha cos gamma, cos alpha sin beta cos gamma + sin alpha sin gamma;
      sin alpha cos beta, sin alpha sin beta sin gamma + cos alpha cos gamma, sin alpha sin beta cos gamma - cos alpha sin gamma;
      - sin beta, cos beta sin gamma, cos beta cos gamma
    )
  $

  #tip-box(title: "")[
    $ R_(z)(alpha) R_(y)(beta) R_(x)(gamma) != R_(y)(beta) R_(z)(alpha) R_(x)(gamma) != $
    $ R_(x)(gamma) R_(z)(alpha) R_(y)(beta) != R_(z)(alpha) R_(x)(gamma) R_(y)(beta) != $
    $ R_(y)(beta) R_(x)(gamma) R_(y)(alpha) != R_(y)(beta) R_(y)(beta) R_(y)(alpha) $
    Różna kolejność stosowania macierzy rotacji, spowoduje obrót wokół innej osi.
  ]

  \
  \
  \
  \
  #example(title: [Obrót wokół dowolnej osi])[
    Przypuśćmy że chcemy wykonać operacje rotacji wokół wektora jednostkowego
    $arrow(a) = vec(a_x, a_y, a_z),$ czyli takiego którego długość jest równa
    $|arrow(a)|^2 = a_x^2 + a_y^2 + a_z^2 = 1$, o postaci macierzy $M_(phi)$, o kąt $theta$.

    #figure(
      image("assets/Arbitrary_rotation.png", width: 30%),
    ) <fig-arbitrary-rotation>

    Aby tego dokonać, możemy znaleźć takie macierze rotacji, aby dopasować wektor
    $arrow(a)$ do jednej z osi układu współrzędnych, np. Osi z. Następnie zastosować
    Macierz rotacji dla osi do której sprowadziliśmy wektor $arrow(a)$.

    \
    \
    \
    \
    \
    Dla wektora $arrow(a)$ podanego na rysunku możemy to zrobić w następujący sposób:
    - Użyć macierzy rotacji wokół osi $X$ aby przekształcić wektor $arrow(a)$ do
      wektora oznaczonego na rysunku jako $arrow(b)$. W tym celu musimy znaleźć kąt
      pomiędzy wektorem $arrow(a)$ a osią $X$. Jeżeli $g = a_y^2 + a_z^2$
      $ cos alpha = a_z / g $
      Mając kąt $alpha$, możemy zastosować macierz rotacji dla osi $X$ aby
      przekształcić wektor do płaszczyzny $X Z$ czyli do postaci wektora $arrow(b)$.
      $ M_(x)(alpha) = mat(1, 0, 0; 0, a_z / g, -a_y/g; 0, a_y/g, a_z/g) $

      Zatem $ arrow(b) = M_(x)(alpha) dot arrow(a), $

    \
    \
    \
    \
    \

    - Następnie musimy przenieść wektor $arrow(b)$ do wektora położonego na wybranej osi,
      na rysunku nazwanego jako $arrow(c)$. W tym celu musimy znaleźć kąt pomiędzy
      wektorem $arrow(b)$ a osią $Z$.
      $ cos beta = g $
      Mając kąt $beta$, możemy zastosować macierz rotacji dla osi $Y$ aby
      przekształcić wektor do postaci wektora docelowego $arrow(c)$
      $ M_(y)(beta) = mat(g, 0, -a_x; 0, 1, 0; a_x, 0, g) $

      Zatem $ arrow(c) = M_(y)(beta) dot arrow(b), $

    - Ostatnim krokiem naszego algorytmu jest zastosowanie macierz rotacji wokół
      osi $Z$, tej którą chcieliśmy zastosować dla naszego wektora początkowego
      $arrow(a)$, oznaczoną wcześniej jako $M_(phi)$.
      $ arrow('a) = M_(phi) arrow(c) $

    W taki sposób możemy obrócić elementy przestrzeni liniowej wokół dowolnego wektora.
    Ogólna postać tego algorytmu to macierz $M_(a r b)$ podana wzorem:
    $ M_(a r b) = M_x^(-1)(alpha) M_y^(-1)(beta) M_(z)(theta) M_(y)(beta) M_(x)(alpha) $

    $
      M_(a r b) = mat(
        c + (1 - c) a_x^2, (1-c) a_x a_y - s a_z, (1-c) a_x a_z + s a_y;
        (1 -c) a_x a_y + s a_z, c+(1-c)a_y^2, (1-c)a_y a_z - s a_x;
        (1-c)a_x a_z -s a_y, (1 - c) a_y a_z + s a_x, c + (1 -c) a_z^2;
      )
    $

  ]

  #align(center)[
    #figure(
      image("images/rotate_vec.png", width: 38%),
      caption: [Rotacja wokół wektora $arrow(v) = vec(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3)$, o 90 stopni.],
    )
  ]

  Rotacja jako odwzorowanie w przestrzeni liniowej, zachowuje kąty, długości wektorów
  powierzchnie i objętości figur.
]

#slide(title: [Skalowanie w przestrzeni trójwymiarowej])[
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
  #v(4em)
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
  // #set text(size: 0.9em)
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
  // #set text(size: 1.0em)
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
  #v(8em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      *Obliczenia:*
      \
      Dla punktu $P = vec(1, 0, 0)$ oraz
      \
      \
      macierzy:
      $S = physica.dmat(2, 2, 2, delim: "[", fill: 0)$
      #v(2em)
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

#slide(title: [Skalowanie niejednolite])[
  // //#set text(size: 0.9em)
  Jeśli chcemy „rozciągnąć” lub „ściśnąć” obiekt, możemy zastosować różne współczynniki skalowania w różnych kierunkach.
  Takie przekształcenie nazywamy *skalowaniem niejednolitym*.
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

  #v(10em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      *Obliczenia:*
      Dla punktu $P = vec(1, 0, 0)$

      oraz macierzy:
      $S = physica.dmat(2, 0.5, 1.5, delim: "[", fill: 0)$
      mamy:
      $ P' = S ⋅ P = vec(1 ⋅ 2 + 0 ⋅ 0 + 0 ⋅ 0, 1 ⋅ 0 + 0 ⋅ 0.5 + 0 ⋅ 0, 1 ⋅ 0 + 0 ⋅ 0 + 0 ⋅ 1.5) = vec(2, 0, 0) $
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

    [
      #image("transformations/scale_notuniform_1.png", width: 10cm)
      #align(center)[#text(size: 0.8em, "Sześcian przed skalowaniem (długość boku = 1)")]
    ],
    [
      #image("transformations/scale_notuniform.png", width: 10cm)
      #align(center)[#text(size: 0.8em, "Sześcian po skalowaniu o róźne współczynniki k")]
    ],
  )
]

#slide(title: [Skalowanie wzdłuż jednej osi])[
  //#set text(size: 0.9em)
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
  //#set text(size: 0.9em)
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
  $
    physica.vu(n) = vec(n_x, n_y, n_z) => physica.vu(n)physica.vu(n)^T = mat(n_x^2, n_x n_y, n_x n_z; n_y n_x, n_y^2, n_y n_z; n_z n_x, n_z n_y, n_z^2)
  $

  #v(7em)
  Po podstawieniu do $ S = I + (k - 1)physica.vu(n)physica.vu(n)^T, $ otrzymujemy:
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
  //#set text(size: 0.9em)
  Załóżmy, że chcemy skalować wzdłuż kierunku ukośnego, który leży w płaszczyźnie XY i biegnie pod kątem 45° do osi X oraz dla współczynnika skali $k = 2$. \
  Ten kierunek opisuje wektor:
  #v(1em)
  #align(center)[
    $physica.va(n) = vec(1, 1, 0),$
  ]
  #v(1em)
  który nie jest wektorem jednostkowym więc musimy go znormalizować. Jego długość teraz wynosi:
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
  #v(1.2em)
  Po podstawieniu do równania na $S$:
  #align(center)[
    $S = mat(1, 0, 0; 0, 1, 0; 0, 0, 1) + (2 - 1) ⋅ frac(1, 2) mat(1, 1, 0; 1, 1, 0; 0, 0, 0)$
  ]
  Ostatecznie:
  #align(center)[
    $S = mat(1.5, 0.5, 0; 0.5, 1.5, 0; 0, 0, 1)$
  ]
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
  //#set text(size: 0.9em)
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
  //#set text(size: 0.9em)
  Rozważmy odbicie względem płaszczyzny XY, której wektor normalny to:
  $
    physica.vu(n) = vec(0, 0, 1),
    "Macierz odbicia:"
    R = mat(
      1, 0, 0;
      0, 1, 0;
      0, 0, -1
    )
  $
  #h(10em) Dla wierzchołków piramidy mamy:
  #align(center)[
    #grid(
      gutter: 100pt,
      columns: 2,
      [$
        physica.vecrow(0, -0.5, 0, delim: "[") → physica.vecrow(0, -0.5, 0, delim: "[") \
        physica.vecrow(-0.5, 0, 0, delim: "[") → physica.vecrow(-0.5, 0, 0, delim: "[") \
        physica.vecrow(0, 0.5, 0, delim: "[") → physica.vecrow(0, 0.5, 0, delim: "[") \
        physica.vecrow(0.5, 0, 0, delim: "[") → physica.vecrow(0.5, 0, 0, delim: "[") \
        physica.vecrow(0, 0, 1, delim: "[") → physica.vecrow(0, 0, -1, delim: "[")
      $],
      [
        #image("transformations/piramid_refl.png", width: 16cm)
      ],
    )
  ]
  Wierzchołki leżące w płaszczyźnie XY pozostają niezmienione, natomiast punkt znajdujący się powyżej zostaje odbity symetrycznie poniżej niej.
]

#slide(title: [Rzut równoległy jako przypadek skalowania])[
  //#set text(size: 0.9em)
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
  //#set text(size: 0.9em)
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
  //#set text(size: 0.9em)
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
  // #v(1em)
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
  #v(3em)
  *Własności przekształcenia skośnego:*
  - zachowuje objętość, ale nie zachowuje kątów ani kształtów,
  - jest liniowym przekształceniem (determinant macierzy = 1),
  - w połączeniu ze skalowaniem może imitować rotację z deformacją.
  // ]

  // #slide(title: [Przykład — przekształcenie skośne względem osi Z])[
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
      #image("transformations/shear3d.png", width: 80%)
    ],
  )
]

#slide(title: [Łączenie transformacji])[
  //#set text(size: 0.9em)
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
  #v(12em)
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
  Kolejność zastosowania:
  \
  $ M_"RS" = R_z ⋅ S => "najpierw skalowanie, potem rotacja" $
  $ M_"SR" = S ⋅ R_z => "najpierw rotacja, potem skalowanie" $
  $
    M_"RS" = mat(
      0, -1, 0;
      2, 0, 0;
      0, 0, 1
    ),
    M_"SR" = mat(
      0, -2, 0;
      1, 0, 0;
      0, 0, 1
    )
  $
  Wyniki tych dwóch operacji różnią się geometrycznie. Przykład dla sześcianu.
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0em,
    [
      #align(center)[
        #image("assets/comp.png", width: 56%),
      ]

    ],
    [
      #align(center)[
        $$
        $$
        $ A = (0,0,0), B = (1,0,0) $
        $ C = (1,1,0), D = (0,1,0) $
        $ E = (0,0,1), F = (1,0,1) $
        $ G = (1,1,1), H = (0,1,1) $
      ]
    ],
  )
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
  //#set text(size: 0.9em)
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
  #set text(size: 7em)
  #align(center)[
    *Dziękujemy za uwagę.*
  ]
]

#slide(title: [Bibliografia])[
  #bibliography("bibliography.bib", full: true)
]
