class PropertyModel {
  final String id;
  final String name;
  final String city;
  final String country;
  final double price;
  final String image;
  final int rating;
  final int reviews;
  final String description;
  final int bedrooms;
  final int bathrooms;

  PropertyModel({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.price,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(0)}K';
  String get location => '$city, $country';
}
