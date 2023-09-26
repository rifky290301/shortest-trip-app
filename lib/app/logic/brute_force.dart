// class BF {
//   List<int> bruteForceTSP(List<List<double>> distMatrix) {
//     int n = distMatrix.length;
//     List<int> cities = List<int>.generate(n, (i) => i);
//     List<int> bestTour = [];
//     double minCost = double.infinity;

//     void permute(List<int> cities, int start, int end) {
//       if (start == end) {
//         double tourCost = calculateTourCostBruteForce(distMatrix, cities);
//         if (tourCost < minCost) {
//           minCost = tourCost;
//           bestTour = List<int>.from(cities);
//         }
//       } else {
//         for (int i = start; i <= end; i++) {
//           _swap(cities, start, i);
//           permute(cities, start + 1, end);
//           _swap(cities, start, i);
//         }
//       }
//     }

//     permute(cities, 0, n - 1);

//     return bestTour;
//   }

//   void _swap(List<int> list, int i, int j) {
//     int temp = list[i];
//     list[i] = list[j];
//     list[j] = temp;
//   }

//   double calculateTourCostBruteForce(List<List<double>> distMatrix, List<int> tour) {
//     double totalCost = 0;
//     int n = tour.length;
//     for (int i = 0; i < n; i++) {
//       int from = tour[i];
//       int to = tour[(i + 1) % n];
//       totalCost += distMatrix[from][to];
//     }
//     return totalCost;
//   }
// }
