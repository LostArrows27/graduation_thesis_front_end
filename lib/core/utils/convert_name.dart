// if pattern "Person Name" / "Noise Name"  => "Untitled"
String convertName(String name) {
  if (name.contains('Person') || name.contains('Noise')) return 'Untitled';
  return name;
}
  