mod geometry;
mod matrix;
mod quat;
mod rays;
mod vector;
use std::{
    io::stdout,
    ops::{Add, Sub},
};

use crossterm::{
    event::{
        self, DisableMouseCapture, EnableMouseCapture, Event, KeyCode, KeyEventKind, MouseButton,
        MouseEventKind,
    },
    execute,
    terminal::{EnterAlternateScreen, LeaveAlternateScreen, disable_raw_mode, enable_raw_mode},
};
use matrix::Mat;
use quat::*;
use ratatui::{
    Terminal,
    prelude::CrosstermBackend,
    style::{Color, Style},
};
use vector::*;

use crate::{
    geometry::{Line, Sphere},
    rays::rays::Render,
};

fn main() -> anyhow::Result<()> {
    // 1. Setup terminal (włączamy tryb raw)
    // UWAGA: Potrzebujemy enable_raw_mode do pełnej obsługi myszki.
    enable_raw_mode()?;

    // Włączamy AlternateScreen ORAZ Przechwytywanie Myszki
    execute!(stdout(), EnterAlternateScreen, EnableMouseCapture)?;

    let backend = CrosstermBackend::new(stdout());
    let mut terminal = Terminal::new(backend)?;
    terminal.clear()?;

    let mut render = Render::new();
    let mut is_dragging = false;
    let mut last_mouse_pos: Option<(u16, u16)> = None;

    loop {
        if event::poll(std::time::Duration::from_millis(16))? {
            match event::read()? {
                // Wyjście z programu
                Event::Key(key) if key.code == KeyCode::Esc && key.kind == KeyEventKind::Press => {
                    break;
                }

                Event::Key(key) if key.kind == KeyEventKind::Press => {
                    match key.code {
                        KeyCode::Char('w') => render.apply_rotation(1.0, 0.0, 60f32.to_radians()), // W: Góra (Obrót wokół X)
                        KeyCode::Char('s') => render.apply_rotation(-1.0, 0.0, 60f32.to_radians()), // S: Dół (Obrót wokół X)

                        KeyCode::Char('a') => render.apply_rotation(0.0, 1.0, 60f32.to_radians()), // A: Lewo (Obrót wokół Y)
                        KeyCode::Char('d') => render.apply_rotation(0.0, -1.0, 60f32.to_radians()), // D: Prawo (Obrót wokół Y)
                        _ => {}
                    }
                }

                Event::Mouse(event) if event.kind == MouseEventKind::Down(MouseButton::Left) => {
                    last_mouse_pos = Some((event.column, event.row));
                }

                Event::Mouse(event) if event.kind == MouseEventKind::Up(MouseButton::Left) => {
                    last_mouse_pos = None;
                }

                Event::Mouse(event) if event.kind == MouseEventKind::ScrollUp => {
                    render.apply_zoom(1.0);
                }

                // --- Obsługa Scroll Down (Zoom Out) ---
                Event::Mouse(event) if event.kind == MouseEventKind::ScrollDown => {
                    render.apply_zoom(-1.0);
                }

                Event::Mouse(event) if event.kind == MouseEventKind::Drag(MouseButton::Left) => {
                    if let Some((last_x, last_y)) = last_mouse_pos {
                        let dx = event.column as f32 - last_x as f32;
                        let dy = event.row as f32 - last_y as f32;

                        render.apply_rotation(-dy, -dx, 90f32.to_radians());

                        last_mouse_pos = Some((event.column, event.row));
                    }
                }

                _ => {}
            }
        }

        terminal.draw(|f| {
            let size = f.area();
            render.render(size, f); // Pańska funkcja rysująca kostkę
        })?;
    }

    // 3. Cleanup (wyłączamy tryb raw)
    execute!(
        terminal.backend_mut(),
        LeaveAlternateScreen,
        DisableMouseCapture
    )?;
    disable_raw_mode()?; // Wyłączamy tryb raw
    terminal.show_cursor()?;

    Ok(())
}

