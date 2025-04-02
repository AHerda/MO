# zadanie 2

Niech X, Y zbiory wypukłe,
$$Z = X\cap Y \wedge (\forall a,b\in Z)(a,b\in X\wedge a,b\in Y)\implies\\(\forall a,b\in Z)(\forall\lambda\in [0, 1])(\lambda a + (1 -\lambda)b\in X\wedge \lambda a+ (1 - \lambda)b \in Y \implies\\ \lambda a + (1-\lambda)b \in Z)$$

# Zadanie 3

Niech $x, y \in S_t \implies x, y\in S$  <br>
$\lambda \in [0,1]$
$$c(\lambda x + (1-\lambda)y) \leq\lambda c(x)+(1-\lambda)c(y) \leq t \implies \\ \lambda c(x) + (1-\lambda)c(y) \in S_t$$

# Zadanie 6

$f$ wypukła oraz $h$ wypukła i niemalejąca
* $$ f: \mathbb{R}^n \to \mathbb{R} $$
* $$ h: \mathbb{R} \to \mathbb{R} $$
* $$ g(x) = h(f(x)) : \mathbb{R}^n \to \mathbb{R} $$
<br><br>
$$
    g(\lambda x + (1- \lambda)y) = \\ h(f(\lambda x + (1-\lambda)y)) \leq $$

z monotoniczności $h$ i wypukłości $f$

$$ h(\lambda f(x) + (1-\lambda)f(y)) \leq \\ \lambda h(f(X)) + (1-\lambda)h(f(y)) = \\ \lambda g(x) + (1-\lambda) g(y)
$$

# Zadanie 9

a) $f(x, y) = xy$,  $S = \mathbb{R}^2$
Funkcja jest wklęsła, kontrprzykład:

$$
\lambda = \frac{1}{2},\\
a = (1,-1),\\
b = (-1,2),\\
$$

<br><br>

$$
f(1, -1) = -1 = f(-1, 1) \\
f(\frac{1}{2} (1,-1) + \frac{1}{2} (-1,1)) = f(0,0) = 0 > \frac{1}{2} f(1,-1) + \frac{1}{2}f(-1,1)=-1
$$

