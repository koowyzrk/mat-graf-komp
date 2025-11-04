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
#set text(size: 18pt)

#title-slide()

#slide()[
  + Czym jest przekształcenie liniowe - typy przekształceń.
  + Rotacja. 
    - Rotacja wokół osi kardynalnych.
    - Rotacja wokół dowolnej osi.
  + Skalowanie.
    - Skalowanie wokół osi kardynalnych.
    - Skalowanie wokół dowolnej osi.
  + Projekcja ortograficzna.
    - Rzutowanie na oś kardynalną lub płaszczyznę.
    - Rzutowanie na dowolną linię lub płaszczyznę.
  + Odbicie.
  + Shearing.
  + Łączenie transformacji.
]

#slide(title: [Przekształcenia geometryczne])[
  #definition-box(title: [Pojęcie przekształcenia geometrycznego])[
    Przekształcenie $T$ to funkcja która przekształca punkt $A$ do
    innego punktu $T(A)$.
  ]
  #figure(
    table(
      fill: (x, y) => if ( x == 1 and y == 2 ) or (x == 1 and y == 6)
      { gray },
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
      Porównanie właściwości różnych przekształceń geometrycznych.
      \ Brak ptaszka oznacza - "nie zawsze".
    ]
  ) <lol>
]

#slide(title: [Przestrzeń liniowa])[
  #definition-box(title: [ Przestrzeń wektorowa (liniowa) - definicja ])[
    *Przestrzenią liniową* nazywamy trójkę $(V, +, dot)$, w której $V$ jest niepustym zbiorem
    oraz $ +: V times V -> V #h(4em) dot: bb(R) times V -> V, $
    są funkcjami spełniającymi następujące warunki:

    #set text(size: 20pt)

    + $forall_(x,y,z in V) #h(1em) (x, y) + z = x + (y = z), $
    + $exists_(theta in V) forall_(x in V) #h(1em) x + theta = x,$
    + $forall_(x in V) exists_(-x in V) #h(1em) x + (-x) = theta,$
    + $forall_(x, y in V) #h(1em) x + y = y + x,$
    + $forall_(x in V) #h(1em) 1 · x = x,$
    + $forall_(alpha, beta in bb(R)) forall_(x in V) #h(1em) (alpha + beta) · x = alpha · x + beta · x,$
    + $forall_(alpha in bb(R)) forall_(x, y in V) #h(1em) alpha · (x + y) = alpha · x + alpha · y,$
    + $forall_(alpha, beta in bb(R)) forall_(x in V) #h(1em) (alpha beta) · x = alpha · (beta · x).$

    - Elementy zbioru $V$ nazywamy wektorami.
    - Wektor $theta$ nazywamy wektorem zerowym
    - ...
    @rog
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
    Mówimy, że wektory $x_1, x_2, ..., x_n in V $ tworzą *bazę* przestrzeni liniowej
    $(V, +, dot)$, jeżeli są one liniowo niezależne i rozpinają przestrzeń $(V, +, dot)$.
  ]

  Przykład wektorów, które są bazą przestrzeni liniowej 3 wymiarowych wektorów:

  $ { vec(1, 0, 0), vec( 0, 1, 0 ), vec( 0, 0, 1 ) }, $
  $ { vec( 1, 3, 0 ), vec( 0, 0.5, 0 ), vec( 0, 0, 2) } $
  Przykład wektorów, które *nie* są bazą przestrzeni liniowej 3 wymiarowych wektorów:
  $ { vec( -1, 12, 1 ), vec( 1, 2, 1 ), vec( -1, 5, 0 ) } $
  $ { vec( 0, 1, 0 ), vec( 1, 0, 1 ), } $

]

#slide(title: [Przekształcenie liniowe])[
  #definition-box(title: [Przekształcenie liniowe])[
    Niech $(V, +, dot)$ i $( W, +, dot )$ będą przestrzeniami liniowymi.
    \
    Odwzorowanie (funkcje) $T: V -> W$ nazywamy liniowym, jeżeli
    + $forall_(x in V) #h(3.3em) T(u + v) = T(u) + T(v)$ #h(7em) (przekształcenie addytywne)
    + $forall_(x in V) forall_(alpha in bb(R)) #h(1em) T(alpha v) = alpha T(v)$  #h(10.745em) (przekształcenie jednorodne)
  ]

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
  Stosując przekształcenie liniowe na liniowej kombinacji wektorów opisujących
  wektor $arrow(v)$ możemy zapisać:
  $ T(arrow(v)) = 3T vec(1, 0, 0) + 5T vec(0, 1, 0) + 2T vec(0, 0, 1) $
  Innymi słowy aby dowiedzieć się gdzie wektor $arrow(v)$ zostanie przekształcony,
  musimy dowiedzieć się gdzie wektory $vec(1, 0, 0), vec(0, 1, 0), vec(0, 0, 1)$ zostaną
  przekształcone.

  \
  \
  \
  \
  \
  \
  Niech $T$ będzie przekształceniem liniowym, które jest opisane następującym wzorem:
  #align(center)[
    #grid(columns: 3, gutter: 100pt,
  $ T vec(1, 0, 0) = vec(-1, 4, 2), $, $ T vec(0, 1, 0) = vec(3, 2, 1), $, $ T vec(0, 0, 1) = vec(1, 4, 3) $
  )]

  \
  To dla wektora $arrow(v) = vec(3, 5, 2)$:

  \
  $ T(arrow(v)) = 3T vec(1, 0, 0) + 5T vec(0, 1, 0) + 2T vec(0, 0, 1) =
    3 vec(-1, 4, 2) + 5 vec(3, 2, 1) + 2 vec(1, 4, 3) = vec(17, 40, 17) $

  Powyższe przekształcenie można zapisać w formie macierzy:
  $ M = mat(-1, 3, 1; 4, 2, 4;2, 1, 3) $
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
    Punkty A, B, C po przekształceniu można zapisać w formie macierzy $B = mat(5, -1, 9; -2, 4, 2; 6, -1, 2)$

    \

    Aby znaleźć Macierz $M = mat(a, b, c;d, e, f; g, h, i)$ reprezentującą to
    przekształcenie musimy obliczyć układ równań
    #figure(
      [
        #align(center)[
          #grid(columns: 3, gutter: 50pt,
          $ a + 2b + 3c = 5, $,
          $ d + 2e + 3f = -2, $,
          $ g + 2h + 3i = 6,  $
        )]
        #align(center)[
          #grid(columns: 3, gutter: 50pt,
          $ 3a + 7b + 4c = -1, $,
          $ 3d + 7e + 4f = 4, $,
          $ 3g + 7h + 4i = 8,  $
        )]
        #align(center)[
          #grid(columns: 3, gutter: 50pt,
          $ 2a + 9b + 3c = 9, $,
          $ 2d + 9e + 3f = 2, $,
          $ 2g + 9h + 3i = 3, $
        )]
      ])
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

