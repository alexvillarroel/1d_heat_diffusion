import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:equations/equations.dart';

List<FlSpot> explicit_diffusion(int hora, int nt) {
  num L = 100;
  num W = 5.0;
  num R = 300.0;
  num D = 1200.0;
  num K = 1e-6;
  num day = 3600 * 24; // seconds per day
  num dt = 2 * day;
  //Numerical parameters
  num nx = 101; // Number of gridpoints in x-direction
  num nt = 48; // Number of timesteps to compute
  num dx = L / (nx - 1); // % Spacing of grid
  num alpha = K * dt / pow(dx, 2);
  Array x =
      linspace(-L / 2, L / 2, num: L ~/ dx); // Grid var range = 1..20.step(2);
  List<double> T = arrayMultiplyToScalar(ones(x.length), R);
  for (int i = 0; i < x.length; i++) {
    if (x[i].abs() <= W / 2) {
      T[i] = D.toDouble();
    }
  } // this for its like the function find in matlab, iterate the vector and
  // see a condition, if the condition is true, the value change
  List<FlSpot> listaSpots = [];
  double time = 0.0;
  num cfl = 2 * K * dt / pow(dx, 2);
  if (0 < cfl && cfl < 1) {
    for (int n = 1; n <= nt - 1; n++) {
      // iterating the time with timestep of 1 hour
      // Compute new temperature
      Array Tnew = zeros(nx as int); // zeros matrix
      for (int i = 1; i <= nx - 3; i++) {
        Tnew[i] = T![i] + alpha * (T[i + 1] - 2 * T[i] + T[i - 1]);
      }
      //Set boundary conditions
      Tnew[0] = T[0];
      Tnew[nx - 2] = T[nx - 2];
      // Update temperature and time
      T = Tnew;
      if (hora == n) {
        for (int i = 0; i < x.length; i++) {
          // List<double> z = lista[1];
          double x1 = x[i];
          double y = T[i];
          listaSpots.add(FlSpot(x1, y));
        }
      }
      time = time + dt;
    }
  } else {
    print('no se cumplen las condiciones ');
  }
  return listaSpots.toList();
}

List<FlSpot> implicit_diffusion(int hora, int nt) {
  num L = 100;
  num W = 5.0;
  double R = 300.0;
  double D = 1200.0;
  num K = 1e-6;
  num day = 3600 * 24; // seconds per day
  num dt = nt / 24 * day;
  //Numerical parameters
  int nx = 101; // Number of gridpoints in x-direction
  num dx = L / (nx - 1); // % Spacing of grid
  double s = K * dt / pow(dx, 2);
  Array x =
      linspace(-L / 2, L / 2, num: L ~/ dx); // Grid var range = 1..20.step(2);
  Array T = arrayMultiplyToScalar(ones(x.length), R);

  List<List<double>> matrix =
      List.generate(nt, (i) => List.generate(nx, (j) => R));
  List<List<double>> A = List.generate(nx, (i) => List.generate(nx, (j) => 0));
  //
  for (int j = 0; j < nt; j++) {
    matrix.add(T);
  }
  // we define matrix A with zeros
  // Array2d A = Array2d.fixed(nx, nx);
  // //
  for (int i = 0; i < nt; i++) {
    for (int j = 0; j < nx - 1; j++) {
      if (x[j].abs() <= W / 2) {
        matrix[i][j] = D;
      }
    }
  }
  // see a condition, if the condition is true, the value change
  // setting the boundary conditions
  A[0][0] = 1;
  A[nx - 1][nx - 1] = 1;
  for (int i = 1; i < nx - 1; i++) {
    A[i][i - 1] = -s;
    A[i][i] = (1 + 2 * s);
    A[i][i + 1] = -s;
  }
  // print('hola');
  for (int i = 1; i < nt; i++) {
    matrix[i] = LUSolver(
            matrix: RealMatrix.fromData(rows: nx, columns: nx, data: A),
            knownValues: matrix[i - 1])
        .solve();
  }
  List<FlSpot> listaSpots = [];
  for (int i = 0; i < x.length; i++) {
    listaSpots.add(FlSpot(x[i], matrix[hora][i]));
  }
  return listaSpots;
}
