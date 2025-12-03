use crate::vector::{Vec3, VectorTrait};

pub enum Intersection {
    Point(Vec3),
    Parallel,
    Colinear,
    Skew,
}

pub struct Line {
    pub point: Vec3,
    pub direction: Vec3,
}

pub struct Plane {
    pub point: Vec3,
    pub normal: Vec3,
}

pub struct Sphere {
    pub center: Vec3,
    pub radius: f32,
}

impl Line {
    pub fn intersects(&self, other: &Line) -> Intersection {
        let p = self.point;
        let q = other.point;
        let v = self.direction;
        let w = other.direction;

        let pq = q.sub(&p);
        let cross_vw = v.cross(w);

        // wykrywanie równoległości
        if cross_vw.length() == 0.0 {
            // sprawdzenie wpółliniowości
            if pq.cross(v).length() == 0.0 {
                return Intersection::Colinear;
            } else {
                return Intersection::Parallel;
            }
        }

        // obliczamy parametr t ze wzoru
        let t = pq.cross(w).dot(&cross_vw) / cross_vw.dot(&cross_vw);
        // dodajemy do punktu P nasz wektor(v) przesunięty o t
        // P0 ----->----->----->-----
        //       t=1     t=2
        let intersection_point = p.add(&v.scale(t));

        // wektor od punktu początkowego prostej do punktu przecięcia
        let diff = intersection_point.sub(&q);
        // sprawdzamy czy dany punkt jest równoległy do wektora(w)
        if diff.cross(w).length() == 0.0 {
            Intersection::Point(intersection_point)
        } else {
            Intersection::Skew
        }
    }
}

impl Plane {
    pub fn intersect_planes(a: &Plane, b: &Plane) -> Option<Line> {
        let direction = a.normal.cross(b.normal);

        if direction.length() == 0.0 {
            return None; // równoległe lub identyczne
        }

        let n1 = a.normal;
        let n2 = b.normal;
        let p1 = a.point;
        let p2 = b.point;

        // znajdź dowolny punkt przecięcia poprzez rozwiązanie:
        // n1·x = n1·p1
        // n2·x = n2·p2
        let n1xn2 = n1.cross(n2);
        let numerator = n2.scale(n1.dot(&p1)).cross(n1) + n1.scale(n2.dot(&p2)).cross(n2);

        let point = numerator.scale(1.0 / n1xn2.dot(&n1xn2));

        Some(Line { point, direction })
    }

    pub fn intersect_line(&self, line: &Line) -> Option<Vec3> {
        let n = self.normal;
        // punkt przez który przedzodzi płaszczyzna
        let p0 = self.point;
        // punkt przez który przechodzi prosta
        let l0 = line.point;
        let v = line.direction;

        let denom = n.dot(&v);

        // równoległa do płaszczyzny
        if denom.abs() < 1e-6 {
            return None;
        }

        let t = n.dot(&p0.sub(&l0)) / denom;

        // punkt przecięcia
        Some(l0.add(&v.scale(t)))
    }
}

impl Sphere {
    // Implementacja przecięcia Sfera-Prosta
    pub fn intersect_line(&self, line: &Line) -> Vec<Vec3> {
        let l0 = line.point;
        let v = line.direction;
        let c = self.center;
        let r = self.radius;

        // Równanie: ||l0 + t*v - c||^2 = r^2
        // A*t^2 + B*t + C = 0
        // obliczamy nasze d
        let l0_minus_c = l0.sub(&c);

        // obliczenie współczynników A,B,C
        let a = v.dot(&v); // ||v||^2
        let b = 2.0 * v.dot(&l0_minus_c);
        let c_const = l0_minus_c.dot(&l0_minus_c) - r * r; // ||l0 - c||^2 - r^2

        // rozwiązywanie równania kwadratowego
        let delta = b * b - 4.0 * a * c_const;

        if delta < 0.0 {
            return vec![]; // Brak przecięcia
        }

        let mut points = Vec::new();

        if delta.abs() < 1e-6 {
            // Jeden punkt (styczność)
            let t = -b / (2.0 * a);
            points.push(l0.add(&v.scale(t)));
        } else {
            // Dwa punkty
            let sqrt_delta = delta.sqrt();
            let t1 = (-b + sqrt_delta) / (2.0 * a);
            let t2 = (-b - sqrt_delta) / (2.0 * a);

            points.push(l0.add(&v.scale(t1)));
            points.push(l0.add(&v.scale(t2)));
        }
        points
    }
}

impl Vec3 {
    pub fn is_between(&self, a: Vec3, b: Vec3) -> bool {
        let ab = b.sub(&a);
        let ap = self.sub(&a);

        // równoległość
        if ab.cross(ap).length() > 1e-6 {
            return false;
        }

        // czy leży między
        let dot = ap.dot(&ab);
        dot >= 0.0 && dot <= ab.dot(&ab)
    }
}

pub fn segment_intersection(a1: Vec3, a2: Vec3, b1: Vec3, b2: Vec3) -> Option<Vec3> {
    let line_a = Line {
        point: a1,
        direction: a2.sub(&a1),
    };
    let line_b = Line {
        point: b1,
        direction: b2.sub(&b1),
    };

    match line_a.intersects(&line_b) {
        Intersection::Point(p) => {
            // sprawdzenie czy P leży na obu odcinkach
            if p.is_between(a1, a2) && p.is_between(b1, b2) {
                Some(p)
            } else {
                None
            }
        }
        _ => None,
    }
}

pub fn angle_between_lines(a: &Line, b: &Line) -> f32 {
    // obliczamy kąt wykorzystując implementacje z vector.rs
    // używamy wyłącznie wektorów kierunkowych, nie obchodzi nas położenie, przesunięcie i punkt
    // początkowy prostych
    a.direction.angle(&b.direction)
}

pub fn angle_line_plane(line: &Line, plane: &Plane) -> f32 {
    // obliczenie kąta między normalną płaszczyzny a prostą
    let angle = line.direction.angle(&plane.normal);
    // alpha + beta to 90 stopni więc aby dostać kąt miedzy płaszczyzną a prostą musimy od 90 odjąć
    // obliczony kąt bo było to dopełnienie do 90 stopni
    std::f32::consts::FRAC_PI_2 - angle
}

pub fn angle_between_planes(a: &Plane, b: &Plane) -> f32 {
    // w przypadku płaszczyzn obliczamy kąt między normalnymi płaszczyzn
    a.normal.angle(&b.normal)
}