#slide(title: [Przekształcenia przykład])[
  Przykład różnicy transformacji liniowej od afinicznej dla sześcianu,
  rozpiętego na punktach: $ A = {0, 0, 0}, B = {1, 1, 1} $


  #align(center)[
    #grid(columns: 2, gutter: 80pt,
      [
        Przekształcenie liniowe
        $ lambda(x, y, z) = (2x, 3y, z) $
        $ lambda(B) = {2 dot 1, 3 dot 1, 1} = { 2, 3, 1 } $
        $ underbrace( lambda(A) = {2 dot 0, 3 dot 0, 0} = { 0, 0, 0 }) $
        $f(arrow(theta)) = arrow( theta )$
      ],
      [
        Przekształcenie afiniczne
        $ phi(x, y, z) = (2x + 1, 3y - 2, z) $
        $ phi(B) = {2 dot 1 + 1, 3 dot 1 - 2, 1} = { 3, 1, 1 } $
        $ underbrace( phi(A) = {2 dot 0 + 1, 3 dot 0 - 2, 0} = { 1, -2, 0 } ) $
        $f(arrow(theta)) = arrow(b) $
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
  Przekształcenia wchodzące w skład przekształceń liniowych: #h(11em) @lol
  - Rotacja
  - Skalowanie
  - Rzut ortograficzny
  - Odbicie
  - Shear
  #align(center)[
    #grid(
      columns: 2,
      align: left,
      figure(image("images/rotate.png", width: 80%), caption: [Rotacja]),
      figure(image("images/scale.png", width: 80%), caption: [Skalowanie]),
      figure(image("images/ortho.png", width: 60%), caption: [Rzut ortograficzny]),
      figure(image("images/reflect.png", width: 60%), caption: [Odbicie]),
      figure(image("images/shear.png", width: 60%), caption: [Shear]),
    )
  ]

]

#slide(title: [Rotacja w 3d])[


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
      $M_z = mat(cos theta, -sin theta, 0;
                 sin theta, cos theta, 0;
                 0, 0, 1)$,
      $M_y = mat(cos theta, 0, sin theta;
                 0, 1, 0;
                 -sin theta, 0, cos theta)$,
      $M_x = mat(1, 0, 0;
                 0, cos theta, -sin theta;
                 0, sin theta, cos theta)$,
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

  $ R = R_(z)(alpha) R_(y)(beta) R_(x)(gamma) = 
    mat(cos theta, -sin theta, 0;sin theta, cos theta, 0;0, 0, 1)
    mat(cos theta, 0, sin theta;0, 1, 0;-sin theta, 0, cos theta)
    mat(1, 0, 0;0, cos theta, -sin theta;0, sin theta, cos theta) =
  $
  $ = mat(cos alpha cos beta, cos alpha sin beta sin gamma - sin alpha cos gamma, cos alpha sin beta cos gamma + sin alpha sin gamma;
        sin alpha cos beta, sin alpha sin beta sin gamma + cos alpha cos gamma, sin alpha sin beta cos gamma - cos alpha sin gamma;
        - sin beta, cos beta sin gamma, cos beta cos gamma
  )  $

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
    $arrow(a) = vec(a_x, a_y, a_z), $ czyli takiego którego długość jest równa
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

    $ M_(a r b) = mat(
      c + (1 - c) a_x^2, (1-c) a_x a_y - s a_z, (1-c) a_x a_z + s a_y;
      (1 -c) a_x a_y + s a_z, c+(1-c)a_y^2, (1-c)a_y a_z - s a_x;
      (1-c)a_x a_z -s a_y, (1 - c) a_y a_z + s a_x, c + (1 -c) a_z^2;
    ) $

  ]

  #align(center)[
    #figure(
      image("images/rotate_vec.png", width: 38%), caption: [Rotacja wokół wektora $arrow(v) = vec(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3)$, o 90 stopni.]
    )
  ]

  Rotacja jako odwzorowanie w przestrzeni liniowej, zachowuje kąty, długości wektorów
  powierzchnie i objętości figur.
]

#slide(title: [Bibliography])[
  #bibliography("bibliography.yml")
]