pub fn test_quat() {
    let axis_q = Quat::from_axis_angle([1.0, 0.0, 0.0], 270.);
    let point = Vec3::from([-1.0, -1.0, -1.0]);

    let rotated = (axis_q).rotate_vector(point);
    println!("Obrócony Punkt: {:?}", rotated);
    let rotated = (axis_q.negate()).rotate_vector(point);
    println!("Obrócony Punkt: {:?}", rotated);

    // testowanko mnożenia kwaternionów
    let q1 = Quat::from_axis_angle([1.0, 0.0, 0.0], 270.);
    let q2 = Quat::from_axis_angle([1.0, 0.0, 0.0], 90.);
    println!("Q1: {}\nQ2: {}", q1, q2);

    println!("Mnożenie1: {}", q1 * q2);
    println!("Mnożenie2: {}", q2 * q1);

    let q1 = Quat::from_axis_angle([1.0, 0.0, 0.0], 270.);
    let q2 = Quat::from_axis_angle([1.0, 1.0, -1.0], 90.);
    println!("Dodawanie: {}", q1 + q2);

    let q1 = Quat::from_axis_angle([1.0, 0.0, 0.0], 270.);
    let q2 = Quat::from_axis_angle([1.0, 1.0, -1.0], 90.);
    println!("Odejmowanie: {}", q1 - q2);

    let q1 = Quat::from_axis_angle([1.0, 0.0, 0.0], 270.);
    let q2 = Quat::from_axis_angle([1.0, 1.0, -1.0], 90.);
    println!("Dzielenie: {}", q1 / q2);
}

pub fn test_vector() {
    let v1 = Vec3::from([0.0, 3.0, 0.0]);
    let v2 = Vec3::from([5.0, 5.0, 0.0]);

    println!("{:?}", v1.angle(&v2).to_degrees());

    let v1 = Vec3::from([4.0, 5.0, 1.0]);
    let v2 = Vec3::from([4.0, 1.0, 3.0]);

    println!("{:?}", v1.cross(v2));
    println!("{:?}", v1.cross(v2).normalize());
}

pub fn test_matrix() {
    let a = Mat::new(vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 5.0, 6.0],
        vec![7.0, 8.0, 10.0],
    ]);

    let b = Mat::new(vec![
        vec![2.0, 0.0, 1.0],
        vec![0.0, 1.0, 0.0],
        vec![1.0, 0.0, 1.0],
    ]);

    println!("Matrix A:\n{}", a);
    println!("Matrix B:\n{}", b);

    let add = a.add(&b);
    println!("A + B:\n{}", add);

    let sub = a.sub(&b);
    println!("A - B:\n{}", sub);

    let scalar = a.scalar(2.0);
    println!("A * 2:\n{}", scalar);

    let transpose = a.transpose();
    println!("A^T:\n{}", transpose);

    let mul = &a * &b;
    println!("A * B:\n{}", mul);

    let det_a = a.determinant();
    println!("det(A) = {:.3}", det_a);

    if det_a != 0.0 {
        let inv_a = a.inverse();
        println!("A^-1:\n{}", inv_a);

        // Verify A * A^-1 ≈ I
        let identity_test = a.multiply(&inv_a);
        println!("A * A^-1  Identity:\n{}", identity_test);
    }

    let vec = Mat::new(vec![vec![1.0], vec![0.0], vec![0.0], vec![1.0]]);
    let rotation_y_90 = Mat::rotate_y(std::f32::consts::FRAC_PI_2); // 90 degree

    let rotated_vec = rotation_y_90 * vec;
    println!("Vector [1,0,0,1] rotated 90 around y:\n{}", rotated_vec);

    let ab = &a * &b;
    let ba = b * a;

    println!("A * B:\n{}", ab);
    println!("B * A:\n{}", ba);

    let mat = Mat::scale(3., 3., 3.);
    let det = mat.determinant();
    println!("B * A:\n{}", mat);
    println!("{}", det);
}

