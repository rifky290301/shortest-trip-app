// class NIH {
//   static List<int> nearestInsertionHeuristic({required List<List<double>> distMatrix}) {
//     int n = distMatrix.length;
//     List<int> tour = [0, 0];
//     List<int> cities = List<int>.generate(n, (i) => i);
//     cities.removeAt(0);
//     int nearestCity = _findNearestCity(distMatrix, 0, cities);
//     tour[0] = nearestCity;
//     tour[1] = 0;
//     cities.remove(nearestCity);
//     int i = 1;
//     while (cities.isNotEmpty) {
//       nearestCity = _findNearestCity(distMatrix, tour[i], cities);
//       int minCost = double.infinity.toInt();
//       int minIndex = 0;
//       for (int j = 0; j < i; j++) {
//         int cost = (distMatrix[tour[j]][nearestCity] + distMatrix[nearestCity][tour[j + 1]] - distMatrix[tour[j]][tour[j + 1]]).toInt();
//         if (cost < minCost) {
//           minCost = cost;
//           minIndex = j;
//         }
//       }
//       tour.insert(minIndex + 1, nearestCity);
//       cities.remove(nearestCity);
//       i++;
//     }
//     return tour;
//   }

//   static int _findNearestCity(List<List<double>> distMatrix, int city, List<int> cities) {
//     int nearestCity = 0;
//     double minDistance = double.infinity;
//     for (int i = 0; i < cities.length; i++) {
//       if (distMatrix[city][cities[i]] < minDistance) {
//         minDistance = distMatrix[city][cities[i]];
//         nearestCity = cities[i];
//       }
//     }
//     return nearestCity;
//   }
// }
