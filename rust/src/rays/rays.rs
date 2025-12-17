use crate::{
    matrix::Mat,
    quat::Quat,
    vector::{Vec3, Vec4, VectorTrait},
};
use ratatui::{Frame, layout::Rect, style::Color};

/////////////////////////////////

pub struct Cube {
    rotation: Quat,
    scale: f32,
}

impl Default for Cube {
    fn default() -> Self {
        Self {
            rotation: Quat::from_xyzw(0.5, 1.0, 0., -0.4),
            scale: 0.5,
        }
    }
}

impl Cube {
    pub fn vertices(&self) -> [Vec3; 8] {
        [
            Vec3::new(-0.5, -0.5, -0.5), // 0
            Vec3::new(0.5, -0.5, -0.5),  // 1
            Vec3::new(0.5, 0.5, -0.5),   // 2
            Vec3::new(-0.5, 0.5, -0.5),  // 3
            Vec3::new(-0.5, -0.5, 0.5),  // 4
            Vec3::new(0.5, -0.5, 0.5),   // 5
            Vec3::new(0.5, 0.5, 0.5),    // 6
            Vec3::new(-0.5, 0.5, 0.5),   // 7
        ]
        .map(|v| self.rotation * v.scale(self.scale))
    }

    pub fn faces(&self) -> [([usize; 4], &str); 6] {
        [
            ([0, 3, 2, 1], "#"), // back  (-Z)
            ([4, 5, 6, 7], "@"), // front (+Z)
            ([0, 1, 5, 4], "+"), // bottom (-Y)
            ([3, 7, 6, 2], "*"), // top    (+Y)
            ([1, 2, 6, 5], "%"), // right  (+X)
            ([0, 4, 7, 3], "="), // left   (-X)
        ]
    }
}

////////////////////////////////

pub struct Camera(Mat);

impl Camera {
    pub fn new(fov_deg: f32, aspect: f32, near: f32, far: f32) -> Self {
        let fov_rad = fov_deg.to_radians();
        let f = 1.0 / (fov_rad / 2.0).tan();

        let mat = Mat::new(vec![
            vec![f / aspect, 0.0, 0.0, 0.0],
            vec![0.0, f, 0.0, 0.0],
            vec![
                0.0,
                0.0,
                -(far + near) / (far - near),
                -(2.0 * far * near) / (far - near),
            ],
            vec![0.0, 0.0, -1.0, 0.0],
        ]);

        Camera(mat)
    }

    pub fn matrix(&self) -> &Mat {
        &self.0
    }
}

////////////////////////////////

pub struct Render {
    cube: Cube,
}

impl Render {
    pub fn new() -> Render {
        Self {
            cube: Cube::default(),
        }
    }

    pub fn apply_rotation(&mut self, axis_x: f32, axis_y: f32, rotation_step: f32) {
        let angle_yaw = -axis_y * rotation_step;
        let angle_pitch = -axis_x * rotation_step;

        let rot_x = Quat::from_axis_angle([1.0, 0.0, 0.0], angle_pitch);
        let rot_y = Quat::from_axis_angle([0.0, 1.0, 0.0], angle_yaw);

        let combined_new_rotation = rot_y * rot_x;

        self.cube.rotation = combined_new_rotation * self.cube.rotation;
    }

    pub fn render(&mut self, rect: Rect, frame: &mut Frame) {
        let camera = Camera::new(45., rect.width as f32 / rect.height as f32, 0.1, 100.0);
        let faces = self.cube.faces();

        let mut faces_with_depth: Vec<_> = faces
            .iter()
            .enumerate()
            .map(|(i, (indices, face_symbol))| {
                let vertices = self.cube.vertices();
                let face_vertices: Vec<Vec3> = indices.iter().map(|&idx| vertices[idx]).collect();

                let avg_depth: f32 =
                    face_vertices.iter().map(|v| v.z).sum::<f32>() / face_vertices.len() as f32;

                (i, indices, *face_symbol, avg_depth)
            })
            .collect();

        faces_with_depth.sort_by(|a, b| b.3.partial_cmp(&a.3).unwrap());

        for x in 0..rect.width {
            for y in 0..rect.height {
                if let Some(cell) = frame.buffer_mut().cell_mut((x, y)) {
                    cell.set_bg(Color::DarkGray);
                }
            }
        }

        for (_, indices, face_symbol, _) in faces_with_depth {
            self.draw_face(indices, face_symbol, rect, frame, &camera);
        }
    }

    pub fn apply_zoom(&mut self, direction: f32) {
        const ZOOM_FACTOR: f32 = 1.1;

        let current_scale = self.cube.scale;
        let new_scale = if direction > 0.0 {
            current_scale * ZOOM_FACTOR
        } else {
            current_scale / ZOOM_FACTOR
        };

        let min_scale = 0.1;
        let max_scale = 5.0;

        self.cube.scale = new_scale.clamp(min_scale, max_scale);
    }

    fn is_backface(&self, view_vertices: &[Vec3; 4]) -> bool {
        let v0 = view_vertices[0];
        let v1 = view_vertices[1];
        let v2 = view_vertices[2];

        let e1 = v1.sub(&v0);
        let e2 = v2.sub(&v0);

        let normal = e1.cross(e2);

        let view_dir = Vec3::new(-v0.x, -v0.y, -v0.z);

        normal.dot(&view_dir) <= 0.0
    }

