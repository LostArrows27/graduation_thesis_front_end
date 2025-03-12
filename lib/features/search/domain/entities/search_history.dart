class SearchHistory {
  final String searchHistoryId;
  final List<SearchResult> result;

  SearchHistory({
    required this.searchHistoryId,
    required this.result,
  });
}

class SearchResult {
  final String imageId;
  final String imageName;
  final String imageBucketId;
  final double similarity;

  SearchResult({
    required this.imageId,
    required this.imageName,
    required this.imageBucketId,
    required this.similarity,
  });

  factory SearchResult.fromJson(Map<String, dynamic> map) {
    return SearchResult(
      imageId: map['image_id'],
      imageName: map['image_name'],
      imageBucketId: map['image_bucket_id'],
      similarity: map['similarity'] as double,
    );
  }
}

// {
//     "search_history_id": "8e0417a7-6ded-495b-9664-08d4aa70ba29",
//     "result": [
//         {
//             "image_id": "a0eccafa-fb8e-489f-8298-645a9311c15f",
//             "image_name": "e6a99c3a-4b41-4f49-98b7-d97afedf4f66/42bb16d0-f8ae-11ef-bce2-979d90af3731",
//             "image_bucket_id": "gallery_image",
//             "similarity": 0.272006452083588
//         },
//         {
//             "image_id": "267b2668-18de-4aff-a176-bb249409a5a8",
//             "image_name": "e6a99c3a-4b41-4f49-98b7-d97afedf4f66/22f30600-f39a-11ef-a8c8-433160ec853f",
//             "image_bucket_id": "gallery_image",
//             "similarity": 0.272006452083588
//         },
//         {
//             "image_id": "a01bacdc-f333-497a-a8a2-90a80e882cf0",
//             "image_name": "e6a99c3a-4b41-4f49-98b7-d97afedf4f66/IMG_1707991192334_1730885652442.jpg",
//             "image_bucket_id": "gallery_image",
//             "similarity": 0.240556448698044
//         }
//     ]
// }