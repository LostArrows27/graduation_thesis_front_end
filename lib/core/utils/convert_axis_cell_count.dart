List<int> convertAxisCellCount(int index, int total) {
  // case left not make up a 6 tile -> special layout
  final diff = total - (index + 1);
  final left = total % 6;

  if (left != 0 && left != 3 && diff < left) {
    switch (left) {
      case 1:
        return [3, 2];
      case 2:
        if (diff == 0) {
          return [2, 2];
        }

        if (diff == 1) {
          return [1, 2];
        }
      case 4:
        if (diff == 0) {
          return [3, 1];
        }

        if (diff == 1) {
          return [1, 1];
        }

        if (diff == 2) {
          return [1, 1];
        }

        if (diff == 3) {
          return [2, 2];
        }
      case 5:
        if (diff == 0) {
          return [2, 1];
        }

        if (diff == 1) {
          return [1, 1];
        }

        if (diff == 2) {
          return [1, 1];
        }

        if (diff == 3) {
          return [1, 1];
        }

        if (diff == 4) {
          return [2, 2];
        }
      default:
        return [3, 3];
    }
  }

  switch (index % 6) {
    case 0:
      return [2, 2];
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      return [1, 1];
    default:
      return [2, 2];
  }
}