    fn draw_face(
        &self,
        indices: &[usize; 4],
        symbol: &str,
        rect: Rect,
        frame: &mut Frame,
        camera: &Camera,
    ) {
        let vertices = self.cube.vertices();

        let face_world_vertices: [Vec3; 4] = [
            vertices[indices[0]],
            vertices[indices[1]],
            vertices[indices[2]],
            vertices[indices[3]],
        ];

        let view_vertices = face_world_vertices.view_vertices();
        if self.is_backface(&view_vertices) {
            return;
        }

        let projection_vertices = view_vertices.project_vertices(camera);
        let ndc_vertices = projection_vertices.ndc_vertices();

        let mut screen_vertices: [(u16, u16, f32); 4] = [
            self.ndc_to_screen(ndc_vertices[0], rect),
            self.ndc_to_screen(ndc_vertices[1], rect),
            self.ndc_to_screen(ndc_vertices[2], rect),
            self.ndc_to_screen(ndc_vertices[3], rect),
        ];

        screen_vertices.iter_mut().enumerate().for_each(|(i, x)| {
            x.2 = view_vertices[i].z;
        });

        self.rasterize_quad(&screen_vertices, symbol, frame);
    }

    fn ndc_to_screen(&self, ndc_vert: Vec3, rect: Rect) -> (u16, u16, f32) {
        let x = ((ndc_vert.x + 1.0) * 0.5 * rect.width as f32).round() as u16;
        let y = ((1.0 - (ndc_vert.y / 2. + 1.0) * 0.5) * rect.height as f32).round() as u16;
        (x, y, 0.)
    }

    fn rasterize_quad(&self, vertices: &[(u16, u16, f32); 4], symbol: &str, frame: &mut Frame) {
        let mut min_x = vertices[0].0;
        let mut max_x = vertices[0].0;
        let mut min_y = vertices[0].1;
        let mut max_y = vertices[0].1;

        for &(x, y, _) in vertices.iter() {
            min_x = min_x.min(x);
            max_x = max_x.max(x);
            min_y = min_y.min(y);
            max_y = max_y.max(y);
        }

        for y in min_y..=max_y {
            let mut intersections = Vec::new();

            for i in 0..4 {
                let (x1, y1, z1) = vertices[i];
                let (x2, y2, z2) = vertices[(i + 1) % 4];

                let (y_min, x_at_min, z_at_min, y_max, x_at_max, z_at_max) = if y1 < y2 {
                    (y1, x1, z1, y2, x2, z2)
                } else {
                    (y2, x2, z2, y1, x1, z1)
                };

                if y >= y_min && y < y_max {
                    let t = (y as f32 - y_min as f32) / (y_max as f32 - y_min as f32);

                    let x = x_at_min as f32 + (x_at_max as f32 - x_at_min as f32) * t;
                    let z = z_at_min + (z_at_max - z_at_min) * t;

                    intersections.push((x, z));
                }
            }

            intersections.sort_by(|a, b| a.0.partial_cmp(&b.0).unwrap());

            for chunk in intersections.chunks(2) {
                if chunk.len() == 2 {
                    let (x_start, z_start) = chunk[0];
                    let (x_end, z_end) = chunk[1];

                    self.draw_horizontal_line(
                        (x_start as u16, x_end as u16),
                        y,
                        (z_start, z_end),
                        symbol,
                        frame,
                    );
                }
            }
        }
    }

    fn draw_horizontal_line(
        &self,
        start: (u16, u16),
        y: u16,
        end: (f32, f32),
        symbol: &str,
        frame: &mut Frame,
    ) {
        let (x_start, x_end) = start;
        let (z_start, z_end) = end;
        if x_start == x_end {
            return;
        }

        let ((x_start, z1), (x_end, z2)) = if x_start < x_end {
            ((x_start, z_start), (x_end, z_end))
        } else {
            ((x_end, z_end), (x_start, z_start))
        };

        let length = (x_end - x_start) as f32;

        for x in x_start..x_end {
            let t = if length > 0.0 {
                (x - x_start) as f32 / length
            } else {
                0.0
            };
            let z = z1 * (1.0 - t) + z2 * t;

            if let Some(cell) = frame.buffer_mut().cell_mut((x, y)) {
                let color = self.shade_color_distance(z);
                cell.set_symbol(symbol).set_fg(color).set_bg(color);
            }
        }
    }

    fn shade_color_distance(&self, dist: f32) -> Color {
        let min_dist = -0.2;
        let max_dist = 1.4;

        let t = ((dist - min_dist) / (max_dist - min_dist)).clamp(0.0, 1.0);

        let brightness = 0.85 - t;

        let gray = (brightness * 255.0).round() as u8;
        Color::Rgb(gray, gray, gray)
    }
}

trait Mvp<const N: usize> {
    fn view_vertices(self) -> [Vec3; N];
    fn project_vertices(self, camera: &Camera) -> [Vec4; N];
}

impl Mvp<8> for [Vec3; 8] {
    fn view_vertices(self) -> [Vec3; 8] {
        self.map(|v| v.add(&Vec3::new(0.0, 0., 1.)))
    }

    fn project_vertices(self, camera: &Camera) -> [Vec4; 8] {
        self.map(|v| &Vec4::from(v) * camera.matrix())
    }
}

impl Mvp<4> for [Vec3; 4] {
    fn view_vertices(self) -> [Vec3; 4] {
        self.map(|v| v.add(&Vec3::new(0.0, 0., 1.)))
    }

    fn project_vertices(self, camera: &Camera) -> [Vec4; 4] {
        self.map(|v| &Vec4::from(v) * camera.matrix())
    }
}

trait Ndc<const N: usize> {
    fn ndc_vertices(self) -> [Vec3; N];
}

impl Ndc<8> for [Vec4; 8] {
    fn ndc_vertices(self) -> [Vec3; 8] {
        self.map(|v| v.to_ndc())
    }
}

impl Ndc<4> for [Vec4; 4] {
    fn ndc_vertices(self) -> [Vec3; 4] {
        self.map(|v| v.to_ndc())
    }
}
