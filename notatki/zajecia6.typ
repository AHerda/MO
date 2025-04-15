#import "@preview/cetz:0.3.2": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot

#align(top + center)[
  #text(size: 24pt, [Metody Optymalizacji \ Ćwiczenia 6])

  *Adrian Herda*

  #datetime.today().display()
]

= Zadanie 10

Jest to nieprawda. Kontrprzykład:

$
  max y \
  x,y lt.eq 2 \
  x,y gt.eq 1
$

#canvas({
  plot.plot(
    size: (3, 3),
    axis-style: "left", //"school-book",
    y-min: 0,
    y-max: 3,
    x-min: 0,
    x-max: 3,
    x-tick-step: 0.5,
    y-tick-step: 0.5,
    minor-tick-step: none,
    domain: (0, 3),

    {
      plot.add(((1,2),(2,2)), style: (stroke: black))
      plot.add(((1,1),(2,1)), style: (stroke: black))
      plot.add(((1,1),(1,2)), style: (stroke: black))
      plot.add(((2,1),(2,2)), style: (stroke: black))
      plot.add-fill-between(
        x => 1,
        x => 2,
        domain: (1,2)
      )
    }
  )
})

= Zadanie 11

- $min {c^T x: A x = b, x gt.eq 0}$
- $min {c^T x + 1^T A x: A x = b, x gt.eq 0}$

$"anymin"_(x in X) f(x) + k = "anymin"_(x in X) f(x)$ -- gdzie k to stała \
$X^*$ -- zbiór rozwiązań optymalnych \
$arrow.double.long bb(1)^T A x = bb(1)^T b$ -- stała


= Zadanie 7
\


$ min x dot y $
#canvas({
  plot.plot(
    size: (3,3),
    y-min: 0,
    y-max: 7,
    x-min: 0,
    x-max: 7,
    x-tick-step: 1,
    axis-style: "left",
    {
      let f1(x) = 4 - x
      let f2(x) = x / 2 + 3
      plot.add(f1, domain: (0, 7), style: (stroke: black))
      plot.add(f2, domain: (0, 7), style: (stroke: black))
      plot.add(x => x + 2, domain: (0, 7), style: (stroke: black))
      plot.add(((2,0),(2,7)), style: (stroke: black))
      plot.add-fill-between(domain: (2, 7), f1,f2)
    }
  )
})

$ min (x,y) = (2, 2) $
