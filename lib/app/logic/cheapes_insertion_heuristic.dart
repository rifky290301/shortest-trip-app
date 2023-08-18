class CIH {
  List<int> cheapestInsertion({required List<List<double>> distMatrix, required int start}) {
    int n = distMatrix.length;
    List<int> tour = [start];
    Set<int> unvisited = Set<int>.from(List<int>.generate(n, (index) => index));
    unvisited.remove(start);

    while (unvisited.isNotEmpty) {
      // Find cheapest edge from unvisited to visited nodes
      double minCost = double.infinity;
      int bestInsert = -1;
      for (int i = 0; i < tour.length; i++) {
        for (int j in unvisited) {
          double cost = distMatrix[tour[i]][j] + distMatrix[j][tour[(i + 1) % tour.length]];
          if (cost < minCost) {
            minCost = cost;
            bestInsert = j;
          }
        }
      }

      // Insert node with cheapest edge into tour
      int bestIndex = 0;
      double bestCost = double.infinity;
      for (int i = 0; i < tour.length; i++) {
        double cost = distMatrix[tour[i]][bestInsert] + distMatrix[bestInsert][tour[(i + 1) % tour.length]];
        if (cost < bestCost) {
          bestCost = cost;
          bestIndex = i + 1;
        }
      }
      tour.insert(bestIndex, bestInsert);
      unvisited.remove(bestInsert);
    }

    return tour;
  }

  double calculateTourCost(List<List<double>> distMatrix, List<int> tour) {
    double totalCost = 0;
    int n = tour.length;
    for (int i = 0; i < n; i++) {
      int from = tour[i];
      int to = tour[(i + 1) % n];
      totalCost += distMatrix[from][to];
      print('from : $from, to : $to, cost : ${distMatrix[from][to]}');
    }
    return totalCost;
  }
}