pub fn test_geometry() {
    // --- ZNAJDŹ PUNKT PRZECIĘCIA PROSTYCH ---
    println!("--- 1. Przecięcie Prostych ---");
    // Prosta A: (x+2)/3 = y-4 = z/5
    let line_a = geometry::Line {
        point: Vec3::new(-2.0, 4.0, 0.0),
        direction: Vec3::new(3.0, 1.0, 5.0),
    };

    // Prosta B: (x+2)/1 = (y-4)/(-5) = z/3
    let line_b = geometry::Line {
        point: Vec3::new(-2.0, 4.0, 0.0),
        direction: Vec3::new(1.0, -5.0, 3.0),
    };
    match line_a.intersects(&line_b) {
        geometry::Intersection::Point(p) => {
            println!("Punkt przecięcia P: {:?}", p);
        }
        geometry::Intersection::Parallel => println!("Proste są równoległe (nie przecinają się)."),
        geometry::Intersection::Colinear => println!("Proste są współliniowe (nakładają się)."),
        geometry::Intersection::Skew => println!("Proste są skośne (nie przecinają się)."),
    }

    // --- ZNAJDŹ KĄT MIĘDZY PROSTYMI Z ZADANIA 1 ---
    println!("\n--- 2. Kąt Między Prostymi A i B ---");
    let angle_lines = geometry::angle_between_lines(&line_a, &line_b);
    println!("Kąt: {:.4} radianów", angle_lines);
    println!("Kąt: {:.2} stopni", angle_lines.to_degrees());

    // --- ZNAJDŹ PUNKT PRZECIĘCIA PROSTEJ I PŁASZCZYZNY ---
    println!("\n--- 3. Przecięcie Prostej i Płaszczyzny ---");
    // Prosta L: x = -2 + 3t, y = 2 - t, z = -1 + 2t
    let line_3 = geometry::Line {
        point: Vec3::new(-2.0, 2.0, -1.0),
        direction: Vec3::new(3.0, -1.0, 2.0),
    };
    // Płaszczyzna P: 2x + 3y + 3z - 8 = 0
    let plane_3 = geometry::Plane {
        normal: Vec3::new(2.0, 3.0, 3.0),
        point: Vec3::new(4.0, 0.0, 0.0),
    };

    match plane_3.intersect_line(&line_3) {
        Some(p) => println!("Punkt przecięcia P: {:?}", p),
        None => println!("Prosta jest równoległa do płaszczyzny (lub w niej leży)."),
    }

    // --- ZNAJDŹ KĄT MIĘDZY PROSTĄ A PŁASZCZYZNĄ Z ZADANIA 3 ---
    println!("\n--- 4. Kąt Prosta/Płaszczyzna ---");
    let angle_line_plane = geometry::angle_line_plane(&line_3, &plane_3);
    println!("Kąt: {:.4} radianów", angle_line_plane);
    println!("Kąt: {:.2} stopni", angle_line_plane.to_degrees());

    // --- ZNAJDŹ PROSTĄ PRZECIĘCIA PŁASZCZYZN ---
    println!("\n--- 5. Prosta Przecięcia Płaszczyzn ---");
    // Płaszczyzna A: 2x - y + z - 8 = 0
    let plane_a = geometry::Plane {
        normal: Vec3::new(2.0, -1.0, 1.0),
        point: Vec3::new(4.0, 0.0, 0.0),
    };
    // Płaszczyzna B: 4x + 3y + z + 14 = 0
    let plane_b = geometry::Plane {
        normal: Vec3::new(4.0, 3.0, 1.0),
        point: Vec3::new(0.0, 0.0, -14.0),
    };

    match geometry::Plane::intersect_planes(&plane_a, &plane_b) {
        Some(line) => {
            println!("Prosta L: P = {:?}, V = {:?}", line.point, line.direction);
        }
        None => println!("Płaszczyzny są równoległe lub identyczne."),
    }

    // --- ZNAJDŹ KĄT MIĘDZY PŁASZCZYZNAMI Z ZADANIA 5 ---
    println!("\n--- 6. Kąt Między Płaszczyznami A i B ---");
    let angle_planes = geometry::angle_between_planes(&plane_a, &plane_b);
    println!("Kąt: {:.4} radianów", angle_planes);
    println!("Kąt: {:.2} stopni", angle_planes.to_degrees());

    // --- ZNAJDŹ PUNKT PRZECIĘCIA DWÓCH ODCINKÓW ---
    println!("\n--- 7. Przecięcie Odcinków ---");
    // Odcinek 1: A=(5,5,4), A'=(10,10,6)
    let a1 = Vec3::new(5.0, 5.0, 4.0);
    let a2 = Vec3::new(10.0, 10.0, 6.0);
    // Odcinek 2: B=(5,5,5), B'=(10,10,3)
    let b1 = Vec3::new(5.0, 5.0, 5.0);
    let b2 = Vec3::new(10.0, 10.0, 3.0);

    match geometry::segment_intersection(a1, a2, b1, b2) {
        Some(p) => println!("Punkt przecięcia odcinków P: {:?}", p),
        None => println!("Odcinki nie przecinają się."),
    }

    // --- ZNAJDŹ PUNKT PRZECIĘCIA SFERY I PROSTEJ ---
    println!("\n--- 1. Przecięcie Sfery i Prostej ---");
    // Sfera: C=(0,0,0), R=sqrt(26)
    let sphere = geometry::Sphere {
        center: Vec3::new(0.0, 0.0, 0.0),
        radius: (26.0f32).sqrt(),
    };
    // Prosta: przechodząca przez A=(3,-1,-2) i A'=(5,3,-4)
    let a = Vec3::new(3.0, -1.0, -2.0);
    let a_prime = Vec3::new(5.0, 3.0, -4.0);

    let line = geometry::Line {
        point: a,
        direction: a_prime.sub(&a),
    };

    let intersection_points = sphere.intersect_line(&line);

    if intersection_points.is_empty() {
        println!("Brak punktów przecięcia.");
    } else {
        println!("Punkty przecięcia: {:?}", intersection_points);
    }
}
