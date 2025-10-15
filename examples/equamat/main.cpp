#include "Kokkos_Core.hpp"
#include <random>

#define N 50u

template <Kokkos::ConstExprLabel Label>
void init_array(Kokkos::View<Label, float **> &array, unsigned n) {

  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_real_distribution<float> dis(0.0, 1.0);

  for (unsigned i = 0; i < n; i++)
    for (unsigned j = 0; j < n; j++)
      array(i, j) = dis(gen);
}

template <Kokkos::ConstExprLabel Label>
void print_array(Kokkos::View<Label, float **> &array, unsigned n) {
  for (unsigned i = 0; i < n; i++) {
    for (unsigned j = 0; j < n; j++)
      printf("%f ", array(i, j));
    printf("\n ");
  }
}

template <Kokkos::ConstExprLabel Label1, Kokkos::ConstExprLabel Label2,
          Kokkos::ConstExprLabel Label3>
void function(Kokkos::View<Label1, float **> &A,
              Kokkos::View<Label2, float **> &B,
              Kokkos::View<Label3, float **> &C, unsigned n) {

  auto policy = Kokkos::MDRangePolicy<Kokkos::Rank<2>>({0, 0}, {n, n});

  Kokkos::parallel_for<Kokkos::usePolyOpt>(
      "kernel", policy,
      KOKKOS_LAMBDA(const unsigned long i, const unsigned long j) {
        C(i, j) = (A(i, j) + B(i, j)) / 2;
      });
}

int main(int argc, char **argv) {
  Kokkos::initialize();
  {
    Kokkos::View<"A", float **> A("A", N, N);
    Kokkos::View<"B", float **> B("B", N, N);
    Kokkos::View<"C", float **> C("C", N, N);
    init_array(A, N);
    init_array(B, N);
    init_array(C, N);
    function(A, B, C, N);

    if (argc > 1)
      print_array(C, N);
  }
  Kokkos::finalize();

  return 0;
}