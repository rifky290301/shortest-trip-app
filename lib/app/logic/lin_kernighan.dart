// class LinKernighan {
//   List<int> linKernighan(List<List<int>> distMatrix) {
//     int n = distMatrix.length;
//     List<int> tour = List<int>.generate(n, (i) => i); // Tur awal, misalnya 0-1-2-...-(n-1)
//     List<int> bestTour = List<int>.from(tour); // Tur terbaik yang ditemukan
//     int bestCost = calculateTourCost(distMatrix, bestTour); // Biaya tur terbaik

//     bool improved = true;
//     while (improved) {
//       improved = false;
//       for (int i = 0; i < n - 2; i++) {
//         for (int j = i + 2; j < n; j++) {
//           List<int> newTour = twoOptSwap(tour, i, j);
//           int newCost = calculateTourCost(distMatrix, newTour);

//           if (newCost < bestCost) {
//             bestTour = List<int>.from(newTour);
//             bestCost = newCost;
//             improved = true;
//           }
//         }
//       }
//       tour = List<int>.from(bestTour);
//     }

//     return bestTour;
//   }

//   int calculateTourCost(List<List<int>> distMatrix, List<int> tour) {
//     int totalCost = 0;
//     int n = tour.length;
//     for (int i = 0; i < n; i++) {
//       int from = tour[i];
//       int to = tour[(i + 1) % n];
//       totalCost += distMatrix[from][to];
//     }
//     return totalCost;
//   }

//   List<int> twoOptSwap(List<int> tour, int i, int j) {
//     int n = tour.length;
//     List<int> newTour = List<int>.from(tour);

//     while (i < j) {
//       int temp = newTour[i];
//       newTour[i] = newTour[j];
//       newTour[j] = temp;
//       i++;
//       j--;
//     }

//     return newTour;
//   }
// }
