mod matrix;
mod vector;
use matrix::Matrix;
use vector::Vector;

fn main() {
    // let v1 = Vector::new([0.0, 3.0, 0.0]);
    // let v2 = Vector::new([5.0, 5.0, 0.0]);
    //
    // println!("{:?}", v1.angle(v2).expect("angle").to_degrees());
    //
    // let v1 = Vector::new([4.0, 5.0, 1.0]);
    // let v2 = Vector::new([4.0, 1.0, 3.0]);
    //
    // println!("{:?}", v1.cross(v2));
    // println!("{:?}", v1.cross(v2).normalize());

    let a = Matrix::new(vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 5.0, 6.0],
        vec![7.0, 8.0, 10.0],
    ]);

    let b = Matrix::new(vec![
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

    let mul = a.mul(&b);
    println!("A * B:\n{}", mul);

    let det_a = a.determinant();
    println!("det(A) = {:.3}", det_a);

    if det_a != 0.0 {
        let inv_a = a.inverse();
        println!("A^-1:\n{}", inv_a);

        // Verify A * A^-1 ≈ I
        let identity_test = a.mul(&inv_a);
        println!("A * A^-1  Identity:\n{}", identity_test);
    }

    let vec = Matrix::new(vec![vec![1.0], vec![0.0], vec![0.0], vec![1.0]]);
    let rotation_y_90 = Matrix::rotate_y(std::f32::consts::FRAC_PI_2); // 90 degree

    let rotated_vec = rotation_y_90.mul(&vec);
    println!("Vector [1,0,0,1] rotated 90 around y:\n{}", rotated_vec);

    let ab = a.mul(&b);
    let ba = b.mul(&a);

    println!("A * B:\n{}", ab);
    println!("B * A:\n{}", ba);
}
